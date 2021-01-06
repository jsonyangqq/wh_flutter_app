
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/Storage.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';
import 'package:photo_view/photo_view.dart';

/*已完成 确认服务页面*/

class ComfirmServicePage extends StatefulWidget {

  Map arguments;
  ComfirmServicePage({Key key, this.arguments}) : super(key: key);

  @override
  _ComfirmServicePageState createState() => _ComfirmServicePageState();
}

class _ComfirmServicePageState extends State<ComfirmServicePage> {

  PickedFile _image;
  String _imageUrlAddress='';
  int workOrderId;
  var selectFileUrlController = new TextEditingController();
  Map<String,dynamic> userInfo = Map();
  bool isDecorationImgShow = true;

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfoData();
    this.workOrderId =widget.arguments['workOrderId'];
  }

  ///获取用户数据
  _getUserInfoData() async {
    Map<String,dynamic> userInfo = json.decode(await Storage.getString("userInfo"));
    setState(() {
      this.userInfo = userInfo;
    });
  }

  Future<void> _modelBottomSheet() async{
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
    var image = await _picker.getImage(source: ImageSource.camera);

    if(null == image) {
      Fluttertoast.showToast(
        msg: '请先选择要进行上传的图片',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: '上传图片成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    setState(() {
      if(image != null) {
        this._image = image;
        this.isDecorationImgShow = false;
      }
    });

    Navigator.pop(context);

  }

  /*相册*/
  _openGallery() async {
    var image =
    await _picker.getImage(source: ImageSource.gallery);

    if(null == image) {
      Fluttertoast.showToast(
        msg: '请先选择要进行上传的图片',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }else {
      Fluttertoast.showToast(
        msg: '上传图片成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    setState(() {
      if(image != null) {
        this._image = image;
        this.isDecorationImgShow = false;
        loadImageResource(userInfo);
      }
    });

    Navigator.pop(context);
  }

  //上传图片到服务器
  _uploadImage(PickedFile _imageDir) async {

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
    setState(() {
      isLoading = true;
    });
    var response = await Dio().post(api, data: formData);
    print(response);
    setState(() {
      isLoading = false;
    });
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
      body: isLoading ?
      Center(
        child: Padding(
          padding: EdgeInsets.all(1.0),
          child: Container(
            width: double.infinity,
            color: Color.fromRGBO(255, 255, 255, 0.6 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                    strokeWidth: 2.0
                ),
                SizedBox(height: ScreenAdapter.height(20.0),),
                Text(
                  '提交中，请稍后...',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
      )
          :
      Column(
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
                  //加载用户上传图片或者是师傅收钱吧二维码，二者只会出现一个
                  loadImageResource(userInfo),
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
                          ),
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




  /*加载图片区域 不是展示师傅收钱吧二维码就是展示用户上传的图片*/
  loadImageResource(Map<String, dynamic> userInfo){
    List<String> listImages = new List<String>();
    if(this._image != null) {
      listImages.add(this._image.path);
    }
      return isDecorationImgShow ?
       Expanded(
        flex: 6,
        child: Container(
          alignment: Alignment.center,
          child: Image.network('${this.userInfo["spare1"]}',width: ScreenAdapter.width(700.0),height: ScreenAdapter.height(750.0),fit: BoxFit.fill,),
        ),
      ) :
      Expanded(
        flex: 6,
        child: Stack(
          children: <Widget>[
            Positioned(
              child:  Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      //点击图片的时候跳转道图片放大页面
                      Navigator.pushNamed(context,"/photoAssetGallery",arguments: {
                        "index": 0,
                        "galleryItems": listImages,
                      });
                    },
                    child: Image.file(new File(this._image.path),fit: BoxFit.cover,),
                  )
              ),
            ),
            Positioned(
              right: ScreenAdapter.width(-14.0),
              top: ScreenAdapter.height(-20.0),
              child: IconButton(
                icon: Icon(
                  IconData(0xe725,fontFamily: 'AntDelIcons'),
                  size: ScreenAdapter.size(50.0),
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  //删除当前选中的图片
                  setState(() {
                    this._image = null;
                    this.isDecorationImgShow = true;
                  });
                },
              ),
            )
          ],
        ),
      );
  }
}
