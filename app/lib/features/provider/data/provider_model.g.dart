// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProviderModelCollection on Isar {
  IsarCollection<ProviderModel> get providerModels => this.collection();
}

const ProviderModelSchema = CollectionSchema(
  name: r'ProviderModel',
  id: 5360569753717054365,
  properties: {
    r'server': PropertySchema(id: 0, name: r'server', type: IsarType.string),
    r'username': PropertySchema(
      id: 1,
      name: r'username',
      type: IsarType.string,
    ),
  },

  estimateSize: _providerModelEstimateSize,
  serialize: _providerModelSerialize,
  deserialize: _providerModelDeserialize,
  deserializeProp: _providerModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'server': IndexSchema(
      id: -7588013344182096230,
      name: r'server',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'server',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _providerModelGetId,
  getLinks: _providerModelGetLinks,
  attach: _providerModelAttach,
  version: '3.3.2',
);

int _providerModelEstimateSize(
  ProviderModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.server.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _providerModelSerialize(
  ProviderModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.server);
  writer.writeString(offsets[1], object.username);
}

ProviderModel _providerModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProviderModel();
  object.id = id;
  object.server = reader.readString(offsets[0]);
  object.username = reader.readString(offsets[1]);
  return object;
}

P _providerModelDeserializeProp<P>(
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

Id _providerModelGetId(ProviderModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _providerModelGetLinks(ProviderModel object) {
  return [];
}

void _providerModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProviderModel object,
) {
  object.id = id;
}

extension ProviderModelByIndex on IsarCollection<ProviderModel> {
  Future<ProviderModel?> getByServer(String server) {
    return getByIndex(r'server', [server]);
  }

  ProviderModel? getByServerSync(String server) {
    return getByIndexSync(r'server', [server]);
  }

  Future<bool> deleteByServer(String server) {
    return deleteByIndex(r'server', [server]);
  }

  bool deleteByServerSync(String server) {
    return deleteByIndexSync(r'server', [server]);
  }

  Future<List<ProviderModel?>> getAllByServer(List<String> serverValues) {
    final values = serverValues.map((e) => [e]).toList();
    return getAllByIndex(r'server', values);
  }

  List<ProviderModel?> getAllByServerSync(List<String> serverValues) {
    final values = serverValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'server', values);
  }

  Future<int> deleteAllByServer(List<String> serverValues) {
    final values = serverValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'server', values);
  }

  int deleteAllByServerSync(List<String> serverValues) {
    final values = serverValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'server', values);
  }

  Future<Id> putByServer(ProviderModel object) {
    return putByIndex(r'server', object);
  }

  Id putByServerSync(ProviderModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'server', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServer(List<ProviderModel> objects) {
    return putAllByIndex(r'server', objects);
  }

  List<Id> putAllByServerSync(
    List<ProviderModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'server', objects, saveLinks: saveLinks);
  }
}

extension ProviderModelQueryWhereSort
    on QueryBuilder<ProviderModel, ProviderModel, QWhere> {
  QueryBuilder<ProviderModel, ProviderModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProviderModelQueryWhere
    on QueryBuilder<ProviderModel, ProviderModel, QWhereClause> {
  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause> serverEqualTo(
    String server,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'server', value: [server]),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterWhereClause>
  serverNotEqualTo(String server) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'server',
                lower: [],
                upper: [server],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'server',
                lower: [server],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'server',
                lower: [server],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'server',
                lower: [],
                upper: [server],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ProviderModelQueryFilter
    on QueryBuilder<ProviderModel, ProviderModel, QFilterCondition> {
  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
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

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'server',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'server',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'server', value: ''),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  serverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'server', value: ''),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'username',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'username',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'username', value: ''),
      );
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterFilterCondition>
  usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'username', value: ''),
      );
    });
  }
}

extension ProviderModelQueryObject
    on QueryBuilder<ProviderModel, ProviderModel, QFilterCondition> {}

extension ProviderModelQueryLinks
    on QueryBuilder<ProviderModel, ProviderModel, QFilterCondition> {}

extension ProviderModelQuerySortBy
    on QueryBuilder<ProviderModel, ProviderModel, QSortBy> {
  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> sortByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> sortByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy>
  sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension ProviderModelQuerySortThenBy
    on QueryBuilder<ProviderModel, ProviderModel, QSortThenBy> {
  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> thenByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> thenByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QAfterSortBy>
  thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension ProviderModelQueryWhereDistinct
    on QueryBuilder<ProviderModel, ProviderModel, QDistinct> {
  QueryBuilder<ProviderModel, ProviderModel, QDistinct> distinctByServer({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'server', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProviderModel, ProviderModel, QDistinct> distinctByUsername({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension ProviderModelQueryProperty
    on QueryBuilder<ProviderModel, ProviderModel, QQueryProperty> {
  QueryBuilder<ProviderModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProviderModel, String, QQueryOperations> serverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'server');
    });
  }

  QueryBuilder<ProviderModel, String, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
