/*定义文本点击事件工具类*/

import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

// ignore: must_be_immutable
class TextClickView extends StatefulWidget {

  String title;
  Color color;
  TextStyle style;
  VoidCallback rightClick;


  TextClickView({this.title,this.color,this.style,this.rightClick});

  @override
  _TextClickViewState createState() => _TextClickViewState(this.title,this.color,this.style,this.rightClick);

}

class _TextClickViewState extends State<TextClickView> {
  String title;
  Color color;
  TextStyle style;
  VoidCallback rightClick;


  _TextClickViewState(title, color, style, rightClick){
      this.title = title;
      this.color = color;
      this.style = style;
      this.rightClick = rightClick;
  }

  var containView;
  @override
  Widget build(BuildContext context) {
    if(title  != null){
      containView = new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: ScreenAdapter.width(16.0), right: ScreenAdapter.width(16)),
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
