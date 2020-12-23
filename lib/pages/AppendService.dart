
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

import 'Tabs.dart';

/*追加服务页面*/

class AppendServicePage extends StatefulWidget {

  Map arguments;
  AppendServicePage({Key key, this.arguments}) : super(key: key);
  @override
  _AppendServicePageState createState() => _AppendServicePageState();
}

class _AppendServicePageState extends State<AppendServicePage> {

  String serviceName = "这是第1条数据";
  double money=80;

  int workOrderId;
  String orderId;
  int decorationId;
  String _inputPrice = "输入价格";

  String serviceContent;
  double serviceFee;
  double deviceFee;
  double materialFee;

  static var serviceContentController = new TextEditingController();
  static var serviceFeeController = new TextEditingController();
  static var deviceFeeController = new TextEditingController();
  static var materialFeeController = new TextEditingController();

  List<dynamic> serviceList = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    this.workOrderId = widget.arguments['workOrderId'];
    this.orderId = widget.arguments['orderId'];
    this.decorationId = widget.arguments['decorationId'];
    _getListData();
    setState(() {
      serviceContentController.clear();
      serviceFeeController.clear();
      deviceFeeController.clear();
      materialFeeController.clear();
    });
  }




  //左侧按钮

  Widget _leftBtn(int number, int index) {
    return InkWell(
      onTap: () {
        if( this.serviceList[index]['number']>1){
          setState(() {
            this.serviceList[index]['number'] = number-1;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text(
            "-",
          style: TextStyle(
            color: this.serviceList[index]['textColor'] == null ? Colors.black87 : this.serviceList[index]['textColor']
          ),
        ),
      ),
    );
  }

  //右侧按钮
  Widget _rightBtn(int number, int index) {
    return InkWell(
      onTap: (){
        setState(() {
          this.serviceList[index]['number']=number+1;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text(
            "+",
          style: TextStyle(
              color: this.serviceList[index]['textColor'] == null ? Colors.black87 : this.serviceList[index]['textColor']
          ),
        ),
      ),
    );
  }

//中间
  Widget _centerArea(int number, int index) {
    return Container(
      alignment: Alignment.center,
      width: ScreenAdapter.width(70),
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: ScreenAdapter.width(2), color: this.serviceList[index]['lineColor'] == null ? Colors.black12 : this.serviceList[index]['lineColor']),
            right: BorderSide(width: ScreenAdapter.width(2), color: this.serviceList[index]['lineColor'] == null ? Colors.black12 : this.serviceList[index]['lineColor']),
          )),
      height: ScreenAdapter.height(45),
      child: Text(
        "$number",
        style: TextStyle(
          color: this.serviceList[index]['textColor'] == null ? Colors.black87 : this.serviceList[index]['textColor']
        ),
      ),
    );
  }



  ///获取数据列表方法
    _getListData() async{
    var api = Config.domain + "/mobile/workOrderService/getServiceData?decorationId=${this.decorationId}";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      print(response.data);
      setState(() {
        this.serviceList = response.data["data"];
      });
    }
  }

  ///追加服务项方法  接收师傅输入数量和产品编号
  appendServiceItem() async{
    List<Map<String,dynamic>> selectServiceList = new List();
    List<Map<String,dynamic>> personNatiServiceList = new List();
    //1.先获取追加服务中选中的值
    this.serviceList.map((value){
      Map<String,dynamic> map = new Map();
      if(value['flag'] == true && value['identifyType'] == "0"){
        map["identifyType"] = '0';
        map["productId"] = value['productId'];
        map["serviceFee"] = value['serviceFee'];
        map["number"] = value['number'];
        map["orderId"] = this.orderId;
        map["decorationId"] = this.decorationId;
        if(value['number'] > 0) {
          selectServiceList.add(map);
        }
      }else if(value['flag'] == true && value['identifyType'] == '1') {
        map["identifyType"] = '1';
        map["productId"] = value['productId'];
        map["serviceFee"] = this.serviceFee;
        map["number"] = 1;
        map["orderId"] = this.orderId;
        map["decorationId"] = this.decorationId;
        map["serviceContent"] = this.serviceContent;
        map["deviceFee"] = this.deviceFee;
        map["materialFee"] = this.materialFee;
        map["totalMoney"] = double.parse(this._inputPrice);
        selectServiceList.add(map);
        personNatiServiceList.add(map);
      }
    }).toList();
    print("选中的数据为: $selectServiceList");
    if(personNatiServiceList.length > 1){
      Fluttertoast.showToast(
        msg: '一个订单只能存在一个个性化服务商品！',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    if(selectServiceList.length == 0){
      Fluttertoast.showToast(
        msg: '请选中要追加的服务！',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    var api = Config.domain + "/mobile/workOrderService/insertAppendServiceItem";
    var response = await Dio().post(api,data: {"selectServiceList" : selectServiceList});
    if(response.data['ret']==true){
      if(response.data['data'] == true) {
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) =>
            new Tabs(index: 0)
        ));
      }else {
        Fluttertoast.showToast(
          msg: '网络异常，提交数据失败！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }else {
      Fluttertoast.showToast(
        msg: '${response.data["msg"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }


  ///判断这个商品自定义价格类型是否为师傅自定义
  dynamic _judgeIdentifyType(String identifyType,double serviceFee,bool isVisit,int index) {
    Widget widget;
    if(identifyType == "0") {
      return Container(
        alignment: Alignment.centerRight,
        height: ScreenAdapter.height(88),
        child: Text('￥$serviceFee', style: TextStyle(fontSize: ScreenAdapter.size(26),
            color: Color.fromRGBO(255, 204, 51, 1),
            fontWeight: FontWeight.w500)
        ),
      );
    }else if(identifyType == "1") {
      return isVisit ? Offstage(
        offstage: !isVisit,
        child: Container(
          alignment: Alignment.centerRight,
          height: ScreenAdapter.height(88),
          child: Text('￥${this._inputPrice}',
              style: TextStyle(
                fontSize: ScreenAdapter.size(26),
                color: Color.fromRGBO(90, 204, 51, 1),
                fontWeight: FontWeight.w500
              )
          ),
        ),
      ) : Offstage(
        offstage: isVisit,
        child : Container(
              alignment: Alignment.centerRight,
              height: ScreenAdapter.height(88),
              child: TextClickView(
                title: '${this._inputPrice}',
                color: Color.fromRGBO(90, 204, 51, 1),
                style: TextStyle(
                    fontSize: ScreenAdapter.size(42),
                    color: Color.fromRGBO(255, 204, 51, 1),
                    fontWeight: FontWeight.w500
                ),
                rightClick: (){
                  callInputOptions(context,index);
                },
              ),
            )
      );
    }
      return widget;
  }


   callInputOptions(BuildContext context,int index) async {
     await showCupertinoDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
            builder: (context, AsyncSnapshot snapshot){
              return CupertinoAlertDialog(
                title: Text('输入以下内容'),
                content: Card(
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        maxLines: 2,
                        controller: serviceContentController,
                        decoration: InputDecoration(
                          hintText: '请输入服务内容',
                          border: InputBorder.none,
                        ),
                      ),
                      TextField(
                        controller: serviceFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入服务费金额",
                            border: InputBorder.none
                        ),
                      ),
                      TextField(
                        controller: deviceFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入设备费金额",
                            border: InputBorder.none
                        ),
                      ),
                      TextField(
                        controller: materialFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入材料费金额",
                            border: InputBorder.none
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        serviceContentController.clear();
                        serviceFeeController.clear();
                        deviceFeeController.clear();
                        materialFeeController.clear();
                      });
                      Navigator.pop(context);
                      print("取消");
                    },
                    child: Text('取消'),
                  ),
                  CupertinoDialogAction(
                      child: new FlatButton(
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        onPressed: () {
                          print("确定");
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
                            child: GestureDetector(
                              child: Text(
                                '确定',
                                style: new TextStyle(
                                    color: Colors.blue, fontSize: ScreenAdapter.size(28.0),fontWeight: FontWeight.w500),
                              ),
                              onTap: (){
                                if (serviceContentController.text.isEmpty) {
                                  //第三方的插件Toast，https://pub.dartlang.org/packages/fluttertoast
                                  Fluttertoast.showToast(
                                      msg: "服务内容不能为空",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white);
                                  return;
                                } else if (serviceFeeController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "服务费不能为空",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white);
                                  return;
                                } else if (deviceFeeController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "设备费不能为空",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white);
                                  return;
                                } else if (materialFeeController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "材料费不能为空",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white);
                                  return;
                                }
                                setState(() {
                                  this.serviceContent = serviceContentController.text;
                                  this.serviceFee =  serviceFeeController.text.isNotEmpty ? double.parse(serviceFeeController.text) : 0.00;
                                  this.deviceFee = deviceFeeController.text.isNotEmpty ? double.parse(deviceFeeController.text) : 0.00;
                                  this.materialFee = materialFeeController.text.isNotEmpty ? double.parse(materialFeeController.text) : 0.00;
                                  this._inputPrice = (this.serviceFee + this.deviceFee + this.materialFee).toString();
                                  this.serviceList[index]['identifyFlag']=true;
                                });
                                Navigator.pop(context);
                              },
                            )
                        ),
                      )),
                ],
              );
            },
          );
        });
  }


  ///获取商品列表服务信息
  List<Widget> getWidgetServiceInfo() {
    List<Widget> _listData = new List();
    if(this.serviceList.length > 0){
      this.serviceList.asMap().forEach((index,value){
        _listData.add(
          Padding(
              padding: EdgeInsets.only(left: ScreenAdapter.width(20.0),top: ScreenAdapter.height(8.0),bottom: ScreenAdapter.height(0.0),right: ScreenAdapter.width(20)),
              child: Ink(
                //用ink圆角矩形
                // color: Colors.red,
                decoration: BoxDecoration(
                  //背景
                  color: value['backgroundColor'] == null ? Color.fromRGBO(255, 255, 255, 1) : value['backgroundColor'],
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0))),
                  //设置四周边框
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(16.0)),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: ScreenAdapter.width(16.0),right: ScreenAdapter.width(1.0)),
                          child: Container(
                            height: ScreenAdapter.height(88.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "服务名称：${value["serviceName"]}",
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(23.0),
                                  color: value['backgroundColor'] == null ? Colors.black87 : value['textColor']
                              ),
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: ScreenAdapter.width(16.0),left: ScreenAdapter.width(1.0)),
                            child: _judgeIdentifyType(value["identifyType"], value["serviceFee"], value["identifyFlag"],index),
//                            child: Container(
//                              alignment: Alignment.centerRight,
//                              height: ScreenAdapter.height(88),
//                              child: Text('￥${value["serviceFee"]}', style: TextStyle(fontSize: ScreenAdapter.size(30),
//                                  color: Color.fromRGBO(255, 204, 51, 1),
//                                  fontWeight: FontWeight.w500)
//                              ),
//                            ),
                          ),
                        ),
                        Container(
                          width: ScreenAdapter.width(168),
                          decoration:
                          BoxDecoration(
                              border: Border.all(
                                  width: ScreenAdapter.width(2),
                                  color: value['lineColor'] == null ? Colors.black12 : value['lineColor']
                              )
                          ),
                          child: Row(
                            children: <Widget>[
                              _leftBtn(value['number'],index),
                              _centerArea(value['number'],index),
                              _rightBtn(value['number'],index)
                            ],
                          ),
                        ),
                        SizedBox(width: ScreenAdapter.width(16.0))
                      ],
                    ),
                  ),
                  //设置点击事件回调
                  onTap: () {
                    if(value['flag']==false){
                      setState(() {
                        this.serviceList[index]['flag'] = true;
                        this.serviceList[index]['backgroundColor'] = Colors.blue;
                        this.serviceList[index]['textColor'] = Colors.white;
                        this.serviceList[index]['lineColor'] = Colors.white70;
                      });
                    }else{
                      setState(() {
                        this.serviceList[index]['flag'] = false;
                        this.serviceList[index]['backgroundColor'] = Color.fromRGBO(255, 255, 255, 1);
                        this.serviceList[index]['textColor'] = Colors.black87;
                        this.serviceList[index]['lineColor'] = Colors.black12;
                      });
                    }
                  },
                ),
              )
          ),
        );
      });

      //有选择服务时候才会出现追加按钮
      _listData.add(
          Padding(
            padding: EdgeInsets.only(left: ScreenAdapter.width(200),right: ScreenAdapter.width(200),top: ScreenAdapter.height(68.0),bottom: ScreenAdapter.height(32)),
            child: RaisedButton(
              child: Text('追加服务'),
              color: Colors.lightBlue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(32))),
              onPressed: () {
                print("点击追加服务按钮$serviceFee");
                appendServiceItem();
              },
            ),
          )
      );

    }
    return _listData;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('追加服务'),
      ),
      body: ListView(
        children: getWidgetServiceInfo(),
      )
    );
  }
}
