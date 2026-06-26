import 'package:isar_community/isar.dart';

part 'provider_model.g.dart';

@collection
class ProviderModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String server;

  late String username;
  // password is NEVER stored here — kept in FlutterSecureStorage
}
