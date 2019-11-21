import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wh_flutter_app/utils/DashedRect.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

/*进入退单申请中心页面*/

class ChargeBackApplyPage extends StatefulWidget {
  @override
  _ChargeBackApplyPageState createState() => _ChargeBackApplyPageState();
}

class _ChargeBackApplyPageState extends State<ChargeBackApplyPage> {

  File _image;
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

  _modelBottomSheet() async{

    var result=await showModalBottomSheet(
        context:context,
        builder: (context){
          return Container(
            height: ScreenAdapter.height(222),
            child: Column(
              children: <Widget>[

                ListTile(
                  title: Text("拍照"),
                  onTap: _takePhoto
                ),
                Divider(),
                ListTile(
                  title: Text("相册"),
                  onTap: _openGellery
                ),
              ],
            ),
          );
        }
    );
    print(result);
  }

  /*拍照*/
  _takePhoto() async{
    File image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: ScreenAdapter.width(180),maxHeight: ScreenAdapter.height(180));
    setState(() {
      this._image = image;
    });
    Navigator.pop(context);
  }

  /*相册*/
  _openGellery() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: ScreenAdapter.width(180),maxHeight: ScreenAdapter.height(180));
    setState(() {
      this._image = image;
    });
    Navigator.pop(context);
  }

  /*定义一个显示图片的组件*/
  Widget _buildImage(){
    if(this._image == null){
      return Text('请选择图片...');
    }
      return Image.file(this._image);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('退单申请'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: new BoxConstraints(
              minHeight: ScreenAdapter.height(120)
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: ScreenAdapter.width(16)),
                  Container(
                    alignment: Alignment.topLeft,
                    child: RaisedButton(
                      child: Text(
                        '取消',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        print(
                          "取消",
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                        child: Text(
                          '提交申请',
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          print("对应退单表单提交！");
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenAdapter.width(16)),
                ],
              ),
              Wrap(
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
              Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8),
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8)),
                child: TextField(
                  maxLines: 6,
                  decoration: InputDecoration(
                      hintText: "请填写退单理由～",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1),
                        ),
                      )),
                ),
              ),
              //拍照上传的地方
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(16),
                      ScreenAdapter.width(8),
                      ScreenAdapter.width(16),
                      ScreenAdapter.width(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: ScreenAdapter.width(180.0),
                              child: DashedRect(
                                  color: Colors.grey, strokeWidth: 0.5, gap: 3.0),
                            ),
                          )
                        ],
                      ),
                      Transform(
                        transform: new Matrix4.translationValues(
                            ScreenAdapter.width(0.0), 0, 0),
                        child: Container(
                          height: ScreenAdapter.height(180.0),
                          child: DashedRect(
                              color: Colors.grey, strokeWidth: 0.5, gap: 3.0),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.translationValues(
                            ScreenAdapter.width(-180.0), 0, 0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
//              width: double.infinity,
                          width: ScreenAdapter.width(180.0),
                          height: ScreenAdapter.height(180.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: ImageIcon(AssetImage("images/4.0x/u2361.png"),size: ScreenAdapter.size(80),),
                                onPressed: _modelBottomSheet,
                              ),
                              SizedBox(height: ScreenAdapter.height(8)),
                              Text(
                                '添加图片',
                                style: TextStyle(
                                    decorationStyle: TextDecorationStyle.dotted),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.translationValues(
                            ScreenAdapter.width(-360.0), 0, 0),
                        child: Container(
                          height: ScreenAdapter.height(180.0),
                          child: DashedRect(
                              color: Colors.grey, strokeWidth: 0.5, gap: 3.0),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.translationValues(
                            ScreenAdapter.width(-360.0),
                            ScreenAdapter.height(180.0),
                            0),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: ScreenAdapter.width(180.0),
                                child: DashedRect(
                                    color: Colors.grey, strokeWidth: 0.5, gap: 3.0),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8),
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildImage()
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
