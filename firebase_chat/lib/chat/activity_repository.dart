import 'dart:typed_data';

import 'package:firebase_chat/models.dart';
import 'package:firebase_storage_repository/firebase_storage_repository.dart';
import 'package:firestore_repository/firestore_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityRepository {
  ActivityRepository(this.path, {FirestoreRepository firestoreRepository, FirebaseStorageRepository storageRepository})
      : _firestoreRepository = firestoreRepository ?? FirestoreRepository(),
        _storageRepository = storageRepository ?? FirebaseStorageRepository();

  final String path;

  final FirestoreRepository _firestoreRepository;
  final FirebaseStorageRepository _storageRepository;

  DocumentReference get reference => _firestoreRepository.doc(path);

  DocumentReference createActivityReference() {
    return reference.collection('Activity').doc();
  }

  Future setTyping(String userId, bool typing) {
    return reference.set(
      {
        'typing': {userId: typing}
      },
      SetOptions(merge: true),
    );
  }

  Future<void> addActivity(DocumentReference activityReference, ActivityLog activityLog) {
    var json = activityLog.toJson();

    activityReference.set(json).whenComplete(() {
      changeSeenStatus(activityReference.path, SeenStatus.Recieved);
    });
    return reference.update({'lastMessage': activityReference});
  }

  Future<void> changeSeenStatus(String path, int seenStatus) {
    return _firestoreRepository.doc(path).update({'seenStatus': seenStatus}); //sent
  }

  Future<String> uploadData(String fileName, Uint8List image) async {
    var task = await _storageRepository.uploadByteData(['ChatPictures', fileName], image);
    return await task.ref.getDownloadURL();
  }

  Stream<QuerySnapshot> getChatImages(DocumentReference proposalReference) {
    return reference
        .collection('Activity')
        .where("activityStatus", isEqualTo: ActivityStatus.Image)
        .orderBy('timestamp', descending: true)
        .snapshots(); //TODO: change
  }
}
