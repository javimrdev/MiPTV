use crate::error::XmltvError;
use core_domain::models::EpgEntry;
use quick_xml::events::Event;
use quick_xml::Reader;

/// Parse an XMLTV document and return all programme entries as [`EpgEntry`].
pub fn parse(xml: &str) -> Result<Vec<EpgEntry>, XmltvError> {
    let mut reader = Reader::from_str(xml);
    reader.config_mut().trim_text(true);

    let mut entries = Vec::new();
    let mut current: Option<PartialEntry> = None;
    let mut in_title = false;
    let mut in_desc = false;
    let mut in_category = false;

    let mut buf = Vec::new();

    loop {
        match reader.read_event_into(&mut buf) {
            Ok(Event::Start(ref e)) => match e.name().as_ref() {
                b"programme" => {
                    current = Some(parse_programme_attrs(e)?);
                }
                b"title" if current.is_some() => in_title = true,
                b"desc" if current.is_some() => in_desc = true,
                b"category" if current.is_some() => in_category = true,
                _ => {}
            },
            Ok(Event::Text(ref e)) => {
                if let Some(ref mut entry) = current {
                    let text = e.unescape().unwrap_or_default().into_owned();
                    if in_title {
                        entry.title = text;
                    } else if in_desc && !text.is_empty() {
                        entry.description = Some(text);
                    } else if in_category && !text.is_empty() {
                        entry.category = Some(text);
                    }
                }
            }
            Ok(Event::End(ref e)) => match e.name().as_ref() {
                b"title" => in_title = false,
                b"desc" => in_desc = false,
                b"category" => in_category = false,
                b"programme" => {
                    if let Some(partial) = current.take() {
                        if !partial.title.is_empty() {
                            entries.push(EpgEntry {
                                channel_id: partial.channel_id,
                                title: partial.title,
                                description: partial.description,
                                start: partial.start,
                                end: partial.end,
                                category: partial.category,
                                poster_url: None,
                            });
                        }
                    }
                }
                _ => {}
            },
            Ok(Event::Eof) => break,
            Err(e) => return Err(XmltvError::from(e)),
            _ => {}
        }
        buf.clear();
    }

    Ok(entries)
}

struct PartialEntry {
    channel_id: String,
    start: i64,
    end: i64,
    title: String,
    description: Option<String>,
    category: Option<String>,
}

fn parse_programme_attrs(e: &quick_xml::events::BytesStart) -> Result<PartialEntry, XmltvError> {
    let mut channel_id = None;
    let mut start = None;
    let mut end = None;

    for attr in e.attributes().flatten() {
        match attr.key.as_ref() {
            b"channel" => {
                channel_id = Some(String::from_utf8_lossy(&attr.value).into_owned());
            }
            b"start" => {
                start = Some(parse_xmltv_timestamp(&String::from_utf8_lossy(&attr.value))?);
            }
            b"stop" => {
                end = Some(parse_xmltv_timestamp(&String::from_utf8_lossy(&attr.value))?);
            }
            _ => {}
        }
    }

    Ok(PartialEntry {
        channel_id: channel_id.ok_or_else(|| XmltvError::MissingAttribute("channel".into()))?,
        start: start.ok_or_else(|| XmltvError::MissingAttribute("start".into()))?,
        end: end.ok_or_else(|| XmltvError::MissingAttribute("stop".into()))?,
        title: String::new(),
        description: None,
        category: None,
    })
}

/// Parse XMLTV timestamp format: `YYYYMMDDHHmmss +HHMM`
/// Returns Unix timestamp in seconds (UTC).
fn parse_xmltv_timestamp(s: &str) -> Result<i64, XmltvError> {
    let s = s.trim();
    if s.len() < 14 {
        return Err(XmltvError::InvalidTimestamp(s.to_string()));
    }

    let digits = &s[..14];
    let year: i64 = digits[0..4]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;
    let month: i64 = digits[4..6]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;
    let day: i64 = digits[6..8]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;
    let hour: i64 = digits[8..10]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;
    let minute: i64 = digits[10..12]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;
    let second: i64 = digits[12..14]
        .parse()
        .map_err(|_| XmltvError::InvalidTimestamp(s.to_string()))?;

    // Parse optional timezone offset (+HHMM or -HHMM)
    let tz_offset_secs = if s.len() >= 20 {
        let tz = s[14..].trim();
        if tz.len() >= 5 {
            let sign: i64 = if tz.starts_with('-') { -1 } else { 1 };
            let hh: i64 = tz[1..3].parse().unwrap_or(0);
            let mm: i64 = tz[3..5].parse().unwrap_or(0);
            sign * (hh * 3600 + mm * 60)
        } else {
            0
        }
    } else {
        0
    };

    // Days in each month (non-leap year; close enough for EPG)
    let days_in_month = [0i64, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    let is_leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

    let mut days_from_epoch: i64 = 0;
    for y in 1970..year {
        let leap = (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;
        days_from_epoch += if leap { 366 } else { 365 };
    }
    for m in 1..month {
        let d = days_in_month[m as usize];
        days_from_epoch += if m == 2 && is_leap { d + 1 } else { d };
    }
    days_from_epoch += day - 1;

    let unix = days_from_epoch * 86400 + hour * 3600 + minute * 60 + second - tz_offset_secs;
    Ok(unix)
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE_XML: &str = r#"<?xml version="1.0" encoding="UTF-8"?>
<tv>
  <programme start="20240115220000 +0000" stop="20240115230000 +0000" channel="bbc1.uk">
    <title lang="en">News at Ten</title>
    <desc lang="en">Daily news programme.</desc>
    <category lang="en">News</category>
  </programme>
  <programme start="20240115230000 +0000" stop="20240116000000 +0000" channel="bbc1.uk">
    <title lang="en">The Late Show</title>
  </programme>
  <programme start="20240115200000 +0100" stop="20240115210000 +0100" channel="cnn">
    <title lang="en">World News</title>
  </programme>
</tv>"#;

    #[test]
    fn parse_returns_all_programmes() {
        let entries = parse(SAMPLE_XML).unwrap();
        assert_eq!(entries.len(), 3);
    }

    #[test]
    fn first_entry_fields() {
        let entries = parse(SAMPLE_XML).unwrap();
        let e = &entries[0];
        assert_eq!(e.channel_id, "bbc1.uk");
        assert_eq!(e.title, "News at Ten");
        assert_eq!(e.description, Some("Daily news programme.".into()));
        assert_eq!(e.category, Some("News".into()));
    }

    #[test]
    fn entry_without_desc_has_none() {
        let entries = parse(SAMPLE_XML).unwrap();
        assert!(entries[1].description.is_none());
    }

    #[test]
    fn timestamp_utc_parsed_correctly() {
        // 20240115220000 +0000 → 2024-01-15 22:00:00 UTC
        let ts = parse_xmltv_timestamp("20240115220000 +0000").unwrap();
        // Verify reasonable range (after 2020-01-01 and before 2030-01-01)
        assert!(ts > 1_577_836_800);
        assert!(ts < 1_893_456_000);
    }

    #[test]
    fn timestamp_with_positive_offset() {
        // +0100 means UTC+1, so local 20:00 → UTC 19:00
        let ts_utc = parse_xmltv_timestamp("20240115200000 +0100").unwrap();
        let ts_utc_direct = parse_xmltv_timestamp("20240115190000 +0000").unwrap();
        assert_eq!(ts_utc, ts_utc_direct);
    }

    #[test]
    fn empty_xml_returns_empty_vec() {
        let entries = parse("<tv></tv>").unwrap();
        assert!(entries.is_empty());
    }
}
