sealed class AppError {
  const AppError();
}

class NetworkTimeoutError extends AppError {
  const NetworkTimeoutError();
}

class NoConnectionError extends AppError {
  const NoConnectionError();
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

class UnknownError extends AppError {
  const UnknownError(this.message);
  final String message;
}

extension AppErrorMessage on AppError {
  String get userMessage => switch (this) {
        NetworkTimeoutError() => 'La conexión tardó demasiado. Inténtalo de nuevo.',
        NoConnectionError() => 'Sin conexión. Revisa tu red o usa los datos en caché.',
        BadCredentialsError() => 'Usuario o contraseña incorrectos.',
        InvalidStreamError() => 'El canal no está disponible ahora.',
        PlayerError(:final message) => 'Error al reproducir: $message',
        UnknownError(:final message) => 'Error inesperado: $message',
      };
}
