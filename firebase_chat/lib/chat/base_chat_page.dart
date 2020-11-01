import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_chat/chat/activity_repository.dart';
import 'package:firebase_chat/chat/typing_section.dart';
import 'package:firebase_chat/chat/typing_widget.dart';
import 'package:firebase_chat/models.dart';
import 'package:firebase_chat/chat/chat_content.dart';
import 'package:firebase_chat/models/peer_user.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_previewer/gallery_previewer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'blocs/input/chat_input_cubit.dart';

abstract class BaseChat extends StatefulWidget {
  final String userId;
  final Map<String, PeerUser> peers;
  final String path;
  // final ActivityRepository activityRepository;

  BaseChat({
    Key key,
    @required this.userId,
    @required this.peers,
    @required this.path,
    // @required this.activityRepository,
  }) : super(key: key);

  static BaseChatState of(BuildContext context) {
    return context.findAncestorStateOfType<BaseChatState>();

    // onst TypeMatcher<ChatState>());
  }

  // @override
  // State createState() => new ChatScreenState();
}

abstract class BaseChatState extends State<BaseChat> {
  PaginationBloc<ActivityLog> paginationBloc;

  String userId;

  int messageLimit = 20;

  StreamSubscription _imagesSubscription;

  List<GalleryViewItem> images;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  // Color randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
  ActivityRepository activityRepository;
  ChatInputCubit chatInputCubit;

  @override
  void initState() {
    super.initState();
    this.userId = widget.userId;

    activityRepository = ActivityRepository(widget.path);

    chatInputCubit = ChatInputCubit(
      userId: userId,
      activityRepository: activityRepository,
      textController: textEditingController,
      scrollController: listScrollController,
    );

    // Chat.currentChatPath = widget.path;

    images = new List<GalleryViewItem>();

    _imagesSubscription = activityRepository.getChatImages(activityRepository.reference).listen((onData) {
      bool init = onData.docChanges.length > 1;
      for (var snap in onData.docChanges) {
        switch (snap.type) {
          case DocumentChangeType.added:
            ImageActivity imageData = ImageActivity.fromSnapshot(snap.doc);
            var view = GalleryViewItem(
              id: imageData.documentId,
              url: imageData.imagePath,
              thumbnail: imageData.thumbPath,
            );
            if (init) {
              images.add(view);
            } else
              images.insert(0, view);
            // images.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            break;
          case DocumentChangeType.modified:
            print("OK");
            // ImageActivity imageData = ImageActivity.fromSnapshot(snap.document);
            // int i = images.indexWhere((x) => x.id == snap.document.documentID);
            // images[i] = GalleryExampleItem(
            //     id: imageData.documentID,
            //     url: imageData.imagePath,
            //     thumbnail: imageData.thumbPath);
            break;
          case DocumentChangeType.removed:
            images.removeWhere((x) => x.id == snap.doc.id);
            break;
        }
      }
    });
    var fire = context.repository<FirestoreRepository>();
    var query = fire
        .getQuery([...widget.path.split('/'), 'Activity'], limit: messageLimit).orderBy('timestamp', descending: true);

    paginationBloc = PaginationBloc<ActivityLog>(query, dataToModel, limit: 20);
  }

  @override
  void dispose() {
    super.dispose();
    // Chat.currentChatPath = "";
    paginationBloc.close();
    chatInputCubit.close();

    _imagesSubscription.cancel();
  }

  FutureOr<ActivityLog> dataToModel(snap) {
    ActivityLog activity = ActivityLog.fromSnapshot(snap);

    switch (activity.activityStatus) {
      case ActivityStatus.Text:
        return TextActivity.fromSnapshot(snap);
      case ActivityStatus.Image:
        return ImageActivity.fromSnapshot(snap);
    }
    return activity;
  }

  Future getImage();

  Future editAndUpload(Uint8List data);

  Widget buildItem(int i, List<ActivityLog> messages) {
    var activity = messages[i];
    var userId = activity.userId;
    return ChatActivityWidget(
      activityLog: activity,
      i: i,
      listMessage: messages,
      userId: widget.userId,
      peer: widget.peers[userId],
      images: images,
      activityRepository: activityRepository,
      loadingWidget: loadingWidget,
      primaryColor: primaryColor,
      typingGif: typingGif,
    );
  }

  Widget buildTyping() {
    return TypingSection(
      userId: widget.userId,
      activityRepository: activityRepository,
      peers: widget.peers,
      typingGif: typingGif,
    );
  }

  Widget get loadingWidget;
  Color get primaryColor;

  Widget layout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // List of messages
        Flexible(
          child: SingleChildScrollView(
              controller: listScrollController,
              reverse: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildListMessage(listScrollController),
                  buildTyping(),
                  // buildTyping(),
                ],
              )),
        ),
        // Input content
        buildInput(),
      ],
    );
  }

  Widget buildInput();

  Widget buildListMessage(ScrollController controller);

  ImageProvider get typingGif;
}
