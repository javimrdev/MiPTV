sealed class AppError {
  const AppError();
}

class NetworkTimeoutError extends AppError {
  const NetworkTimeoutError();
}

class NoConnectionError extends AppError {
  const NoConnectionError();
}

class InvalidServerUrlError extends AppError {
  const InvalidServerUrlError();
}

class BadCredentialsError extends AppError {
  const BadCredentialsError();
}

class InvalidStreamError extends AppError {
  const InvalidStreamError();
}

class PlayerError extends AppError {
  const PlayerError(this.message);
  final String message;
}

class ParseError extends AppError {
  const ParseError();
}

class UnknownError extends AppError {
  const UnknownError(this.message);
  final String message;
}

extension AppErrorMessage on AppError {
  String get userMessage => switch (this) {
        NetworkTimeoutError() => 'La conexión tardó demasiado. Inténtalo de nuevo.',
        NoConnectionError() => 'Sin conexión a internet. Revisa tu red.',
        InvalidServerUrlError() => 'La URL del servidor no existe. Comprueba que esté bien escrita.',
        BadCredentialsError() => 'Usuario o contraseña incorrectos.',
        ParseError() => 'La respuesta del servidor no es válida. Inténtalo de nuevo.',
        InvalidStreamError() => 'El canal no está disponible ahora.',
        PlayerError(:final message) => 'Error al reproducir: $message',
        UnknownError(:final message) => 'Error inesperado: $message',
      };
}
