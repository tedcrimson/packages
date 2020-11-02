import 'dart:typed_data';

import 'package:draw_page/draw_page.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera_capture/camera_capture.dart';

class ChatPage extends BaseChat {
  ChatPage({
    @required ChatEntity entity,
  }) : super(entity);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends BaseChatState<ChatPage> {
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget buildInput() {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  focusNode: focusNode,
                  onSubmitted: (text) {
                    if (text.isNotEmpty) chatInputCubit.sendMessage();
                  },
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20.0),
                  controller: textEditingController,
                  onChanged: chatInputCubit.inputChange,
                  decoration: InputDecoration.collapsed(
                    hintText: "Type here",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            BlocBuilder<ChatInputCubit, ChatInputState>(
                cubit: chatInputCubit,
                builder: (context, state) {
                  return Row(children: [
                    if (state is InputEmptyState && !kIsWeb)
                      Material(
                        child: new Container(
                          child: new IconButton(
                            icon: new Icon(Icons.add_a_photo),
                            onPressed: () => getImage(),
                            color: primaryColor,
                            disabledColor: Colors.grey,
                          ),
                        ),
                        color: Colors.white,
                      ),

                    // Button send message
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.only(right: 4.0),
                        child: new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: state is ReadyToSendState ? chatInputCubit.sendMessage : null,
                          color: primaryColor,
                          disabledColor: Colors.grey,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ]);
                })
          ],
        ),
      ),
    );
  }

  @override
  Future editAndUpload(Uint8List data) async {
    var edited = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return DrawPage(imageData: data, loadingWidget: loadingWidget);
    }));
    chatInputCubit.sendImage(edited);
  }

  @override
  Future getImage() async {
    List<Uint8List> images;
    // if (kIsWeb) {
    //   PickedFile imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    //   if (imageFile != null) {
    //     var image = await imageFile.readAsBytes();
    //     images = [image];
    //   }
    // } else {

    images = await Navigator.of(context)
        .push<List<Uint8List>>(MaterialPageRoute(builder: (BuildContext context) => CameraPage()));
    if (images != null && images.length == 1) {
      var image = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
        return DrawPage(imageData: images[0], loadingWidget: loadingWidget);
      }));
      if (image == null) return null;
      images = [image];
    }

    if (images != null) {
      for (var image in images) {
        await chatInputCubit.sendImage(image);
      }
    }
  }

  @override
  Widget get loadingWidget => Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );

  @override
  Color get primaryColor => Colors.blue;

  @override
  ImageProvider<Object> get typingGif => const AssetImage('assets/typing.gif');

  @override
  Widget get onEmpty => Center(
          child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text("Welcome"),
      ));

  @override
  Widget get onError => Center(child: Text("Something wrong"));
}
