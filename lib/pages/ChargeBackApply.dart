import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/DashedRect.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

/*进入退单申请中心页面*/

class ChargeBackApplyPage extends StatefulWidget {

  Map arguments;

  ChargeBackApplyPage({Key key, this.arguments}) : super(key: key);

  @override
  _ChargeBackApplyPageState createState() => _ChargeBackApplyPageState();
}

class _ChargeBackApplyPageState extends State<ChargeBackApplyPage> {

  PickedFile _image;
  int workOrderId;
  int decorationId;
  List abilityTagList;
  String imageUrlAddress;
  String descrptionReason;
  List optionTagNameList;

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  TextEditingController _editingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    descrptionReason = "";
    optionTagNameList = [];
    _getExistWOrderList();
    //获取其它页面传递过来的数据
    this.workOrderId =widget.arguments['workOrderId'];
    this.decorationId =widget.arguments['decorationId'];
  }

  ///获取师傅退单泡泡
  _getExistWOrderList() async {
    var api = Config.domain + "/mobile/workOrderService/getChargeBackBubbleData?type=7";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      setState(() {
        this.abilityTagList = response.data['data'];
      });
    }
  }

  List<Widget> _fillWidgetBubble() {
    List<Widget> list = new List();
    if(this.abilityTagList!=null){
      this.abilityTagList.asMap().forEach((index,value){
        list.add(
            RaisedButton(
              color: value['backgroundColor'] == null ? Color.fromRGBO(242, 242, 242, 1) : value['backgroundColor'],
              textColor: value['textColor'] == null ? Color.fromRGBO(102, 102, 102, 1) : value['textColor'],
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(ScreenAdapter.width(20.0))),
              child: Text(
                "${value['name']}",
                style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
              ),
              onPressed: () {
                if(value["flag"] == false){
                  setState(() {
                    this.abilityTagList[index]['flag'] = true;
                    this.abilityTagList[index]['backgroundColor'] = Colors.lightBlue;
                    this.abilityTagList[index]['textColor'] = Colors.white;
                    optionTagNameList.add(this.abilityTagList[index]['name']);
                  });
                }else {
                  setState(() {
                    this.abilityTagList[index]['flag'] = false;
                    this.abilityTagList[index]['backgroundColor'] = Color.fromRGBO(242, 242, 242, 1);
                    this.abilityTagList[index]['textColor'] = Color.fromRGBO(102, 102, 102, 1);
                    optionTagNameList.remove(this.abilityTagList[index]['name']);
                  });
                }
                descrptionReason = optionTagNameList.toString()?? '';
                if(descrptionReason == '[]') {
                  descrptionReason = '';
                }
                _editingController = new TextEditingController(text: descrptionReason);
              },
            )
        );
      });
    }
    return list;
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
    var image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      this._image = image;
    });

    Navigator.pop(context);

  }

  /*相册*/
  _openGallery() async {
    var image =
    await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      this._image = image;
    });
    Navigator.pop(context);
  }

  /*定义一个显示图片的组件*/
  Widget _buildImage(){
    List<String> listImages = new List<String>();
    if(this._image == null){
      return Text('请选择图片...');
    }
    listImages.add(this._image.path);
      return Container(
        child: GestureDetector(
          onTap: () {
            //点击图片的时候跳转道图片放大页面
            Navigator.pushNamed(context,"/photoAssetGallery",arguments: {
              "index": 0,
              "galleryItems": listImages,
            });
          },
          child: Image.file(new File(this._image.path),width: ScreenAdapter.width(700.0),height: ScreenAdapter.height(750.0),fit: BoxFit.cover,),
        )
      );
  }

  //上传图片到服务器
  _uploadImage(PickedFile _imageDir) async {

    //注意：dio3.x版本为了兼容web做了一些修改，上传图片的时候需要把File类型转换成String类型，具体代码如下
//    if(_imageDir == null){
//      Fluttertoast.showToast(
//        msg: '请先上传图片',
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER,
//      );
//      return;
//    }
    var fileDir="";
    String abilityStr = "";
    var fileName = "";
    if(_imageDir != null){
      fileDir=_imageDir.path;
      setState(() {
        this.imageUrlAddress = fileDir;
      });
      fileName = fileDir.substring(fileDir.lastIndexOf("/")+1);
      this.abilityTagList.asMap().forEach((index,abilityTag){
        if(index != this.abilityTagList.length-1 && abilityTag["flag"] == true){
          abilityStr +=abilityTag["name"]+"##;";
        }
      });
    }
    FormData formData = FormData.fromMap({
      "workOrderId": this.workOrderId,
      "decorationId": this.decorationId,
      "chargebackType": "0",
      "description": abilityStr+this.descrptionReason,
      "file":  _imageDir == null ? null : await MultipartFile.fromFile(fileDir, filename: fileName)
    });
    setState(() {
      isLoading = true;
    });
    var api = Config.domain + "/mobile/workOrderService/getUnableCompleteChgBack";
    var response = await Dio().post(api, data: formData);
    setState(() {
      isLoading = false;
    });
    print(response);
    if(response.data['ret']==true){
      String msg = '退单服务已申请成功';
      String msg2 = "";
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
        title: Text('退单申请'),
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
      SingleChildScrollView(
        child: ConstrainedBox(
          constraints: new BoxConstraints(
              minHeight: ScreenAdapter.height(120),
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
                          this._uploadImage(this._image);
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
                children: _fillWidgetBubble(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8),
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8)),
                child: TextField(
                  maxLines: 6,
                  controller: _editingController,
                  decoration: InputDecoration(
                      hintText: "请填写退单理由～",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1),
                        ),
                      )),
                  onChanged: (text) {
                    this.descrptionReason = text;
                  },
                  onSubmitted: (text) {
                    this.descrptionReason = text;
                  },
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
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    children: <Widget>[
                      _buildImage()
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
