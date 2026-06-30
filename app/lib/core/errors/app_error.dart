import 'package:miptv/l10n/app_localizations.dart';

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
  /// Localized, user-facing message for this error. Pass the current
  /// [AppLocalizations] (obtained from a [BuildContext]).
  String userMessage(AppLocalizations l10n) => switch (this) {
        NetworkTimeoutError() => l10n.errorNetworkTimeout,
        NoConnectionError() => l10n.errorNoConnection,
        InvalidServerUrlError() => l10n.errorInvalidServerUrl,
        BadCredentialsError() => l10n.errorBadCredentials,
        ParseError() => l10n.errorParse,
        InvalidStreamError() => l10n.errorInvalidStream,
        PlayerError(:final message) => l10n.errorPlayer(message),
        UnknownError(:final message) => l10n.errorUnknown(message),
      };
}
