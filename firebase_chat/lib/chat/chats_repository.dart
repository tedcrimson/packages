import 'package:firebase_chat/models.dart';
import 'package:firestore_repository/firestore_repository.dart';

class ChatsRepository {
  ChatsRepository({FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository ?? FirestoreRepository();

  final FirestoreRepository _firestoreRepository;

  Query getChatsQuery(String collection, List<QueryFilter> filters) {
    return _firestoreRepository.getQuery([collection], filters: filters);
  }

  Future<PeerUser> getPeer(String userId) async {
    var snap = await _firestoreRepository.getDocument(['Users', userId]);
    return PeerUser.fromSnapshot(snap);
  }

  Future<ActivityLog> getActivity(String path) async {
    var snap = await _firestoreRepository.doc(path).get();
    return ActivityLog.fromSnapshot(snap);
  }
}
