import 'activitylog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextActivity extends ActivityLog {
  String text;
  TextActivity.fromSnapshot(DocumentSnapshot snap) : super.fromSnapshot(snap) {
    text = snap.data()['text'];
  }

  TextActivity({this.text, String idFrom, String idTo})
      : super(activityStatus: ActivityStatus.Text, idFrom: idFrom, idTo: idTo);

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    json['text'] = text;
    return json;
  }
}
