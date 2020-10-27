import 'activitylog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageActivity extends ActivityLog {
  String imagePath;
  String thumbPath;
  ImageActivity.fromSnapshot(DocumentSnapshot snapshot) : super.fromSnapshot(snapshot) {
    imagePath = snapshot.data()['imagePath'];
    thumbPath = snapshot.data()['thumbPath'];
  }

  ImageActivity({this.imagePath, this.thumbPath, String idFrom, String idTo})
      : super(activityStatus: ActivityStatus.Image, idFrom: idFrom, idTo: idTo);

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    json['imagePath'] = imagePath;
    json['thumbPath'] = thumbPath;

    return json;
  }
}
