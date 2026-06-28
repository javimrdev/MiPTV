// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vod_sync_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVodSyncModelCollection on Isar {
  IsarCollection<VodSyncModel> get vodSyncModels => this.collection();
}

const VodSyncModelSchema = CollectionSchema(
  name: r'VodSyncModel',
  id: 7365087884982440509,
  properties: {
    r'isSyncing': PropertySchema(
      id: 0,
      name: r'isSyncing',
      type: IsarType.bool,
    ),
    r'lastSync': PropertySchema(
      id: 1,
      name: r'lastSync',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _vodSyncModelEstimateSize,
  serialize: _vodSyncModelSerialize,
  deserialize: _vodSyncModelDeserialize,
  deserializeProp: _vodSyncModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _vodSyncModelGetId,
  getLinks: _vodSyncModelGetLinks,
  attach: _vodSyncModelAttach,
  version: '3.3.2',
);

int _vodSyncModelEstimateSize(
  VodSyncModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _vodSyncModelSerialize(
  VodSyncModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSyncing);
  writer.writeDateTime(offsets[1], object.lastSync);
}

VodSyncModel _vodSyncModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VodSyncModel();
  object.id = id;
  object.isSyncing = reader.readBool(offsets[0]);
  object.lastSync = reader.readDateTimeOrNull(offsets[1]);
  return object;
}

P _vodSyncModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vodSyncModelGetId(VodSyncModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vodSyncModelGetLinks(VodSyncModel object) {
  return [];
}

void _vodSyncModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  VodSyncModel object,
) {
  object.id = id;
}

extension VodSyncModelQueryWhereSort
    on QueryBuilder<VodSyncModel, VodSyncModel, QWhere> {
  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VodSyncModelQueryWhere
    on QueryBuilder<VodSyncModel, VodSyncModel, QWhereClause> {
  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterWhereClause> idBetween(
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
}

extension VodSyncModelQueryFilter
    on QueryBuilder<VodSyncModel, VodSyncModel, QFilterCondition> {
  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  isSyncingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSyncing', value: value),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSync'),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSync'),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSync', value: value),
      );
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncGreaterThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncLessThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterFilterCondition>
  lastSyncBetween(
    DateTime? lower,
    DateTime? upper, {
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
}

extension VodSyncModelQueryObject
    on QueryBuilder<VodSyncModel, VodSyncModel, QFilterCondition> {}

extension VodSyncModelQueryLinks
    on QueryBuilder<VodSyncModel, VodSyncModel, QFilterCondition> {}

extension VodSyncModelQuerySortBy
    on QueryBuilder<VodSyncModel, VodSyncModel, QSortBy> {
  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> sortByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.asc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> sortByIsSyncingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.desc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> sortByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> sortByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }
}

extension VodSyncModelQuerySortThenBy
    on QueryBuilder<VodSyncModel, VodSyncModel, QSortThenBy> {
  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.asc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenByIsSyncingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSyncing', Sort.desc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QAfterSortBy> thenByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }
}

extension VodSyncModelQueryWhereDistinct
    on QueryBuilder<VodSyncModel, VodSyncModel, QDistinct> {
  QueryBuilder<VodSyncModel, VodSyncModel, QDistinct> distinctByIsSyncing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSyncing');
    });
  }

  QueryBuilder<VodSyncModel, VodSyncModel, QDistinct> distinctByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSync');
    });
  }
}

extension VodSyncModelQueryProperty
    on QueryBuilder<VodSyncModel, VodSyncModel, QQueryProperty> {
  QueryBuilder<VodSyncModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VodSyncModel, bool, QQueryOperations> isSyncingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSyncing');
    });
  }

  QueryBuilder<VodSyncModel, DateTime?, QQueryOperations> lastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSync');
    });
  }
}
