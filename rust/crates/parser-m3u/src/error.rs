use thiserror::Error;

#[derive(Debug, Error)]
pub enum ParseError {
    #[error("invalid M3U format: {0}")]
    InvalidFormat(String),
}
