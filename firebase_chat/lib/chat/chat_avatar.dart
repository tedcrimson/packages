import 'package:firebase_chat/models/peer_user.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final bool showAvatar;
  final PeerUser peer;
  final Widget userImage;
  const ChatAvatar({Key key, this.showAvatar, this.peer, this.userImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: showAvatar
            ? Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Container(
                        color: Colors.indigo,
                        width: 40,
                        height: 40,
                        child: peer?.image == null || peer.image.isEmpty
                            ? Center(
                                child: Text(
                                peer.name[0],
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ))
                            : userImage),
                  ),
                  // peer.online == true
                  //     ? Container(
                  //         width: 14,
                  //         height: 14,
                  //         decoration: BoxDecoration(
                  //             color: Colors.green,
                  //             border: Border.all(color: Colors.white, width: 2),
                  //             shape: BoxShape.circle))
                  // : Container()
                ],
              )
            : Container(
                width: 40,
              ));
  }
}
