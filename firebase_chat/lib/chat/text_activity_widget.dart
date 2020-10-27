import 'package:flutter/material.dart';
import 'package:firebase_chat/models.dart';

class TextActivityWidget extends StatelessWidget {
  final TextActivity textActivity;
  final bool isMe;
  const TextActivityWidget({Key key, this.textActivity, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textMaxWidth = MediaQuery.of(context).size.width * 2 / 3;
    return Container(
      constraints: BoxConstraints(maxWidth: textMaxWidth),

      child: Text(
        textActivity.text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, color: isMe ? Colors.white : Colors.black),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      // width: hasImage ? 300.0 : double,
      // decoration: BoxDecoration(
      //   //   boxShadow: [
      //   //     BoxShadow(
      //   //         color: Colors.grey, offset: Offset(1.5, 0.5))
      //   //   ],
      // ),
    );
  }
}
