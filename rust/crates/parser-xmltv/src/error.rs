use thiserror::Error;

#[derive(Debug, Error)]
pub enum XmltvError {
    #[error("invalid XMLTV format: {0}")]
    InvalidFormat(String),
    #[error("XML parse error: {0}")]
    XmlError(String),
}
