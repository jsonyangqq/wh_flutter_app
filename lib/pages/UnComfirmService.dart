
import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

/*无法完成服务确认*/

class UnComfirmServicePage extends StatefulWidget {
  @override
  _UnComfirmServicePageState createState() => _UnComfirmServicePageState();
}

class _UnComfirmServicePageState extends State<UnComfirmServicePage> {

  bool btnFlag = true;
  Color backgroundColor;
  Color textColor;
  Color backgroundColor2;
  Color textColo2;
  Color backgroundColor3;
  Color textColor3;

  @override
  void initState() {
    super.initState();
    backgroundColor = Color.fromRGBO(242, 242, 242, 1);
    textColor = Color.fromRGBO(102, 102, 102, 1);
    backgroundColor2 = Color.fromRGBO(242, 242, 242, 1);
    textColo2 = Color.fromRGBO(102, 102, 102, 1);
    backgroundColor3 = Color.fromRGBO(242, 242, 242, 1);
    textColor3 = Color.fromRGBO(102, 102, 102, 1);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('服务确认'),
      ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: ScreenAdapter.width(20.0),top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(8.0),right: ScreenAdapter.width(20)),
          child: Text('请填写一下必要信息',style: TextStyle(fontSize: ScreenAdapter.size(32)),),
        ),
        Padding(
          padding: EdgeInsets.only(left: ScreenAdapter.width(16)),
          child: Wrap(
            spacing: ScreenAdapter.width(60.0),
            runSpacing: ScreenAdapter.height(10),
            alignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: backgroundColor,
                textColor: textColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(ScreenAdapter.width(20.0))),
                child: Text(
                  '第一集',
                  style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                ),
                onPressed: () {
                  print('点击上去，按钮变颜色变成选中');
                  /*点击的时候如果没有选中，则让其选中*/
                  if (backgroundColor == Color.fromRGBO(242, 242, 242, 1)) {
                    setState(() {
                      backgroundColor = Colors.lightBlue;
                      textColor = Colors.white;
                    });
                  } else {
                    setState(() {
                      backgroundColor = Color.fromRGBO(242, 242, 242, 1);
                      textColor = Color.fromRGBO(102, 102, 102, 1);
                    });
                  }
                },
              ),
              RaisedButton(
                color: backgroundColor2,
                textColor: textColo2,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(ScreenAdapter.width(20.0))),
                child: Text('第一集ssssssssss', style: TextStyle(fontSize: ScreenAdapter.size(20.0)),),
                onPressed: () {
                  print('点击上去，按钮变颜色变成选中');
                  /*点击的时候如果没有选中，则让其选中*/
                  if (backgroundColor2 == Color.fromRGBO(242, 242, 242, 1)) {
                    setState(() {
                      backgroundColor2 = Colors.lightBlue;
                      textColo2 = Colors.white;
                    });
                  } else {
                    setState(() {
                      backgroundColor2 = Color.fromRGBO(242, 242, 242, 1);
                      textColo2 = Color.fromRGBO(102, 102, 102, 1);
                    });
                  }
                },
              ),
              RaisedButton(
                color: backgroundColor3,
                textColor: textColor3,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(ScreenAdapter.width(20.0))),
                child: Text('第一集ssss', style: TextStyle(fontSize: ScreenAdapter.size(20.0)),),
                onPressed: () {
                  print('点击上去，按钮变颜色变成选中');
                  /*点击的时候如果没有选中，则让其选中*/
                  if (backgroundColor3 == Color.fromRGBO(242, 242, 242, 1)) {
                    setState(() {
                      backgroundColor3 = Colors.lightBlue;
                      textColor3 = Colors.white;
                    });
                  } else {
                    setState(() {
                      backgroundColor3 = Color.fromRGBO(242, 242, 242, 1);
                      textColor3 = Color.fromRGBO(102, 102, 102, 1);
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: ScreenAdapter.width(16.0),top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(8.0),right: ScreenAdapter.width(16)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: ScreenAdapter.width(1),color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(32))),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Container(
                    width: ScreenAdapter.width(500),
                    height: ScreenAdapter.height(80),
                    child: TextField(
                      decoration:InputDecoration(
                          hintText:"请上传部分图片以更好的描述情况",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          )
                      ) ,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(height: ScreenAdapter.height(40), child: VerticalDivider(color: Colors.grey)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('点击上传'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(16),
              ScreenAdapter.height(8),
              ScreenAdapter.width(16),
              ScreenAdapter.height(8)),
          child: TextField(
            maxLines: 6,
            decoration: InputDecoration(
                hintText: "请详细描述无法完成的原因～",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(242, 242, 242, 1),
                  ),
                )),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: ScreenAdapter.height(120)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: ScreenAdapter.width(400),
                  height: ScreenAdapter.height(56),
                  child: RaisedButton(
                    child: Text('提交说明并退单',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w500),),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenAdapter.width(32))),
                    onPressed: () {
                      print("提交说明并退单");
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
    );
  }
}
