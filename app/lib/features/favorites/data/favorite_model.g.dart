// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteModelCollection on Isar {
  IsarCollection<FavoriteModel> get favoriteModels => this.collection();
}

const FavoriteModelSchema = CollectionSchema(
  name: r'FavoriteModel',
  id: 1479252551315694080,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'streamId': PropertySchema(id: 1, name: r'streamId', type: IsarType.long),
  },

  estimateSize: _favoriteModelEstimateSize,
  serialize: _favoriteModelSerialize,
  deserialize: _favoriteModelDeserialize,
  deserializeProp: _favoriteModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'streamId': IndexSchema(
      id: -2308752684150834108,
      name: r'streamId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'streamId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _favoriteModelGetId,
  getLinks: _favoriteModelGetLinks,
  attach: _favoriteModelAttach,
  version: '3.3.2',
);

int _favoriteModelEstimateSize(
  FavoriteModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _favoriteModelSerialize(
  FavoriteModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.streamId);
}

FavoriteModel _favoriteModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.streamId = reader.readLong(offsets[1]);
  return object;
}

P _favoriteModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteModelGetId(FavoriteModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteModelGetLinks(FavoriteModel object) {
  return [];
}

void _favoriteModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  FavoriteModel object,
) {
  object.id = id;
}

extension FavoriteModelByIndex on IsarCollection<FavoriteModel> {
  Future<FavoriteModel?> getByStreamId(int streamId) {
    return getByIndex(r'streamId', [streamId]);
  }

  FavoriteModel? getByStreamIdSync(int streamId) {
    return getByIndexSync(r'streamId', [streamId]);
  }

  Future<bool> deleteByStreamId(int streamId) {
    return deleteByIndex(r'streamId', [streamId]);
  }

  bool deleteByStreamIdSync(int streamId) {
    return deleteByIndexSync(r'streamId', [streamId]);
  }

  Future<List<FavoriteModel?>> getAllByStreamId(List<int> streamIdValues) {
    final values = streamIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'streamId', values);
  }

  List<FavoriteModel?> getAllByStreamIdSync(List<int> streamIdValues) {
    final values = streamIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'streamId', values);
  }

  Future<int> deleteAllByStreamId(List<int> streamIdValues) {
    final values = streamIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'streamId', values);
  }

  int deleteAllByStreamIdSync(List<int> streamIdValues) {
    final values = streamIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'streamId', values);
  }

  Future<Id> putByStreamId(FavoriteModel object) {
    return putByIndex(r'streamId', object);
  }

  Id putByStreamIdSync(FavoriteModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'streamId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStreamId(List<FavoriteModel> objects) {
    return putAllByIndex(r'streamId', objects);
  }

  List<Id> putAllByStreamIdSync(
    List<FavoriteModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'streamId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteModelQueryWhereSort
    on QueryBuilder<FavoriteModel, FavoriteModel, QWhere> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhere> anyStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'streamId'),
      );
    });
  }
}

extension FavoriteModelQueryWhere
    on QueryBuilder<FavoriteModel, FavoriteModel, QWhereClause> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> streamIdEqualTo(
    int streamId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'streamId', value: [streamId]),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  streamIdNotEqualTo(int streamId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'streamId',
                lower: [],
                upper: [streamId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'streamId',
                lower: [streamId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'streamId',
                lower: [streamId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'streamId',
                lower: [],
                upper: [streamId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  streamIdGreaterThan(int streamId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'streamId',
          lower: [streamId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  streamIdLessThan(int streamId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'streamId',
          lower: [],
          upper: [streamId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> streamIdBetween(
    int lowerStreamId,
    int upperStreamId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'streamId',
          lower: [lowerStreamId],
          includeLower: includeLower,
          upper: [upperStreamId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FavoriteModelQueryFilter
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  streamIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streamId', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  streamIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streamId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  streamIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streamId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  streamIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streamId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FavoriteModelQueryObject
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {}

extension FavoriteModelQueryLinks
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {}

extension FavoriteModelQuerySortBy
    on QueryBuilder<FavoriteModel, FavoriteModel, QSortBy> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }
}

extension FavoriteModelQuerySortThenBy
    on QueryBuilder<FavoriteModel, FavoriteModel, QSortThenBy> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }
}

extension FavoriteModelQueryWhereDistinct
    on QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> {
  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamId');
    });
  }
}

extension FavoriteModelQueryProperty
    on QueryBuilder<FavoriteModel, FavoriteModel, QQueryProperty> {
  QueryBuilder<FavoriteModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FavoriteModel, int, QQueryOperations> streamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamId');
    });
  }
}
