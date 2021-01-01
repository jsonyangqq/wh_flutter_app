import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

import 'Tabs.dart';

/*展示自定义服务输入内容详情*/
class ShowSelfServicePage extends StatefulWidget {

  Map arguments;
  ShowSelfServicePage({Key key, this.arguments}) : super(key: key);

  @override
  _ShowSelfServicePageState createState() => _ShowSelfServicePageState();
}

class _ShowSelfServicePageState extends State<ShowSelfServicePage> {

  String serviceContent;
  double serviceFee;
  double deviceFee;
  double materialFee;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.serviceContent = widget.arguments["serviceContent"];
    this.serviceFee = widget.arguments["serviceFee"];
    this.deviceFee = widget.arguments["deviceFee"];
    this.materialFee = widget.arguments["materialFee"];
  }

  appendServiceItem() async{
    List<Map<String,dynamic>> selectServiceList = new List();
    Map<String, dynamic> map = new Map();
    map["identifyType"] = '1';
    map["productId"] = widget.arguments['productId'];
    map["serviceFee"] = this.serviceFee;
    map["number"] = 1;
    map["orderId"] = widget.arguments["orderId"];
    map["decorationId"] = widget.arguments["decorationId"];
    map["serviceContent"] = this.serviceContent;
    map["deviceFee"] = this.deviceFee;
    map["materialFee"] = this.materialFee;
    map["totalMoney"] = this.serviceFee + this.deviceFee + this.materialFee;
    selectServiceList.add(map);
    var api = Config.domain + "/mobile/workOrderService/updateAppendServiceItem";
    var response = await Dio().post(api,data: {"selectServiceList" : selectServiceList});
    if(response.data['ret']==true){
      if(response.data['data'] == true) {
        Navigator.pushAndRemoveUntil(context,  //可以回到指定页面，会把之前的从A～C之间所有的路有历史都清空，数据也会加载，tab也还会保留
            new MaterialPageRoute(
              builder: (BuildContext context) {
                return new Tabs(index: 0,serviceHomeIndex: 1);
              },
            ), (route) => route == null);

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

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('个性化服务内容'),
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                //第一行展示服务内容
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Text(
                      '服务内容：${serviceContent}',
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(36)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Text(
                        '服务费：${serviceFee}',
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(36)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Text(
                        '设备费：${deviceFee}',
                      style: TextStyle(
                        fontSize: ScreenAdapter.size(36)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Text(
                        '材料费：${materialFee}',
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(36)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenAdapter.height(200.0)),
                Padding(
                  padding: EdgeInsets.only(left: ScreenAdapter.width(200),right: ScreenAdapter.width(200),top: ScreenAdapter.height(68.0),bottom: ScreenAdapter.height(32)),
                  child: RaisedButton(
                    child: Container(
                      width: ScreenAdapter.width(200),
                      child: Text('修改服务',textAlign: TextAlign.center,)
                    ),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenAdapter.width(30.0))),
                    onPressed: () {
                      print("点击修改服务按钮$serviceFee");
                      appendServiceItem();
                    },
                  ),
                )

              ],
            ),
        )
    );

  }
}
