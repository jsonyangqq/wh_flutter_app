/*定义文本点击事件工具类*/

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextClickView extends StatefulWidget {

  String title;
  Color color;
  VoidCallback rightClick;


  TextClickView({this.title,this.color,this.rightClick});

  @override
  _TextClickViewState createState() => _TextClickViewState(this.title,this.color,this.rightClick);
}

class _TextClickViewState extends State<TextClickView> {
  String title;
  Color color;
  VoidCallback rightClick;


  _TextClickViewState(title, color, rightClick){
      this.title = title;
      this.color = color;
      this.rightClick = rightClick;
  }

  var containView;
  @override
  Widget build(BuildContext context) {
    if(title  != null){
      containView = new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: GestureDetector(
          child: Text(
            this.title,
            style: TextStyle(color: this.color),
          ),
          onTap: this.rightClick,
        ),
      );
    }else{
      containView = Text("");
    }
    return containView;
  }
}
