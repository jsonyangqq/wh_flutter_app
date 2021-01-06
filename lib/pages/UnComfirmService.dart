
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

/*无法完成服务确认*/

class UnComfirmServicePage extends StatefulWidget {

  Map arguments;

  UnComfirmServicePage({Key key, this.arguments}) : super(key: key);

  @override
  _UnComfirmServicePageState createState() => _UnComfirmServicePageState();
}

class _UnComfirmServicePageState extends State<UnComfirmServicePage> {

  int workOrderId;
  int decorationId;
  List abilityTagList;
  PickedFile _image;
  String imageUrlAddress;
  String hintTextChg = null;
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
                  //选中泡泡的时候
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
      this.hintTextChg = "已选择上传图片";
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
    await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      this._image = image;
      this.hintTextChg = "已选择上传图片";
    });

    Fluttertoast.showToast(
      msg: '已选择好了要上传的图片',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    Navigator.pop(context);
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
    var fileDir = "";
//    String abilityStr = "";
    var fileName = "";
    if(_imageDir != null){
      fileDir=_imageDir.path;
      setState(() {
        this.imageUrlAddress = fileDir;
      });
      fileName = fileDir.substring(fileDir.lastIndexOf("/")+1);
//      this.abilityTagList.asMap().forEach((index,abilityTag){
//        if(index != this.abilityTagList.length-1 && abilityTag["flag"] == true){
//          abilityStr +=abilityTag["name"]+"##;";
//        }
//      });
    }

    FormData formData = FormData.fromMap({
      "workOrderId": this.workOrderId,
      "decorationId": this.decorationId,
      "chargebackType": "1",
      "description": this.descrptionReason,
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
          padding: EdgeInsets.only(left: ScreenAdapter.width(16)),
          child: Wrap(
            spacing: ScreenAdapter.width(60.0),
            runSpacing: ScreenAdapter.height(10),
            alignment: WrapAlignment.spaceEvenly,
            children: _fillWidgetBubble()
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
                      enabled: false,
                      decoration:InputDecoration(
                          hintText:this.hintTextChg == null ? "请上传部分图片以更好的描述情况" : this.hintTextChg,
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
                  child: TextClickView(
                    title: '点击上传',
                    rightClick: (){
                      _modelBottomSheet();
                    },
                  ),
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
            controller: _editingController,
            decoration: InputDecoration(
                hintText: "请详细描述无法完成的原因～",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(242, 242, 242, 1),
                  ),
                ),
            ),
            onChanged: (text) {
              this.descrptionReason = text;
            },
            onSubmitted: (text) {
              this.descrptionReason = text;
            },
          ),
        ),
        //显示上传的图片的位置
        _buildImage(),
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
    );
  }

  /*加载图片*/
  Widget _buildImage() {
    if(this._image == null){
      return Text('');
    }
    List<String> listImages = new List<String>();
    listImages.add(this._image.path);
    return Container(
        alignment: Alignment.center,
        height: ScreenAdapter.height(300.0),
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
    );
  }
}
