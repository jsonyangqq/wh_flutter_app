
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

/*已完成 确认服务页面*/

class ComfirmServicePage extends StatefulWidget {

  Map arguments;
  ComfirmServicePage({Key key, this.arguments}) : super(key: key);

  @override
  _ComfirmServicePageState createState() => _ComfirmServicePageState();
}

class _ComfirmServicePageState extends State<ComfirmServicePage> {

  File _image;
  String _imageUrlAddress='';
  int workOrderId;
  var selectFileUrlController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.workOrderId =widget.arguments['workOrderId'];
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
                    onTap: _openGallery
                ),
              ],
            ),
          );
        }
    );
    print(result);
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);

    setState(() {
      this._image = image;
    });

    Fluttertoast.showToast(
      msg: '上传图片成功',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    Navigator.pop(context);

  }

  /*相册*/
  _openGallery() async {
    var image =
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 400);

    setState(() {
      this._image = image;
    });

    Fluttertoast.showToast(
      msg: '上传图片成功',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    Navigator.pop(context);
  }

  //上传图片到服务器
  _uploadImage(File _imageDir) async {

    //注意：dio3.x版本为了兼容web做了一些修改，上传图片的时候需要把File类型转换成String类型，具体代码如下
    if(_imageDir == null){
      Fluttertoast.showToast(
        msg: '请先上传图片',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    var fileDir=_imageDir.path;
    setState(() {
      this._imageUrlAddress = fileDir;
    });
    var fileName = fileDir.substring(fileDir.lastIndexOf("/")+1);

    FormData formData = FormData.fromMap({
      "workOrderId": this.workOrderId,
      "file":  await MultipartFile.fromFile(fileDir, filename: fileName)
    });
    var api = Config.domain + "/mobile/workOrderService/imguploadComplateWorder";
//    Options options = Options(headers: {HttpHeaders.contentTypeHeader:"multipart/form-data"});
    var response = await Dio().post(api, data: formData);
    print(response);
    if(response.data['ret']==true){
      String msg = '确认服务完成';
      String msg2 = "并得到用户认可";
      DialogPage.comfirmDialog(
          context, msg,msg2);
    }else {
      Fluttertoast.showToast(
        msg: '${response.data["msg"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
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
            padding: EdgeInsets.only(left: ScreenAdapter.width(30.0),top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(8.0),right: ScreenAdapter.width(30)),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: ScreenAdapter.width(1),color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(32))),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 16,
                    child: Container(
                      width: ScreenAdapter.width(500),
                      height: ScreenAdapter.height(80),
                      child: TextField(
                        controller: selectFileUrlController,
                        enabled: false,
                        decoration:InputDecoration(
                            hintText:"请上传图片用于工单凭证",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            )
                        ) ,
                        onChanged: (text) {

                        }
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(height: ScreenAdapter.height(40), child: VerticalDivider(color: Colors.grey)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextClickView(
                        title: '点击上传',
                        rightClick: (){
                          _modelBottomSheet();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:  Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset('images/4.0x/u8634.png',width: ScreenAdapter.width(480.0),height: ScreenAdapter.height(480.0),),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: ScreenAdapter.width(30),right: ScreenAdapter.width(30.0)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:  RaisedButton(
                              child: Text('现金支付',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w500),),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              onPressed: () {
                                print("现金支付");
                                this._uploadImage(this._image);
                              },
                            ),
                          ),
                          SizedBox(width: ScreenAdapter.size(60.0),),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              child: Text('完成服务',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w500),),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                print("完成服务");
                                this._uploadImage(this._image);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
