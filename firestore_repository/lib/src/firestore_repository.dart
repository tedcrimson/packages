import 'package:cloud_firestore/cloud_firestore.dart';
part 'crud_repository.dart';
part 'exceptions.dart';

class FirestoreRepository extends CRUDRepository {
  FirestoreRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  // final FirebaseAuthenticationRepository _auth;

  Future<QuerySnapshot> getCollection(List fields) {
    if (fields.contains(null)) throw FirestoreNullArgumentException();
    if (fields.length % 2 == 0) throw FirestoreArgumentException();
    return _firestore.collection(fields.join('/')).get();
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
}
