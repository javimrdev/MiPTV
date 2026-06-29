// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_filter_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomFilterModelCollection on Isar {
  IsarCollection<CustomFilterModel> get customFilterModels => this.collection();
}

const CustomFilterModelSchema = CollectionSchema(
  name: r'CustomFilterModel',
  id: -6248184670469254913,
  properties: {
    r'type': PropertySchema(id: 0, name: r'type', type: IsarType.string),
    r'value': PropertySchema(id: 1, name: r'value', type: IsarType.string),
  },

  estimateSize: _customFilterModelEstimateSize,
  serialize: _customFilterModelSerialize,
  deserialize: _customFilterModelDeserialize,
  deserializeProp: _customFilterModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'type_value': IndexSchema(
      id: -66529461466668831,
      name: r'type_value',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'value',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _customFilterModelGetId,
  getLinks: _customFilterModelGetLinks,
  attach: _customFilterModelAttach,
  version: '3.3.2',
);

int _customFilterModelEstimateSize(
  CustomFilterModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _customFilterModelSerialize(
  CustomFilterModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.type);
  writer.writeString(offsets[1], object.value);
}

CustomFilterModel _customFilterModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomFilterModel();
  object.id = id;
  object.type = reader.readString(offsets[0]);
  object.value = reader.readString(offsets[1]);
  return object;
}

P _customFilterModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customFilterModelGetId(CustomFilterModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customFilterModelGetLinks(
  CustomFilterModel object,
) {
  return [];
}

void _customFilterModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CustomFilterModel object,
) {
  object.id = id;
}

extension CustomFilterModelByIndex on IsarCollection<CustomFilterModel> {
  Future<CustomFilterModel?> getByTypeValue(String type, String value) {
    return getByIndex(r'type_value', [type, value]);
  }

  CustomFilterModel? getByTypeValueSync(String type, String value) {
    return getByIndexSync(r'type_value', [type, value]);
  }

  Future<bool> deleteByTypeValue(String type, String value) {
    return deleteByIndex(r'type_value', [type, value]);
  }

  bool deleteByTypeValueSync(String type, String value) {
    return deleteByIndexSync(r'type_value', [type, value]);
  }

  Future<List<CustomFilterModel?>> getAllByTypeValue(
    List<String> typeValues,
    List<String> valueValues,
  ) {
    final len = typeValues.length;
    assert(
      valueValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeValues[i], valueValues[i]]);
    }

    return getAllByIndex(r'type_value', values);
  }

  List<CustomFilterModel?> getAllByTypeValueSync(
    List<String> typeValues,
    List<String> valueValues,
  ) {
    final len = typeValues.length;
    assert(
      valueValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeValues[i], valueValues[i]]);
    }

    return getAllByIndexSync(r'type_value', values);
  }

  Future<int> deleteAllByTypeValue(
    List<String> typeValues,
    List<String> valueValues,
  ) {
    final len = typeValues.length;
    assert(
      valueValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeValues[i], valueValues[i]]);
    }

    return deleteAllByIndex(r'type_value', values);
  }

  int deleteAllByTypeValueSync(
    List<String> typeValues,
    List<String> valueValues,
  ) {
    final len = typeValues.length;
    assert(
      valueValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([typeValues[i], valueValues[i]]);
    }

    return deleteAllByIndexSync(r'type_value', values);
  }

  Future<Id> putByTypeValue(CustomFilterModel object) {
    return putByIndex(r'type_value', object);
  }

  Id putByTypeValueSync(CustomFilterModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'type_value', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTypeValue(List<CustomFilterModel> objects) {
    return putAllByIndex(r'type_value', objects);
  }

  List<Id> putAllByTypeValueSync(
    List<CustomFilterModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'type_value', objects, saveLinks: saveLinks);
  }
}

extension CustomFilterModelQueryWhereSort
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QWhere> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomFilterModelQueryWhere
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QWhereClause> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  typeEqualToAnyValue(String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'type_value', value: [type]),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  typeNotEqualToAnyValue(String type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  typeValueEqualTo(String type, String value) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'type_value',
          value: [type, value],
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterWhereClause>
  typeEqualToValueNotEqualTo(String type, String value) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type],
                upper: [type, value],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type, value],
                includeLower: false,
                upper: [type],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type, value],
                includeLower: false,
                upper: [type],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type_value',
                lower: [type],
                upper: [type, value],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CustomFilterModelQueryFilter
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QFilterCondition> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterFilterCondition>
  valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension CustomFilterModelQueryObject
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QFilterCondition> {}

extension CustomFilterModelQueryLinks
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QFilterCondition> {}

extension CustomFilterModelQuerySortBy
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QSortBy> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CustomFilterModelQuerySortThenBy
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QSortThenBy> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QAfterSortBy>
  thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CustomFilterModelQueryWhereDistinct
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QDistinct> {
  QueryBuilder<CustomFilterModel, CustomFilterModel, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomFilterModel, CustomFilterModel, QDistinct>
  distinctByValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension CustomFilterModelQueryProperty
    on QueryBuilder<CustomFilterModel, CustomFilterModel, QQueryProperty> {
  QueryBuilder<CustomFilterModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomFilterModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<CustomFilterModel, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
