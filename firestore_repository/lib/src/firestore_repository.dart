import 'package:cloud_firestore/cloud_firestore.dart';
part 'crud_repository.dart';
part 'exceptions.dart';
part 'query_filter.dart';

class FirestoreRepository extends CRUDRepository {
  FirestoreRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  // final FirebaseAuthenticationRepository _auth;

  Future<QuerySnapshot> getCollection(List fields,
      {List<QueryFilter> filters, DocumentSnapshot startAfter, int limit, GetOptions getOptions}) async {
    return getQuery(fields, filters: filters, startAfter: startAfter, limit: limit).get(getOptions);
  }

  Query getQuery(List fields, {List<QueryFilter> filters, DocumentSnapshot startAfter, int limit}) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 == 0) throw FirestoreArgumentException();
    Query query = _firestore.collection(fields.join('/'));
    if (filters != null) {
      for (var filter in filters)
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          isNull: filter.isNull,
        );
    }

    if (startAfter != null) query = query.startAfterDocument(startAfter);
    if (limit != null) query = query.limit(limit);

    return limitQuery(query, startAfter: startAfter, limit: limit);
  }

  Query limitQuery(Query query, {DocumentSnapshot startAfter, int limit}) {
    if (startAfter != null) query = query.startAfterDocument(startAfter);
    if (limit != null) query = query.limit(limit);

    return query;
  }

  Future<DocumentSnapshot> getDocument(List fields) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 != 0) throw FirestoreArgumentException();
    return read(fields.join('/'));
  }

  Future<void> addData(List fields, Map<String, dynamic> jsonData) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 == 0) throw FirestoreArgumentException();
    return create(fields.join('/'), jsonData);
  }

  Future<void> setData(List fields, Map<String, dynamic> jsonData) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 != 0) throw FirestoreArgumentException();
    return _set(fields.join('/'), jsonData);
  }

  Future<void> updateData(List fields, Map<String, dynamic> jsonData) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 != 0) throw FirestoreArgumentException();
    return update(fields.join('/'), jsonData);
  }

  Stream<DocumentSnapshot> listen(List fields) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 != 0) throw FirestoreArgumentException();
    return _firestore.doc(fields.join('/')).snapshots();
  }

  @override
  Future<DocumentReference> create(String path, dynamic data) {
    return _firestore.collection(path).add(data);
  }

  @override
  Future<void> delete(String path) {
    return _firestore.doc(path).delete();
  }

  @override
  Future<DocumentSnapshot> read(String path) {
    return _firestore.doc(path).get();
  }

  @override
  Future update(String path, dynamic data) {
    return _firestore.doc(path).update(data);
  }

  Future _set(String path, dynamic data) {
    return _firestore.doc(path).set(data);
  }
}
