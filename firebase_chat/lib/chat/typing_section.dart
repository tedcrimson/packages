import 'dart:async';

import 'package:firebase_chat/chat/activity_repository.dart';
import 'package:firebase_chat/chat/typing_widget.dart';
import 'package:firebase_chat/models/peer_user.dart';
import 'package:flutter/material.dart';

class TypingSection extends StatefulWidget {
  final ActivityRepository activityRepository;
  final Map<String, PeerUser> peers;
  final ImageProvider typingGif;
  final String userId;
  const TypingSection(
      {@required this.userId, @required this.activityRepository, @required this.peers, @required this.typingGif});
  @override
  _TypingSectionState createState() => _TypingSectionState();
}

class _TypingSectionState extends State<TypingSection> {
  List<String> typingPeers = List<String>();
  StreamSubscription _typingSubscription;

  @override
  void initState() {
    _typingSubscription = widget.activityRepository.reference.snapshots().listen((onData) {
      var data = onData.data();
      if (onData.exists) {
        var typing = data['typing'];
        if (typing != null) {
          setState(() {
            typingPeers = typing.keys.where((element) => typing[element] == true).toList();
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _typingSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: typingPeers
          .map(
            (e) => widget.peers[e].id == widget.userId
                ? SizedBox()
                : TypingWidget(
                    peer: widget.peers[e],
                    typingGif: widget.typingGif,
                  ),
          )
          .toList(),
    );
  }
}
