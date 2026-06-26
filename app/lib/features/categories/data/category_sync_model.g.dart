// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_sync_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategorySyncModelCollection on Isar {
  IsarCollection<CategorySyncModel> get categorySyncModels => this.collection();
}

const CategorySyncModelSchema = CollectionSchema(
  name: r'CategorySyncModel',
  id: 4527613920677314295,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'isSyncing': PropertySchema(
      id: 1,
      name: r'isSyncing',
      type: IsarType.bool,
    ),
    r'lastSync': PropertySchema(
      id: 2,
      name: r'lastSync',
      type: IsarType.dateTime,
    ),
    r'streamCount': PropertySchema(
      id: 3,
      name: r'streamCount',
      type: IsarType.long,
    ),
  },

  estimateSize: _categorySyncModelEstimateSize,
  serialize: _categorySyncModelSerialize,
  deserialize: _categorySyncModelDeserialize,
  deserializeProp: _categorySyncModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _categorySyncModelGetId,
  getLinks: _categorySyncModelGetLinks,
  attach: _categorySyncModelAttach,
  version: '3.3.2',
);

int _categorySyncModelEstimateSize(
  CategorySyncModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryId.length * 3;
  return bytesCount;
}

void _categorySyncModelSerialize(
  CategorySyncModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryId);
  writer.writeBool(offsets[1], object.isSyncing);
  writer.writeDateTime(offsets[2], object.lastSync);
  writer.writeLong(offsets[3], object.streamCount);
}

CategorySyncModel _categorySyncModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategorySyncModel();
  object.categoryId = reader.readString(offsets[0]);
  object.id = id;
  object.isSyncing = reader.readBool(offsets[1]);
  object.lastSync = reader.readDateTime(offsets[2]);
  object.streamCount = reader.readLong(offsets[3]);
  return object;
}

P _categorySyncModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categorySyncModelGetId(CategorySyncModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categorySyncModelGetLinks(
  CategorySyncModel object,
) {
  return [];
}

void _categorySyncModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CategorySyncModel object,
) {
  object.id = id;
}

extension CategorySyncModelByIndex on IsarCollection<CategorySyncModel> {
  Future<CategorySyncModel?> getByCategoryId(String categoryId) {
    return getByIndex(r'categoryId', [categoryId]);
  }

  CategorySyncModel? getByCategoryIdSync(String categoryId) {
    return getByIndexSync(r'categoryId', [categoryId]);
  }

  Future<bool> deleteByCategoryId(String categoryId) {
    return deleteByIndex(r'categoryId', [categoryId]);
  }

  bool deleteByCategoryIdSync(String categoryId) {
    return deleteByIndexSync(r'categoryId', [categoryId]);
  }

  Future<List<CategorySyncModel?>> getAllByCategoryId(
    List<String> categoryIdValues,
  ) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'categoryId', values);
  }

  List<CategorySyncModel?> getAllByCategoryIdSync(
    List<String> categoryIdValues,
  ) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'categoryId', values);
  }

  Future<int> deleteAllByCategoryId(List<String> categoryIdValues) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'categoryId', values);
  }

  int deleteAllByCategoryIdSync(List<String> categoryIdValues) {
    final values = categoryIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'categoryId', values);
  }

  Future<Id> putByCategoryId(CategorySyncModel object) {
    return putByIndex(r'categoryId', object);
  }

  Id putByCategoryIdSync(CategorySyncModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'categoryId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCategoryId(List<CategorySyncModel> objects) {
    return putAllByIndex(r'categoryId', objects);
  }

  List<Id> putAllByCategoryIdSync(
    List<CategorySyncModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'categoryId', objects, saveLinks: saveLinks);
  }
}

extension CategorySyncModelQueryWhereSort
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QWhere> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategorySyncModelQueryWhere
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QWhereClause> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
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

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
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

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
  categoryIdEqualTo(String categoryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'categoryId', value: [categoryId]),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterWhereClause>
  categoryIdNotEqualTo(String categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [],
                upper: [categoryId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [categoryId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [categoryId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryId',
                lower: [],
                upper: [categoryId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CategorySyncModelQueryFilter
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QFilterCondition> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryId', value: ''),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
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

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
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

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
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

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  isSyncingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSyncing', value: value),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  lastSyncEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSync', value: value),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  lastSyncGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSync',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  lastSyncLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSync',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  lastSyncBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSync',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  streamCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streamCount', value: value),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  streamCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streamCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  streamCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streamCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterFilterCondition>
  streamCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streamCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CategorySyncModelQueryObject
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QFilterCondition> {}

extension CategorySyncModelQueryLinks
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QFilterCondition> {}

extension CategorySyncModelQuerySortBy
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QSortBy> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByIsSyncingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByStreamCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamCount', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  sortByStreamCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamCount', Sort.desc);
    });
  }
}

extension CategorySyncModelQuerySortThenBy
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QSortThenBy> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByIsSyncingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByStreamCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamCount', Sort.asc);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QAfterSortBy>
  thenByStreamCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamCount', Sort.desc);
    });
  }
}

extension CategorySyncModelQueryWhereDistinct
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QDistinct> {
  QueryBuilder<CategorySyncModel, CategorySyncModel, QDistinct>
  distinctByCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QDistinct>
  distinctByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSyncing');
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QDistinct>
  distinctByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSync');
    });
  }

  QueryBuilder<CategorySyncModel, CategorySyncModel, QDistinct>
  distinctByStreamCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamCount');
    });
  }
}

extension CategorySyncModelQueryProperty
    on QueryBuilder<CategorySyncModel, CategorySyncModel, QQueryProperty> {
  QueryBuilder<CategorySyncModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategorySyncModel, String, QQueryOperations>
  categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<CategorySyncModel, bool, QQueryOperations> isSyncingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSyncing');
    });
  }

  QueryBuilder<CategorySyncModel, DateTime, QQueryOperations>
  lastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSync');
    });
  }

  QueryBuilder<CategorySyncModel, int, QQueryOperations> streamCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamCount');
    });
  }
}
