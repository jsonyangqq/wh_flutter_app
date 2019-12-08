
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

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

  List<dynamic> serviceList = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    this.workOrderId = widget.arguments['workOrderId'];
    this.orderId = widget.arguments['orderId'];
    this.decorationId = widget.arguments['decorationId'];
    _getListData();
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
    //1.先获取追加服务中选中的值
    this.serviceList.map((value){
      Map<String,dynamic> map = new Map();
      if(value['flag'] == true){
        map["productId"] = value['productId'];
        map["serviceFee"] = value['serviceFee'];
        map["number"] = value['number'];
        map["orderId"] = this.orderId;
        map["decorationId"] = this.decorationId;
        selectServiceList.add(map);
      }
    }).toList();
    print("选中的数据为: $selectServiceList");
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
                                  fontSize: ScreenAdapter.size(22.0),
                                  color: value['backgroundColor'] == null ? Colors.black87 : value['textColor']
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: ScreenAdapter.width(16.0),left: ScreenAdapter.width(1.0)),
                            child: Container(
                              alignment: Alignment.centerRight,
                              height: ScreenAdapter.height(88),
                              child: Text('￥${value["serviceFee"]}', style: TextStyle(fontSize: ScreenAdapter.size(30),
                                  color: Color.fromRGBO(255, 204, 51, 1),
                                  fontWeight: FontWeight.w500)
                              ),
                            ),
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
                print("点击追加服务按钮");
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
