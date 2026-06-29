import 'package:isar_community/isar.dart';

part 'custom_filter_model.g.dart';

/// A user-defined filter value added manually from Settings, persisted so it
/// appears alongside the predefined options in the matching Home pill.
@collection
class CustomFilterModel {
  Id id = Isar.autoIncrement;

  /// Filter dimension this value belongs to: `quality` | `category` | `country`
  /// (the `HomeFilterType.name`). Composite-unique with [value] to avoid dupes.
  @Index(composite: [CompositeIndex('value')], unique: true, replace: true)
  late String type;

  late String value;
}
