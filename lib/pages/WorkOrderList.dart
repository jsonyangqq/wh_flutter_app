/*工单列表页面*/

import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/model/ThisMonthWorkOrderModel.dart';
import 'package:wh_flutter_app/utils/Storage.dart';

class WorkOrderListPage extends StatefulWidget {
  @override
  _WorkOrderListPageState createState() => _WorkOrderListPageState();
}

class _WorkOrderListPageState extends State<WorkOrderListPage> {

  bool flag = true;
 String serviceName = "服务名称";
  Map<String,dynamic> userInfo = Map();
  List<dynamic> _thisMonthWorkOrderDataList = new List<dynamic>();
 
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
    var api = Config.domain + "/mobile/workOrderService/getThisMonthWorkOrderPoneData?decorationId=$decorationId";
    var response = await Dio().post(api);
    if(response.data['ret']==true){
      print(response.data);
      setState(() {
        this._thisMonthWorkOrderDataList = response.data["data"];
      });
    }
  }


  Widget getCheckfaillReason(String description){
    if(description != null){
          return Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                          '工单复核未通过原因:${description}',
                          // maxLines: 5,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                        ),
                        ),
                      );
    }else{
      return widget;
    }
    
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

List<Widget> _recWorkOrderListWidget(type) {
    List<Widget> list = new List<Widget>();
    this._thisMonthWorkOrderDataList.map((value){
     ThisMonthWorkOrderModel thisMonthWorkOrderModel = ThisMonthWorkOrderModel.fromJson(value);
       if((thisMonthWorkOrderModel.haddone == 1 && type == 1) || (thisMonthWorkOrderModel.haddone == 0 && type == 2)){
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
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: this.flag,
                    trailing:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('订单状态',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                        Text('${thisMonthWorkOrderModel.isComplete}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                      ],
                    ),
                    title: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('工单号',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                            Text('${thisMonthWorkOrderModel.wxJobNumber}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                          ],
                        ),
                        SizedBox(width: ScreenAdapter.width(20.0)),
                        Column(
                          children: <Widget>[
                            Text('上门时间',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                            Text('${formatDate(DateTime.parse(thisMonthWorkOrderModel.appointUpTime),[yyyy, '-', mm, '-', dd])}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                          ],
                        ),
                        SizedBox(width: ScreenAdapter.width(20.0)),
                        Column(
                          children: <Widget>[
                            Text('派单人',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                            Text('${thisMonthWorkOrderModel.creater}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                          ],
                        ),
                        SizedBox(width: ScreenAdapter.width(30.0)),
                        Column(
                          children: <Widget>[
                            Text('服务内容',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                            Text('${thisMonthWorkOrderModel.serviceFor}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: <Widget>[
                                Text('服务金额',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                Text('${thisMonthWorkOrderModel.serviceMoney}',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    children: <Widget>[
                     getCheckfaillReason(thisMonthWorkOrderModel.checkfaillReason),
                       Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenAdapter.width(24.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                          '${thisMonthWorkOrderModel.description}',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                        ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(16)),
                            child: Wrap(
                              spacing: ScreenAdapter.width(46.0),
                                children: _getImageUrlShow(thisMonthWorkOrderModel.imageUrl)
                            ),
                          ),
                        ],
                      ),
                    ],
                    onExpansionChanged: (value){
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

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('工单列表'),
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
                  children:_recWorkOrderListWidget(1),
                ),
                ListView(
                  children: _recWorkOrderListWidget(2),
                )
              ],
            )),
      ),
    );
  }
}
