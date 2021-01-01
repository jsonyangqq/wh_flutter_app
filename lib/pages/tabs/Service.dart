import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/model/WorkOrderPoneModel.dart';
import 'package:wh_flutter_app/utils/DialogPage.dart';
import 'dart:math' as math;
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/Storage.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

class ServicePage extends StatefulWidget {

  Map arguments;

  ServicePage({Key key, this.arguments}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  bool flag = true;
  Map<String,dynamic> userInfo = Map();
  List<dynamic> _workOrderPondDataList = new List<dynamic>();
  int currentIndex = 0;
  //服务名称标题容器占比  占手机总屏幕得55%
  double titleWdithRate = 0.55;
  //工单池显示 服务名称标题容器占比  占手机总屏幕得71%
  double workOrderTitleWdithRate = 0.71;

  PageController _pageController = new PageController();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.arguments != null && widget.arguments["serviceHomeIndex"] != null) {
        currentIndex = widget.arguments["serviceHomeIndex"];
      }
      print('打印的回调的值为$currentIndex');
      _tabController = TabController(initialIndex: currentIndex, length: 2,vsync: this);
    });
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
                    trailing: Text('￥${workOrderPondModel.serviceFee}', style: TextStyle(fontSize: ScreenAdapter.size(26.0),
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w500),
                    ),
                    title: Container(
                        alignment: Alignment.topLeft,
                        width: ScreenAdapter.getScreenWidth() * workOrderTitleWdithRate,//避免超出手机屏幕，所以要给容易一个宽度，超出部分自动隐藏
                        child: Padding(
                          padding: EdgeInsets.only(left: ScreenAdapter.width(0.0)),
                          child: Text('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}', style: TextStyle(
                              fontSize: ScreenAdapter.size(26.0),
                              fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                        )),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '用户问题描述：${workOrderPondModel.description}',
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: ScreenAdapter.size(24.0)),
                          ),
                        ),
                      ),
                      ///用户上传的图片，针对的是图片
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
                      //这一块记录用户具体提交的订单信息，以及生成的一些工单内容信息
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text('新工作流工单流水号：${workOrderPondModel.newWfJobNumber}',
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(24.0),
                                  color: Colors.black87),
                              textAlign: TextAlign.right),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text('服务内容：${workOrderPondModel.serviceName}',
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(24.0),
                                  color: Colors.black87),
                              textAlign: TextAlign.right),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text('预约时间：${formatDate(DateTime.parse(workOrderPondModel.appointUpTime),[yyyy, '-', mm, '-', dd])}',
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(24.0),
                                  color: Colors.black87),
                              textAlign: TextAlign.right),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(8.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            child: Container(
                                child: SelectableText(
                                  '客户地址：${workOrderPondModel.detailAddress.replaceAll(workOrderPondModel.detailAddress.substring(workOrderPondModel.detailAddress.lastIndexOf('区')+1), '')}',
                                  style: TextStyle(color: Colors.black87,fontSize: ScreenAdapter.size(24.0)),
                                  scrollPhysics: ClampingScrollPhysics(),
                                )),
                            onLongPress: () {

                            },
                          ),
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
  List<Widget> _myRecWorkOrderListWidget(){
    List<Widget> list = new List();
    this._workOrderPondDataList.asMap().forEach((index,value) {
      WorkOrderPondModel workOrderPondModel = WorkOrderPondModel.fromJson(value);
      var imageUrls = workOrderPondModel.imageUrl;
      List<String> listImages = (imageUrls==null || imageUrls == "") ?  new List<String>() : imageUrls.substring(0,imageUrls.lastIndexOf(";")).split(";");
      //66表示处理中的售后工单
      if (workOrderPondModel.decorationId != null && workOrderPondModel.orderType == "2") {
        list.add(
          //添加售后工单，字体改为红色
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
                    leading: Image.asset('images/2.0x/toushu.png',width: ScreenAdapter.width(42),height: ScreenAdapter.height(50)),
                    initiallyExpanded: this.flag,
                    trailing: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "￥${workOrderPondModel.serviceFee}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(26.0),
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500
                                ))
                          ]
                      ),
                    ),
                    title: Container(
                        alignment: Alignment.topLeft,
                        width: ScreenAdapter.getScreenWidth() * titleWdithRate,//避免超出手机屏幕，所以要给容易一个宽度，超出部分自动隐藏
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}', style: TextStyle(
                              fontSize: ScreenAdapter.size(26),
                              color: Colors.red,
                              fontWeight: FontWeight.w500),maxLines:1,overflow: TextOverflow.ellipsis,),
                        )),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0), 0.0, 0.0, 0.0),
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '用户问题描述：${workOrderPondModel.description}',
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(24.0),
                                            color: Colors.red),
                                      )
                                    ]
                                )
                            )
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          //加载图片的方法
                          _loadWxUserUploadImages(listImages),
                          //加载工单复合未通过原因的方法
                          getCheckfaillReason(workOrderPondModel.checkfaillReason),
                          //工用的工单详情列表
                          universalWorkOrderAttributes(workOrderPondModel,Colors.red),
                          Offstage(
                              offstage: workOrderPondModel.visibleComplete,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenAdapter.width(15.0), ScreenAdapter.height(10.0), ScreenAdapter.width(0.0), ScreenAdapter.height(5.0)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: ScreenAdapter.width(30.0),
                                      child: Transform.rotate(
                                        angle: math.pi / 180,
                                        child: IconButton(
                                          icon: Icon(
                                            IconData(0xe60c,fontFamily: 'AntdIcons'),
                                            size: ScreenAdapter.size(30.0),
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/appendService',arguments: {
                                              "workOrderId":workOrderPondModel.workOrderId,
                                              "orderId":workOrderPondModel.orderId,
                                              "decorationId":userInfo["decorationId"]
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenAdapter.width(20.0),),
                                    TextClickView(
                                      title: "修改服务",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(20),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87
                                      ),
                                      rightClick: (){
                                        Navigator.pushNamed(
                                            context, '/appendService',arguments: {
                                          "workOrderId":workOrderPondModel.workOrderId,
                                          "orderId":workOrderPondModel.orderId,
                                          "decorationId":userInfo["decorationId"]
                                        });
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
                                        context, '/chargeBackApply',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
                                        context, '/comfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId
                                    });
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
                                        context, '/unComfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
      } else if (workOrderPondModel.decorationId != null && workOrderPondModel.orderType == "1") {
        list.add(
          //添加售后工单，字体改为红色
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
                    leading: Image.asset('images/2.0x/shouhou.png',width: ScreenAdapter.width(42),height: ScreenAdapter.height(50)),
                    initiallyExpanded: this.flag,
                    trailing: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "￥${workOrderPondModel.serviceFee}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(26.0),
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500
                                ))
                          ]
                      ),
                    ),
                    title: Container(
                            alignment: Alignment.topLeft,
                            width: ScreenAdapter.getScreenWidth() * titleWdithRate,//避免超出手机屏幕，所以要给容易一个宽度，超出部分自动隐藏
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}', style: TextStyle(
                                  fontSize: ScreenAdapter.size(26),
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),maxLines:1,overflow: TextOverflow.ellipsis,),
                            )),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0), 0.0, 0.0, 0.0),
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '用户问题描述：${workOrderPondModel.description}',
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(24.0),
                                            color: Colors.red),
                                      )
                                    ]
                                )
                            )
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          //加载图片的方法
                          _loadWxUserUploadImages(listImages),
                          //加载工单复合未通过原因的方法
                          getCheckfaillReason(workOrderPondModel.checkfaillReason),
                          //工单类型固有的工单属性列表
                          universalWorkOrderAttributes(workOrderPondModel,Colors.red),
                          Offstage(
                              offstage: workOrderPondModel.visibleComplete,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenAdapter.width(15.0), ScreenAdapter.height(10.0), ScreenAdapter.width(0.0), ScreenAdapter.height(5.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: ScreenAdapter.width(30.0),
                                      child: Transform.rotate(
                                        angle: math.pi / 180,
                                        child: IconButton(
                                          icon: Icon(
                                              IconData(0xe60c,fontFamily: 'AntdIcons'),
                                              size: ScreenAdapter.size(30.0),
                                              color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/appendService',arguments: {
                                              "workOrderId":workOrderPondModel.workOrderId,
                                              "orderId":workOrderPondModel.orderId,
                                              "decorationId":userInfo["decorationId"]
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenAdapter.width(20.0),),
                                    TextClickView(
                                      title: "修改服务",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(20),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87
                                      ),
                                      rightClick: (){
                                        Navigator.pushNamed(
                                            context, '/appendService',arguments: {
                                          "workOrderId":workOrderPondModel.workOrderId,
                                          "orderId":workOrderPondModel.orderId,
                                          "decorationId":userInfo["decorationId"]
                                        });
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
                                        context, '/chargeBackApply',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
                                        context, '/comfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId
                                    });
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
                                        context, '/unComfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
      }else if(workOrderPondModel.decorationId != null && workOrderPondModel.orderType == "0") {
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
                    leading: Image.asset('images/2.0x/xuqiu.png',width: ScreenAdapter.width(42),height: ScreenAdapter.height(50)),
                    initiallyExpanded: this.flag,
                    trailing: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "￥${workOrderPondModel.serviceFee}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(26.0),
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w500
                                ))
                          ]
                      ),
                    ),
                    title: Container(
                            alignment: Alignment.topLeft,
                            width: ScreenAdapter.getScreenWidth() * titleWdithRate,//避免超出手机屏幕，所以要给容易一个宽度，超出部分自动隐藏
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}', style: TextStyle(
                                  fontSize: ScreenAdapter.size(26),
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),maxLines:1,overflow: TextOverflow.ellipsis,),
                            )),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0), 0.0, 0.0, 0.0),
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '用户问题描述：${workOrderPondModel.description}',
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(24.0),
                                            color: Colors.black),
                                      )
                                    ]
                                )
                            )
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          //加载图片的方法
                          _loadWxUserUploadImages(listImages),
                          //加载工单复合未通过原因的方法
                          getCheckfaillReason(workOrderPondModel.checkfaillReason),
                          //加载工单通用内容部分
                          universalWorkOrderAttributes(workOrderPondModel, Colors.black),
                          Offstage(
                              offstage: workOrderPondModel.visibleComplete,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenAdapter.width(15.0), ScreenAdapter.height(10.0), ScreenAdapter.width(0.0), ScreenAdapter.height(5.0)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: ScreenAdapter.width(30.0),
                                      child: Transform.rotate(
                                        angle: math.pi / 180.0,
                                        child: IconButton(
                                          icon: Icon(
                                            IconData(0xe60c,fontFamily: 'AntdIcons'),
                                            size: ScreenAdapter.size(30.0),
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/appendService',arguments: {
                                              "workOrderId":workOrderPondModel.workOrderId,
                                              "orderId":workOrderPondModel.orderId,
                                              "decorationId":userInfo["decorationId"]
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenAdapter.width(20.0),),
                                    TextClickView(
                                      title: "修改服务",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(20),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87
                                      ),
                                      rightClick: (){
                                        Navigator.pushNamed(
                                            context, '/appendService',arguments: {
                                          "workOrderId":workOrderPondModel.workOrderId,
                                          "orderId":workOrderPondModel.orderId,
                                          "decorationId":userInfo["decorationId"]
                                        });
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
                                        context, '/chargeBackApply',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
                                        context, '/comfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId
                                    });
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
                                        context, '/unComfirmService',arguments: {
                                      "workOrderId":workOrderPondModel.workOrderId,
                                      "decorationId":this.userInfo["decorationId"]
                                    });
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
        _getWorkOrderPoneData();
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

  //执行删除后更新操作
  Future _loadDeleteUsWOrderExeu(int orderItemId) async {
    _updateWorkOrderItemInfo(orderItemId).then((response){
      if(response.data['ret']==true){
        if(response.data["data"]==1){
          Fluttertoast.showToast(
            msg: '删除工单信息订单项成功',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          _getWorkOrderPoneData().then((info){

          });
        }else if(response.data["data"]==0){
          Fluttertoast.showToast(
            msg: '此工单可能被客户经理重新操作，请联系客户经理进行确认',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          _getWorkOrderPoneData().then((info){
//            _myRecWorkOrderListWidget();
          });
        }
      }else {
        Fluttertoast.showToast(
          msg: '${response.data["msg"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

  ///师傅确认入户后删除订单项
  _updateWorkOrderItemInfo(int orderItemId) async {
    var api = Config.domain + "/mobile/workOrderService/masterUpdateOrderItemInfo?orderItemId=$orderItemId";
    var response = await Dio().post(api);
    return response;
  }

  //工单复核未通过原因
  Widget getCheckfaillReason(String description){
    if(description != null){
      return Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(28.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
        child: Container(
          alignment: Alignment.topLeft,
          child: Text(
            '工单复核未通过原因:${description}',
            // maxLines: 5,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: Colors.redAccent),
          ),
        ),
      );
    }else{
      return SizedBox();
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
                      controller: _tabController,
                      //设置指示器的颜色
                      indicatorColor: Colors.blue,
                      //设置选中时文字的颜色
                      labelColor: Colors.blue,
                      //设置未选中时文字的颜色
                      unselectedLabelColor: Colors.black,
                      //让指示器大小和tab等宽
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: <Widget>[Tab(text: '工单池'), Tab(text: '我的工单')],
                      onTap: (index){
                        setState(() {
                          this.currentIndex = index;
                          _tabController = TabController(
                              initialIndex: this.currentIndex, length: 2, vsync: this);
                          _tabController.animateTo(this.currentIndex);
                        });
                      },
                    ),
                  )
                ],
              )),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView(
                  children: _recWorkOrderListWidget()
              ),
              ListView(
                  children: _myRecWorkOrderListWidget()
              ),
            ],
          )
    ));
  }



  void onPageChanged(int index) {

  }

  /*我的订单中通用的订单详情列表*/
  Widget universalWorkOrderAttributes(WorkOrderPondModel workOrderPondModel,Color definitionColor) {
      return Column(
        children: <Widget>[
          //录入工单详细信息 START   代码后续可以提取成方法
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: SelectableText('新工作流工单流水号：${workOrderPondModel.newWfJobNumber}',
                  style: TextStyle(
                      fontSize: ScreenAdapter.size(24.0),
                      color: definitionColor),
                  textAlign: TextAlign.right),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: SelectableText('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}',
                  style: TextStyle(
                      fontSize: ScreenAdapter.size(24.0),
                      fontWeight: FontWeight.w500,
                      color: definitionColor),
                  textAlign: TextAlign.right),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0), ScreenAdapter.height(0.0), ScreenAdapter.width(16.0), ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: SelectableText('客户姓名：${workOrderPondModel.username}',
                  style: TextStyle(
                      fontSize: ScreenAdapter.size(24.0),
                      color: definitionColor),
                  textAlign: TextAlign.right),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0),
                ScreenAdapter.height(0.0),
                ScreenAdapter.width(16.0),
                ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: SelectableText('联系方式：${workOrderPondModel.telphone}',
                style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor),),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0),
                ScreenAdapter.height(0.0),
                ScreenAdapter.width(16.0),
                ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: SelectableText('客户区域：${workOrderPondModel.areaName}',
                style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor),),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0),
                ScreenAdapter.height(1.0),
                ScreenAdapter.width(16.0),
                ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Container(
                    child: SelectableText(
                      '客户地址：${workOrderPondModel.detailAddress}',
                      style: TextStyle(color: definitionColor,fontSize: ScreenAdapter.size(24.0)),
                      scrollPhysics: ClampingScrollPhysics(),
                    )),
                onLongPress: () {

                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(28.0),
                ScreenAdapter.height(1.0),
                ScreenAdapter.width(16.0),
                ScreenAdapter.height(4.0)),
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Container(
                    child: SelectableText(
                      '上门时间：${formatDate(DateTime.parse(workOrderPondModel.appointUpTime),[yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(color: definitionColor,fontSize: ScreenAdapter.size(24.0)),
                      scrollPhysics: ClampingScrollPhysics(),
                    )),
                onLongPress: () {

                },
              ),
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
                child: SelectableText('服务内容：${workOrderPondModel.serviceName}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
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
                child: SelectableText('服务费用：${workOrderPondModel.serviceFee}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
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
                child: SelectableText('ITV帐号：${workOrderPondModel.itvAccount ?? ""}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
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
                child: SelectableText('SN号码：${workOrderPondModel.snNumber ?? ""}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
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
                child: SelectableText('宽带带宽：${workOrderPondModel.broadbandWidth ?? ""}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
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
                child: SelectableText('派单工号：${workOrderPondModel.assignAccount ?? ""}',
                    style: TextStyle(fontSize: ScreenAdapter.size(24.0),color: definitionColor))
            ),
          ),
          //录入工单详细信息 END   代码后续可以提取成方法
        ],
      );
  }

  /*加载微信端小程序上传的图片*/
  Widget _loadWxUserUploadImages(List<String> listImages) {
      if(listImages.length > 0 ) {
        return Container(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(52), ScreenAdapter.width(26), ScreenAdapter.width(52), ScreenAdapter.width(26)),
          child: GridView.builder(
            shrinkWrap: true, //解决 listview 嵌套报错
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴元素个数
                crossAxisCount: 2,
                //纵轴间距
                mainAxisSpacing: ScreenAdapter.width(18),
                //横轴间距
                crossAxisSpacing: ScreenAdapter.height(18),
                //子组件宽高长度比例
                childAspectRatio: 1),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  //点击图片的时候跳转道图片放大页面
                  Navigator.pushNamed(context,"/photoGallery",arguments: {
                    "index": index,
                    "galleryItems": listImages
                  });
                },
                child: Image.network(
                  listImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
            itemCount: listImages.length,
          ),
        );
      } else {
        return Container(
          child: Text(""),
        );
      }
  }

  @override
  bool get wantKeepAlive => true;
}