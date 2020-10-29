import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_chat/chat/activity_repository.dart';
import 'package:firebase_chat/models.dart';
import 'package:firebase_chat/chat/chat_content.dart';
import 'package:firebase_chat/gallery/gallery_view_item.dart';
import 'package:firebase_chat/models/peer_user.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/converter.dart' as converter;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'blocs/input/chat_input_cubit.dart';

abstract class BaseChat extends StatefulWidget {
  final String userId;
  final PeerUser peer;
  final String path;
  // final ActivityRepository activityRepository;

  BaseChat({
    Key key,
    @required this.userId,
    @required this.peer,
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

  bool isPeerTyping = false;

  Widget userImage;

  int messageLimit = 20;

  StreamSubscription _typingSubscription;
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
      userFrom: userId,
      userTo: widget.peer.id,
      activityRepository: activityRepository,
      textController: textEditingController,
      scrollController: listScrollController,
    );

    // Chat.currentChatPath = widget.path;

    userImage = converter.Converter.convertToImage(widget.peer.image, size: 40);

    images = new List<GalleryViewItem>();

    _getTyping();

    _imagesSubscription = activityRepository.getChatImages(activityRepository.reference).listen((onData) {
      bool init = onData.docChanges.length > 1;
      for (var snap in onData.docChanges) {
        switch (snap.type) {
          case DocumentChangeType.added:
            ImageActivity imageData = ImageActivity.fromSnapshot(snap.doc);
            var view = GalleryViewItem(
              id: imageData.documentID,
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
      // setState(() {});//TODO: adonou
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

    _typingSubscription.cancel();
    _imagesSubscription.cancel();
  }

  _getTyping() {
    _typingSubscription = activityRepository.reference.snapshots().listen((onData) {
      if (onData.exists && onData.data().containsKey(widget.peer.id)) {
        // setState(() {
        isPeerTyping = onData.data()[widget.peer.id];
        // });
        paginationBloc.add(PaginationRefreshEvent());
      }
    });
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
    var index = max(i - (isPeerTyping ? 1 : 0), 0);
    return ChatActivityWidget(
      activityLog: messages[index],
      i: i,
      listMessage: messages,
      userId: userId,
      peer: widget.peer,
      peerImage: userImage,
      isPeerTyping: isPeerTyping,
      images: images,
      activityRepository: activityRepository,
      loadingWidget: loadingWidget,
      primaryColor: primaryColor,
    );
  }

  Widget get loadingWidget;
  Color get primaryColor;

  Widget layout() {
    return Column(
      children: <Widget>[
        // List of messages
        Flexible(child: buildListMessage()),
        // Input content
        buildInput(),
      ],
    );
  }

  Widget buildInput();

  PaginationList<ActivityLog> buildListMessage();
}
