import 'dart:math';

import 'package:firebase_chat/chat/activity_repository.dart';
import 'package:firebase_chat/models.dart';
import 'package:firebase_chat/chat/chat_avatar.dart';
import 'package:firebase_chat/chat/image_activity_widget.dart';
import 'package:firebase_chat/chat/text_activity_widget.dart';
import 'package:firebase_chat/models/peer_user.dart';

import 'package:flutter/material.dart';
import 'package:gallery_previewer/gallery_previewer.dart';
import 'package:intl/intl.dart';

class ChatActivityWidget extends StatelessWidget {
  final List<ActivityLog> listMessage;
  final int i;
  final bool isPeerTyping;
  final PeerUser peer;
  final Widget peerImage;
  final String userId;
  final ActivityLog activityLog;
  final List<GalleryViewItem> images;

  final Radius corner = const Radius.circular(18.0);
  final Radius flat = const Radius.circular(5.0);
  final AssetImage typingGif;
  final ActivityRepository activityRepository;
  final Color primaryColor;
  final Widget loadingWidget;
  const ChatActivityWidget({
    Key key,
    this.primaryColor = Colors.blue,
    this.activityLog,
    this.i,
    this.listMessage,
    this.userId,
    this.peer,
    this.peerImage,
    this.isPeerTyping,
    this.images,
    this.activityRepository,
    this.loadingWidget,
    this.typingGif = const AssetImage('assets/typing.gif'),
  }) : super(key: key);

  bool get typingWidget => i == 0 && isPeerTyping;
  bool get isMe => activityLog.idFrom == this.userId && !typingWidget;

  @override
  Widget build(BuildContext context) {
    var index = getChatIndex(i);

    // print("OLA");
    if (!isMe && activityLog.seenStatus == SeenStatus.Recieved) {
      activityRepository.changeSeenStatus(activityLog.path, SeenStatus.Seen);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: isMe && isLastMessageRight(index) ? 20.0 : 5),
            child: Row(
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //avatar
                  ChatAvatar(
                    showAvatar: !isMe && isLastMessageLeft(index),
                    peer: peer,
                    userImage: peerImage,
                  ),
                  Flexible(
                    child: Material(
                        color: isMe && activityLog is TextActivity ? primaryColor : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: (isMe) || (!isMe && isLastMessageLeft(index + 2)) ? corner : flat,
                          topRight: (isMe && isLastMessageRight(index + 2)) || (!isMe) ? corner : flat,
                          bottomRight: isMe && isLastMessageRight(index) || (!isMe) ? corner : flat,
                          bottomLeft: isMe || (!isMe && isLastMessageLeft(index) && !(isPeerTyping && index != i))
                              ? corner
                              : flat,
                        ),
                        elevation: 2,
                        clipBehavior: Clip.hardEdge,
                        child: typingWidget
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Image(
                                  image: typingGif,
                                  height: 40,
                                  // fit: BoxFit.contain,
                                ))
                            : _drawMessage(activityLog, isMe)),
                  ),

                  //seen
                  isMe
                      ? Icon(
                          activityLog.seenStatus == SeenStatus.Sent
                              ? Icons.fiber_manual_record_outlined
                              : activityLog.seenStatus == SeenStatus.Recieved
                                  ? Icons.check_circle_outline
                                  : Icons.check_circle,
                          size: 12,
                          color: activityLog.seenStatus < SeenStatus.Seen ? primaryColor : Colors.transparent)
                      : Container()
                ])),

        // Time
        !isMe && isLastMessageLeft(index) && !typingWidget
            ? Container(
                child: Text(
                  DateFormat('dd MMM kk:mm').format((activityLog.timestamp).toDate()),
                  style: TextStyle(color: Colors.black, fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            : Container()
      ],
    );
  }

  getChatIndex(int index) {
    return max(index - (isPeerTyping ? 1 : 0), 0);
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[min(index, listMessage.length) - 1].idFrom == this.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[min(index, listMessage.length) - 1].idFrom != this.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  _drawMessage(ActivityLog activityLog, bool isMe) {
    if (activityLog is ImageActivity) {
      return ImageActivityWidget(
        imageActivity: activityLog,
        images: images,
        loadingWidget: loadingWidget,
      );
    } else {
      return TextActivityWidget(textActivity: activityLog as TextActivity, isMe: isMe);
    }
  }
}
