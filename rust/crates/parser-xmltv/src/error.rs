use thiserror::Error;

#[derive(Debug, Error)]
pub enum XmltvError {
    #[error("XML parse error: {0}")]
    Xml(String),
    #[error("invalid timestamp format: {0}")]
    InvalidTimestamp(String),
    #[error("missing required attribute: {0}")]
    MissingAttribute(String),
}

impl From<quick_xml::Error> for XmltvError {
    fn from(e: quick_xml::Error) -> Self {
        XmltvError::Xml(e.to_string())
    }
}
