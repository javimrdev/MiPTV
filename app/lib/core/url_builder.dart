String buildStreamUrl({
  required String server,
  required String username,
  required String password,
  required int streamId,
  required String extension,
  String type = 'live',
}) {
  final base = server.endsWith('/') ? server.dropLast(1) : server;
  return '$base/$type/$username/$password/$streamId.$extension';
}

extension on String {
  String dropLast(int count) => substring(0, length - count);
}
