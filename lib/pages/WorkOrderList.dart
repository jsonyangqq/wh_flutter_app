/*工单列表页面*/

import 'package:flutter/material.dart';
import 'package:wh_flutter_app/model/WorkOrderPoneModel.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/Storage.dart';

class WorkOrderListPage extends StatefulWidget {

 Map arguments;


 WorkOrderListPage({Key key, this.arguments}) : super(key: key);

  @override
  _WorkOrderListPageState createState() => _WorkOrderListPageState();
}

class _WorkOrderListPageState extends State<WorkOrderListPage> {

  String startDate;
  String endDate;
  bool flag = true;
  String serviceName = "服务名称";
  Map<String,dynamic> userInfo = Map();
  List<dynamic> _workOrderPondDataList = new List<dynamic>();
  //服务名称标题容器占比  占手机总屏幕得55%
  double titleWdithRate = 0.55;
  //工单池显示 服务名称标题容器占比  占手机总屏幕得71%
  double workOrderTitleWdithRate = 0.71;

  /*展示师傅已经完工的工单状态*/
  final List<String> completeWorkOrderStateList = [ "4", "5", "77" ];

  /*展示师傅未完工的工单状态*/
  final List<String> unCompleteWorkOrderStateList = [ "2", "3", "18", "28", "38", "66", "48" ];

  static final Map<String,String> workOrderStatusMaps = {
    "2" : "待接单",
    "2" : "已接单",
    "4" : "已上门",
    "5" : "已完工",
    "18" : "未完工",
    "28" : "未受理",
    "38" : "已取消",
    "66" : "处理中",
    "77" : "处理完成",
    "48" : "用户申请退单",
  };

 @override
  void initState() {
    startDate = widget.arguments!=null ? widget.arguments['startDate'] : '';
    endDate = widget.arguments!=null ? widget.arguments['endDate'] : '';
    super.initState();
    _loadPowerExeu();
  }


  @override
  void deactivate() {
    print('打印了这个deactivate');
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

  ///获取师傅师傅工单列表数据
  _getWorkOrderPoneData() async {
    int decorationId = this.userInfo["decorationId"];
    var api = Config.domain + "/mobile/workOrderService/getThisMonthWorkOrderPoneData?decorationId=$decorationId&startDate=${startDate}&endDate=${endDate}";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      print(response.data);
      setState(() {
        this._workOrderPondDataList = response.data["data"];
      });
    }
  }


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

  /*针对已完成和已完工的出现申请发票按钮*/
  Widget getApplyIncoicBtn(String isComplete, int workOrderId) {
    if("已完成".contains(isComplete)  || "已完工".contains(isComplete)) {
      return RaisedButton(
        child: Text('申请发票'),
        color: Colors.lightBlue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenAdapter.size(32.0))),
        onPressed: () {
          print("跳转到申请发票页面");
          Navigator.pushNamed(
              context, '/receipt',arguments: {
            "workOrderId":workOrderId
          });
        },
      );
    }else {
      return SizedBox(width: 1,height: 1,);
    }
  }




  /*加载工单列表“已完工和未完工的工单”*/
  List<Widget> _recWorkOrderListWidget(List<String> workOrderStatusList) {
    List<Widget> list = new List();
    this._workOrderPondDataList.asMap().forEach((index,value) {
      WorkOrderPondModel workOrderPondModel = WorkOrderPondModel.fromJson(value);
      var imageUrls = workOrderPondModel.imageUrl;
      List<String> listImages = (imageUrls==null || imageUrls == "") ?  new List<String>() : imageUrls.substring(0,imageUrls.lastIndexOf(";")).split(";");
      //未完工的东西已完工中都存在
      if(workOrderPondModel.decorationId != null && workOrderStatusList.contains(workOrderPondModel.isComplete)) {
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
                                text: workOrderStatusMaps.putIfAbsent('${workOrderPondModel.isComplete}', () => "未知状态"),
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(26.0),
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w500
                                ))
                          ]
                      ),
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            width: ScreenAdapter.getScreenWidth() * titleWdithRate,//避免超出手机屏幕，所以要给容易一个宽度，超出部分自动隐藏
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('客户序号：${workOrderPondModel.newWfJobNumber.substring(4,8)}${workOrderPondModel.newWfJobNumber.substring(workOrderPondModel.newWfJobNumber.length-4)}', style: TextStyle(
                                  fontSize: ScreenAdapter.size(26),
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),maxLines:1,overflow: TextOverflow.ellipsis,),
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
                          //是否加载发票按钮
                          isLoadApplyIncoicBtn(completeWorkOrderStateList.contains(workOrderPondModel.isComplete),workOrderPondModel.workOrderId)
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
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.topLeft,
                    child: Text('工单列表')
                ),
              )
              ,
              Expanded(
                flex: 1,
                child:  Container(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Image.asset(
                        "images/2.0x/Date_range_picker.png",
                        width: ScreenAdapter.width(60.0),
                        height: ScreenAdapter.height(60.0),
                        color: Color.fromRGBO(249, 252, 255, 1),
                      ),
                      onTap: () {
                        print('日历点击事件');
                        //跳转到选择日期时间端相关页面
                        Navigator.pushNamed(context, "/datePickerRange");
                      },
                    )
                ),
              ),
            ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false, //去掉头部返回按钮
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
                        tabs: <Widget>[Tab(text: '已完工'), Tab(text: '未完工')],
                      ),
                    )
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                ListView(
                  children:_recWorkOrderListWidget(completeWorkOrderStateList),
                ),
                ListView(
                  children: _recWorkOrderListWidget(unCompleteWorkOrderStateList),
                )
              ],
            )),
      ),
    );
  }


  /**
   * 是否加载发票按钮
   */
  Widget isLoadApplyIncoicBtn(bool flagBtn, int workOrderId) {
    if(flagBtn) {
      return RaisedButton(
        child: Text('申请发票'),
        color: Colors.lightBlue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenAdapter.size(32.0))),
        onPressed: () {
          print("跳转到申请发票页面");
          Navigator.pushNamed(
              context, '/receipt',arguments: {
            "workOrderId":workOrderId
          });
        },
      );
    }else {
      return SizedBox(width: 1,height: 1);
    }
  }


}