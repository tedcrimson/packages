import 'package:firebase_chat/firebase_chat.dart';
import 'package:firebase_chat/models/activities/activitylog.dart';

class ChatEntity {
  // final PeerUser userFrom;
  final PeerUser userTo;
  final ActivityLog lastMessage;
  final String path;

  ChatEntity(this.userTo, this.lastMessage, this.path);
}
