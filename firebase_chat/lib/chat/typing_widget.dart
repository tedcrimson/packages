import 'package:firebase_chat/chat/chat_avatar.dart';
import 'package:firebase_chat/models/peer_user.dart';
import 'package:firebase_chat/utils/converter.dart';
import 'package:flutter/material.dart';

class TypingWidget extends StatelessWidget {
  final PeerUser peer;
  final Radius corner;
  final ImageProvider typingGif;

  const TypingWidget({this.peer, this.typingGif, this.corner = const Radius.circular(18.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //avatar
              ChatAvatar(
                showAvatar: true,
                peer: peer,
                userImage: Converter.convertToImage(peer?.image, size: 40),
              ),
              Flexible(
                  child: Material(
                      // color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(corner),
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Image(
                            image: typingGif,
                            height: 40,
                            // fit: BoxFit.contain,
                          ))))
            ]));
  }
}
