use thiserror::Error;

#[derive(Debug, Error, PartialEq)]
pub enum ParseError {
    #[error("missing #EXTM3U header")]
    MissingHeader,
    #[error("invalid EXTINF line: {0}")]
    InvalidExtinf(String),
    #[error("unexpected end of input")]
    UnexpectedEof,
}
