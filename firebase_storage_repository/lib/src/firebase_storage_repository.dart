import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
part 'crud_repository.dart';
part 'exceptions.dart';

class FirebaseStorageRepository extends CRUDRepository {
  FirebaseStorageRepository({
    FirebaseStorage storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  StorageReference get ref => _storage.ref();

  Future<String> getDownloadUrl(List fields) {
    if (fields.contains(null)) throw FirebaseStorageNullArgumentException();
    if (fields.length % 2 != 0) throw FirebaseStorageArgumentException();
    return read(fields.join('/'));
  }

  Future<Uint8List> getByteData(List fields, [int maxSize]) {
    if (fields.contains(null)) throw FirebaseStorageNullArgumentException();
    if (fields.length % 2 != 0) throw FirebaseStorageArgumentException();
    return ref.child(fields.join('/')).getData(maxSize ?? 100 * 100 * 100);
  }

  Future<StorageTaskSnapshot> uploadByteData(List fields, Uint8List data) {
    if (fields.contains(null)) throw FirebaseStorageNullArgumentException();
    if (fields.length % 2 != 0) throw FirebaseStorageArgumentException();
    return create(fields.join('/'), data);
  }

  Future<StorageTaskSnapshot> uploadFile(List fields, File file) {
    if (fields.contains(null)) throw FirebaseStorageNullArgumentException();
    if (fields.length % 2 != 0) throw FirebaseStorageArgumentException();
    return ref.child(fields.join('/')).putFile(file).onComplete;
  }

  @override
  Future<StorageTaskSnapshot> create(String path, dynamic data) {
    return ref.child(path).putData(data).onComplete;
  }

  @override
  Future delete(String path) {
    return ref.child(path).delete();
  }

  @override
  Future read(String path) {
    return ref.child(path).getDownloadURL();
  }

  @override
  Future update(String path, dynamic data) {
    return ref.child(path).updateMetadata(data);
  }
}
