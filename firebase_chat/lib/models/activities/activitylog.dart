import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'firebase_model.dart';

class ActivityStatus {
  static const Text = 1;
  static const Image = 2;
  static const Status = 4;
  static const Proposal = 8;
  //todo add more statuses
}

class SeenStatus {
  static const Sent = 0;
  static const Recieved = 1;
  static const Seen = 2;
  //todo add more statuses
}

class ActivityLog extends FirebaseModel {
  String idFrom;
  String idTo;
  int activityStatus;
  int seenStatus;
  Timestamp timestamp;
  String path;

  ActivityLog.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.id;
    var data = snapshot.data();
    idFrom = data['idFrom'];
    idTo = data['idTo'];
    seenStatus = data['seenStatus'];
    timestamp = data['timestamp'];
    activityStatus = data['activityStatus'];
    path = snapshot.reference.path;
  }

  ActivityLog({@required this.activityStatus, @required this.idFrom, @required this.idTo, String documentId}) {
    this.documentID = documentId;
    this.seenStatus = SeenStatus.Sent;
  }

  @override
  Map<String, Object> toJson() {
    Map<String, Object> json = new Map<String, Object>();
    json['idFrom'] = idFrom;
    json['idTo'] = idTo;
    json['seenStatus'] = seenStatus;
    json['timestamp'] = FieldValue.serverTimestamp();
    json['activityStatus'] = activityStatus;
    return json;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ActivityLog && o.path == path;
  }

  @override
  int get hashCode {
    return path.hashCode;
  }
}
