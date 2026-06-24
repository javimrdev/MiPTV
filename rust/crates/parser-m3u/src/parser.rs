use crate::error::ParseError;
use core_domain::models::Channel;
use std::collections::HashMap;

/// Parse an M3U/M3U8 playlist string into a list of channels.
///
/// Supports the `#EXTM3U` header and `#EXTINF` directives with
/// optional attributes: `tvg-id`, `tvg-name`, `tvg-logo`, `group-title`.
pub fn parse(provider_id: &str, input: &str) -> Result<Vec<Channel>, ParseError> {
    let mut lines = input.lines().peekable();

    // Validate header
    match lines.next() {
        Some(h) if h.trim().starts_with("#EXTM3U") => {}
        _ => return Err(ParseError::MissingHeader),
    }

    let mut channels = Vec::new();
    let mut pending_attrs: Option<HashMap<String, String>> = None;
    let mut pending_name: Option<String> = None;
    let mut entry_index: u32 = 0;

    for line in lines {
        let line = line.trim();
        if line.is_empty() || (line.starts_with('#') && !line.starts_with("#EXTINF")) {
            continue;
        }

        if let Some(rest) = line.strip_prefix("#EXTINF:") {
            let (attrs, display_name) = parse_extinf(rest)?;
            pending_attrs = Some(attrs);
            pending_name = Some(display_name);
        } else if !line.starts_with('#') {
            // This is a stream URL
            let stream_url = line.to_string();
            let attrs = pending_attrs.take().unwrap_or_default();
            let name = pending_name
                .take()
                .or_else(|| attrs.get("tvg-name").cloned())
                .unwrap_or_else(|| format!("Channel {entry_index}"));

            let id = attrs
                .get("tvg-id")
                .filter(|s| !s.is_empty())
                .cloned()
                .unwrap_or_else(|| format!("{provider_id}_{entry_index}"));

            channels.push(Channel {
                id,
                provider_id: provider_id.to_string(),
                name,
                stream_url,
                logo_url: attrs.get("tvg-logo").filter(|s| !s.is_empty()).cloned(),
                group: attrs
                    .get("group-title")
                    .filter(|s| !s.is_empty())
                    .cloned()
                    .unwrap_or_else(|| "Uncategorized".to_string()),
                country: None,
                languages: Vec::new(),
                tvg_id: attrs.get("tvg-id").filter(|s| !s.is_empty()).cloned(),
                catchup_support: false,
            });

            entry_index += 1;
        }
    }

    Ok(channels)
}

/// Parse an `#EXTINF` value like:
/// `-1 tvg-id="bbc1" tvg-name="BBC One" tvg-logo="..." group-title="News",BBC One`
fn parse_extinf(rest: &str) -> Result<(HashMap<String, String>, String), ParseError> {
    // Split on the last comma to separate attributes from display name
    let comma_pos = rest
        .rfind(',')
        .ok_or_else(|| ParseError::InvalidExtinf(rest.to_string()))?;

    let attrs_str = &rest[..comma_pos];
    let display_name = rest[comma_pos + 1..].trim().to_string();

    let mut attrs = HashMap::new();
    // attrs_str starts with duration, then optional key="value" pairs
    for attr in ["tvg-id", "tvg-name", "tvg-logo", "group-title"] {
        if let Some(value) = extract_attr(attrs_str, attr) {
            attrs.insert(attr.to_string(), value);
        }
    }

    Ok((attrs, display_name))
}

fn extract_attr(s: &str, key: &str) -> Option<String> {
    let search = format!("{key}=\"");
    let start = s.find(search.as_str())? + search.len();
    let end = s[start..].find('"')? + start;
    Some(s[start..end].to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    const BASIC_M3U: &str = r#"#EXTM3U
#EXTINF:-1 tvg-id="bbc1.uk" tvg-name="BBC One" tvg-logo="http://example.com/bbc1.png" group-title="News",BBC One
http://stream.example.com/bbc1.m3u8
#EXTINF:-1 tvg-id="cnn" group-title="News",CNN International
http://stream.example.com/cnn.m3u8
#EXTINF:-1 group-title="Sports",Sky Sports
http://stream.example.com/skysports.m3u8
"#;

    #[test]
    fn parse_basic_playlist() {
        let channels = parse("p1", BASIC_M3U).unwrap();
        assert_eq!(channels.len(), 3);
    }

    #[test]
    fn first_channel_attributes() {
        let channels = parse("p1", BASIC_M3U).unwrap();
        let bbc = &channels[0];
        assert_eq!(bbc.name, "BBC One");
        assert_eq!(bbc.tvg_id, Some("bbc1.uk".into()));
        assert_eq!(bbc.logo_url, Some("http://example.com/bbc1.png".into()));
        assert_eq!(bbc.group, "News");
        assert_eq!(bbc.stream_url, "http://stream.example.com/bbc1.m3u8");
        assert_eq!(bbc.provider_id, "p1");
    }

    #[test]
    fn channel_without_logo() {
        let channels = parse("p1", BASIC_M3U).unwrap();
        assert!(channels[1].logo_url.is_none());
    }

    #[test]
    fn channel_without_tvg_id_gets_generated_id() {
        let channels = parse("p1", BASIC_M3U).unwrap();
        assert_eq!(channels[2].id, "p1_2");
    }

    #[test]
    fn missing_header_returns_error() {
        let result = parse("p1", "http://stream.example.com/ch1.m3u8\n");
        assert_eq!(result, Err(ParseError::MissingHeader));
    }

    #[test]
    fn empty_playlist_returns_no_channels() {
        let result = parse("p1", "#EXTM3U\n").unwrap();
        assert!(result.is_empty());
    }

    #[test]
    fn uncategorized_group_default() {
        let input = "#EXTM3U\n#EXTINF:-1,Channel X\nhttp://x.com/ch.m3u8\n";
        let channels = parse("p1", input).unwrap();
        assert_eq!(channels[0].group, "Uncategorized");
    }

    #[test]
    fn skips_comment_lines() {
        let input = "#EXTM3U\n# This is a comment\n#EXTINF:-1,Ch1\nhttp://x.com/ch1.m3u8\n";
        let channels = parse("p1", input).unwrap();
        assert_eq!(channels.len(), 1);
    }
}
