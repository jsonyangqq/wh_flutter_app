import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/model/WorkOrderPoneModel.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'dart:math' as math;
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/Storage.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  bool flag = true;
  String serviceName = "服务名称";
  Map<String,dynamic> userInfo = Map();
  List<dynamic> _workOrderPondDataList = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    _loadPowerExeu();
  }

  Future _loadPowerExeu() async {
    _getUserInfoData().then((info){
      _getWorkOrderPoneData().then((info){

      });
    });
  }


  ///获取用户数据
  _getUserInfoData() async {
    Map<String,dynamic> userInfo = json.decode(await Storage.getString("userInfo"));
    setState(() {
      this.userInfo = userInfo;
    });
  }

  ///获取师傅工单池数据和我的工单数据
  _getWorkOrderPoneData() async {
    int decorationId = this.userInfo["decorationId"];
    var api = Config.domain + "/mobile/workOrderService/getWorkOrderPoneData?decorationId=$decorationId";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      print(response.data);
      setState(() {
        this._workOrderPondDataList = response.data["data"];
      });
    }
  }

  ///遍历工单池数据
  List<Widget> _recWorkOrderListWidget() {
    List<Widget> list = new List<Widget>();
    this._workOrderPondDataList.map((value){
      WorkOrderPondModel workOrderPondModel = WorkOrderPondModel.fromJson(value);
        if(workOrderPondModel.decorationId == null){
          list.add(
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenAdapter.width(16.0), ScreenAdapter.height(8.0), ScreenAdapter.width(16.0),ScreenAdapter.height(0.0)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.grey
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0)))
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: this.flag,
                    trailing: Text('￥${workOrderPondModel.serviceFee}', style: TextStyle(fontSize: ScreenAdapter.size(32.0),
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w500)
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(child: Padding(
                          padding: EdgeInsets.only(left: ScreenAdapter.width(0.0)),
                          child: Text('服务名称：${workOrderPondModel.serviceName}', style: TextStyle(
                              fontSize: ScreenAdapter.size(26.0),
                              fontWeight: FontWeight.w300),),
                        )),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: ScreenAdapter.width(0.0)),
                            child: Text('预约时间：${formatDate(DateTime.parse(workOrderPondModel.appointUpTime),[yyyy, '-', mm, '-', dd, ' ', 'HH', ':', 'nn'])}',
                                style: TextStyle(fontSize: ScreenAdapter.size(20.0),
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.right),
                          ),
                        )
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${workOrderPondModel.description}',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                          ),
                        ),
                      ),
                      ///针对的是多个商品项
                      Column(
                        children: _getOtherWorkOrderDetailsInfo(workOrderPondModel.orderItemDtoList,workOrderPondModel.description)
                      ),
                      ///针对的是图片
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: ScreenAdapter.width(10.0),top: ScreenAdapter.width(20.0)),
                            child: Wrap(
                              spacing: ScreenAdapter.width(46),
                              children: _getImageUrlShow(workOrderPondModel.imageUrl)
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0), ScreenAdapter.height(16.0), ScreenAdapter.width(16.0), ScreenAdapter.height(8.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text('用户地址：${workOrderPondModel.detailAddress}',
                            style: TextStyle(fontSize: ScreenAdapter.size(20.0)),),
                        ),
                      ),
                      RaisedButton(
                        child: Text('提单'),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenAdapter.size(32.0))),
                        onPressed: () {
                          print("普通按钮${workOrderPondModel.workOrderId}");
                          _billOfLoading(workOrderPondModel.workOrderId);
                        },
                      ),
                    ],
                    onExpansionChanged: (value){
                      value = false;
                    },
                  ),
                ),
              )
          );
        }
    }).toList();
    return list;
  }

  ///获取除去第一个以外多余的服务项
  List<Widget> _getOtherWorkOrderDetailsInfo(List<OrderItemDtoList> orderItemDtoList, String description){
    List<Widget> list = new List();
    orderItemDtoList.asMap().forEach((index,value){
        if(index>0){
          list.add(Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left:ScreenAdapter.width(30),top: ScreenAdapter.height(26)),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text('服务名称：${value.serviceName}', style: TextStyle(
                              fontSize: ScreenAdapter.size(26.0),
                              color: Colors.blue,
                              fontWeight: FontWeight.w300),),
                        )),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.only(right: ScreenAdapter.width(36.0),top: ScreenAdapter.height(26.0)),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "￥${value.serviceFee}",
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(32.0),
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.w500
                                  )),
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(24.0) , ScreenAdapter.height(20.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${description}',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                  ),
                ),
              )
            ],
          ));
        }
    });
    return list;
  }

  ///获取工单池图片
  List<Widget> _getImageUrlShow(String imageUrls) {
    List<Widget> list = new List();
    if(imageUrls!=null){
      List<String> splitImageList = imageUrls.split(";");
      splitImageList.forEach((value){
        list.add(
                Image.network(
                "${value}",
                repeat: ImageRepeat.repeatX,
                  alignment: Alignment.topLeft,
                width: ScreenAdapter.width(130.0),
                height: ScreenAdapter.width(130.0),
                fit: BoxFit.fill,
              ),
        );
      });
    }
    return list;
  }


  ///-------------------- 左右切换栏 数据分隔 ------------------------------

  ///遍历我的工单池数据
  List<Widget> _myRecWorkOrderListWidget() {
    List<Widget> list = new List();
    this._workOrderPondDataList.map((value) {
      WorkOrderPondModel workOrderPondModel = WorkOrderPondModel.fromJson(value);
      if (workOrderPondModel.decorationId != null && workOrderPondModel.isComplete == "2") {
        list.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(16.0), ScreenAdapter.height(8.0),
                ScreenAdapter.width(16.0), ScreenAdapter.height(0.0)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Colors.grey
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: this.flag,
                    trailing: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "￥${workOrderPondModel.serviceFee}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(32.0),
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w500
                                )),
                            TextSpan(
                                text: "×${workOrderPondModel.number}",
                                style: TextStyle(
                                  fontSize: ScreenAdapter.size(18.0),
                                  color: Colors.amberAccent,
                                )
                            )
                          ]
                      ),
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('服务名称：${workOrderPondModel.serviceName}', style: TextStyle(
                                  fontSize: ScreenAdapter.size(26),
                                  fontWeight: FontWeight.w300),),
                            ))
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0), 0.0, 0.0, 0.0),
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${workOrderPondModel.description}',
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(21.0),
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                          text: '删除',
                                          style: TextStyle(
                                              fontSize: ScreenAdapter.size(24.0),
                                              color: Colors.blue
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              if(workOrderPondModel.orderItemDtoList.length != 0) {
                                                print("点击了删除订单项编号为${workOrderPondModel.orderItemDtoList}");
                                                DialogPage.alertDialog(
                                                    context, this.serviceName);
                                              }
                                            }
                                      )
                                    ]
                                )
                            )
                        ),
                      ),
                      Column(
                        children: _getmyOtherWorkOrderDetailsInfo(workOrderPondModel.orderItemDtoList, workOrderPondModel.description)
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: ScreenAdapter.width(
                                20.0)),
                            child: Wrap(
                              spacing: ScreenAdapter.width(46),
                              children: _getMyImageUrlShow(workOrderPondModel.imageUrl)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(28.0),
                                ScreenAdapter.height(16.0),
                                ScreenAdapter.width(16.0),
                                ScreenAdapter.height(8.0)),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('用户姓名：${workOrderPondModel.username}',
                                style: TextStyle(fontSize: 12),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(28.0),
                                ScreenAdapter.height(1.0),
                                ScreenAdapter.width(16.0),
                                ScreenAdapter.height(8.0)),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('联系方式：${workOrderPondModel.telphone}',
                                style: TextStyle(fontSize: 12),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(28.0),
                                ScreenAdapter.height(1.0),
                                ScreenAdapter.width(16.0),
                                ScreenAdapter.height(8.0)),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('用户地址：${workOrderPondModel.detailAddress}',
                                style: TextStyle(fontSize: 12),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(28.0),
                                ScreenAdapter.height(1.0),
                                ScreenAdapter.width(16.0),
                                ScreenAdapter.height(8.0)),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: Text('预约时间：${formatDate(DateTime.parse(workOrderPondModel.appointUpTime),[yyyy, '-', mm, '-', dd, ' ', 'HH', ':', 'nn'])} - ${formatDate(DateTime.parse(workOrderPondModel.appointUpEndTime),['HH', ':', 'nn'])}',
                                    style: TextStyle(fontSize: 12))
                            ),
                          ),
                          Offstage(
                              offstage: workOrderPondModel.visibleComplete,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenAdapter.width(15.0), ScreenAdapter.height(10.0), ScreenAdapter.width(0.0), ScreenAdapter.height(5.0)),
                                child: Row(
                                  children: <Widget>[
                                    Transform.rotate(
                                      angle: math.pi / 4.0,
                                      child: IconButton(
                                        icon: ImageIcon(
                                          AssetImage('images/2.0x/u5944.png'),
                                          size: ScreenAdapter.size(30),),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/appendService');
                                        },
                                      ),
                                    ),
                                    TextClickView(
                                      title: "追加服务",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(20),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87
                                      ),
                                      rightClick: (){
                                        Navigator.pushNamed(
                                            context, '/appendService');
                                      },
                                    )
                                  ],
                                ),
                              )
                          ),
                          Offstage(
                            offstage: workOrderPondModel.visibleHomeEntry,
                            child: Wrap(
                              spacing: 80,
                              runSpacing: 10,
                              alignment: WrapAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('确认入户'),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    int index = this._workOrderPondDataList.indexOf(value);
                                    _comfirmHomeEntry(this._workOrderPondDataList, index);
                                  },
                                ),
                                RaisedButton(
                                  child: Text('退单'),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    print("跳转到退单页面");
                                    Navigator.pushNamed(
                                        context, '/chargeBackApply');
                                  },
                                )
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: workOrderPondModel.visibleComplete,
                            child: Wrap(
                              spacing: 80,
                              runSpacing: 10,
                              alignment: WrapAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('已完成'),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    print("已完成");
                                    Navigator.pushNamed(
                                        context, '/comfirmService');
                                  },
                                ),
                                RaisedButton(
                                  child: Text('无法完成'),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    print("退单");
                                    Navigator.pushNamed(
                                        context, '/unComfirmService');
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    onExpansionChanged: (value) {
                      print(value);
                      value = false;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }).toList();
    return list;
  }

  ///获取我的工单池其它服务信息
  List<Widget> _getmyOtherWorkOrderDetailsInfo(List<OrderItemDtoList> orderItemDtoList, String description) {
    List<Widget> list = new List();
    orderItemDtoList.asMap().forEach((index,value){
      if(index>0){
        list.add(Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: ScreenAdapter.width(
                      26.0), top: ScreenAdapter.width(30.0)),
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text('服务名称：${value.serviceName}', style: TextStyle(
                            fontSize: ScreenAdapter.size(26.0),
                            color: Colors.blue,
                            fontWeight: FontWeight.w300),),
                      )),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(
                        right: ScreenAdapter.width(30.0),
                        top: ScreenAdapter.height(28)),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "￥${value.serviceFee}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(32.0),
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w500
                                )),
                            TextSpan(
                                text: "×${value.number}",
                                style: TextStyle(
                                  fontSize: ScreenAdapter.size(18.0),
                                  color: Colors.amberAccent,
                                )
                            )
                          ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(24.0),
                  ScreenAdapter.width(32.0), 0.0, 0.0),
              child: Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${description}',
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(21.0),
                                  color: Colors.black),
                            ),
                            TextSpan(
                                text: '删除',
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(
                                        24.0),
                                    color: Colors.blue
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if(orderItemDtoList.length != 0) {
                                      print("点击了删除订单项编号为${orderItemDtoList}");
                                      DialogPage.alertDialog(
                                          context, this.serviceName);
                                    }
                                  }
                            )
                          ]
                      )
                  )
              ),
            ),
          ],
        ));
      }
    });
    return list;
  }


  ///获取我的工单池图片
  List<Widget> _getMyImageUrlShow(String imageUrls) {
    List<Widget> list = new List();
    if(imageUrls!=null){
      List<String> splitImageList = imageUrls.split(";");
      splitImageList.forEach((value){
        list.add(
          Image.network(
            "${value}",
            repeat: ImageRepeat.repeatX,
            alignment: Alignment.topLeft,
            width: ScreenAdapter.width(130.0),
            height: ScreenAdapter.width(130.0),
            fit: BoxFit.fill,
          ),
        );
      });
    }
    return list;
  }

  ///提单操作
  _billOfLoading(int workOrderId) async {
    int decorationId = this.userInfo["decorationId"];
    var api = Config.domain + "/mobile/workOrderService/masterBillOfLoading?workOrderId=$workOrderId&decorationId=$decorationId";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
        if(response.data["data"]==1){
          Fluttertoast.showToast(
            msg: '提单成功',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          _getWorkOrderPoneData();
        }else if(response.data["data"]==0){
          Fluttertoast.showToast(
            msg: '其它师傅已经接了此单了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          _getWorkOrderPoneData();
        }
    }else {
      Fluttertoast.showToast(
        msg: '${response.data["msg"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }


  ///确认入户
  _comfirmHomeEntry(List<dynamic> list, int index) async {
    var api = Config.domain + "/mobile/workOrderService/masterVisitTime?workOrderId=${list[index]['workOrderId']}";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      if(response.data["data"]==1){
        setState(() {
          this._workOrderPondDataList[index]["visibleHomeEntry"] = true;
          this._workOrderPondDataList[index]["visibleComplete"] = false;
        });
      }else if(response.data["data"]==0){
        Fluttertoast.showToast(
          msg: '此单可能被客户经理重新操作，请联系客户经理进行确认',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        _getWorkOrderPoneData();
      }
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              elevation: 0, //去掉导航栏下方阴影效果
              backgroundColor: Color.fromRGBO(241, 243, 244, 0),
              brightness: Brightness.light,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TabBar(
                      //设置指示器的颜色
                      indicatorColor: Colors.blue,
                      //设置选中时文字的颜色
                      labelColor: Colors.blue,
                      //设置未选中时文字的颜色
                      unselectedLabelColor: Colors.black,
                      //让指示器大小和tab等宽
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: <Widget>[Tab(text: '工单池'), Tab(text: '我的工单')],
                    ),
                  )
                ],
              )),
          body: TabBarView(
            children: <Widget>[
              ListView(
                children: _recWorkOrderListWidget()
              ),
              ListView(
                children: _myRecWorkOrderListWidget()
              ),
            ],
          )),
    );
  }


}