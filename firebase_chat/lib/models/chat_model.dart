import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String fromId;
  final String toId;
  final DocumentReference lastMessageReference;
  final String path;
  ChatModel({this.fromId, this.toId, this.path, this.lastMessageReference});

  factory ChatModel.fromSnapshot(String userId, DocumentSnapshot snap) {
    var data = snap.data();
    var toId = data['users'].firstWhere((x) => x != userId);
    return ChatModel(fromId: userId, toId: toId, lastMessageReference: data['lastMessage'], path: snap.reference.path);
  }

  Map<String, Object> toJson() {
    var map = Map<String, Object>();
    map['fromId'] = fromId;
    map['toId'] = toId;
    return map;
  }
}
