
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/pages/tabs/Service.dart';
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

  //设置

  static var serviceContentController = new TextEditingController();
  static var serviceFeeController = new TextEditingController();
  static var deviceFeeController = new TextEditingController();
  static var materialFeeController = new TextEditingController();

  static var numsController = new TextEditingController(text: "1");

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

  Widget _leftBtn(int number, int index, dynamic value) {
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
        decoration: BoxDecoration(
            border: Border.all(
                width: ScreenAdapter.width(2),
                color: value['lineColor'] == null ? Colors.black12 : value['lineColor']
            )
        ),
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
  Widget _rightBtn(int number, int index, dynamic value) {
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
        decoration: BoxDecoration(
            border: Border.all(
                width: ScreenAdapter.width(2),
                color: value['lineColor'] == null ? Colors.black12 : value['lineColor']
            )
        ),
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
  Widget _centerArea(int number, int index, dynamic value) {
    return InkWell(
      onTap: (){
        changeServiceNumsOptions(context,index);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(70),
        decoration: BoxDecoration(
            border: Border.all(
                width: ScreenAdapter.width(2),
                color: value['lineColor'] == null ? Colors.black12 : value['lineColor']
            )
        ),
        height: ScreenAdapter.height(45),
        child: Text(
          value["identifyType"] == '1' ? '1' : "$number",
          style: TextStyle(
              color: this.serviceList[index]['textColor'] == null ? Colors.black87 : this.serviceList[index]['textColor']
          ),
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

  ///修改服务项方法  接收师傅输入数量和产品编号
  appendServiceItem() async{
    List<Map<String,dynamic>> selectServiceList = new List();
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
      }
    }).toList();
    print("选中的数据为: $selectServiceList");
    if(selectServiceList.length == 0){
      Fluttertoast.showToast(
        msg: '请选中要修改的服务并输入相应的数量！',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    var api = Config.domain + "/mobile/workOrderService/updateAppendServiceItem";
    var response = await Dio().post(api,data: {"selectServiceList" : selectServiceList});
    if(response.data['ret']==true){
      if(response.data['data'] == true) {
        //跳转会到之前点击修改按钮的服务界面
//        Navigator.of(context).pop();    //可以回到上一页，不会重新加载数据
//        Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage())).then((value) => null); //可以回到指定页面，也会加载数据，也不会出现回退按钮，但是之前的路有栈没清空，展示也没有tab了
//        Navigator.push(context, new MaterialPageRoute(
//            builder: (context) =>
//            new Tabs(index: 0)
//        )).then((value) => null);
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


  ///判断这个商品自定义价格类型是否为师傅自定义
  dynamic _judgeIdentifyType(String identifyType,double serviceFee,bool isVisit,int index,dynamic value) {
    Widget widget;
    if(identifyType == "0") {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text('￥${serviceFee}', style: TextStyle(fontSize: ScreenAdapter.size(26),
            color: Color.fromRGBO(255, 204, 51, 1),
            fontWeight: FontWeight.w500)
        ),
      );
    }else if(identifyType == "1") {
      return isVisit ? Offstage(
        offstage: !isVisit,
        child: Container(
          alignment: Alignment.centerRight,
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
              alignment: Alignment.center,
              child: TextClickView(
                title: '${this._inputPrice}',
                color: Color.fromRGBO(90, 204, 51, 1),
                style: TextStyle(
                    fontSize: ScreenAdapter.size(42),
                    color: Color.fromRGBO(255, 204, 51, 1),
                    fontWeight: FontWeight.w500
                ),
                rightClick: (){
                  callInputOptions(context,index, value);
                },
              ),
            )
      );
    }
      return widget;
  }

  /*自定义某种商品数量*/
  changeServiceNumsOptions(BuildContext context,int index) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
            builder: (context, AsyncSnapshot snapshot){
              return CupertinoAlertDialog(
                title: Text('输入所选服务数量',  style: new TextStyle(
                    color: Colors.blue, fontSize: ScreenAdapter.size(28.0),fontWeight: FontWeight.w500)),
                content: Card(
                  elevation: 0.0,
                  color: Color.fromRGBO(240, 240, 240, 0.1),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: numsController,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1,color: Color.fromRGBO(250, 131, 106, 1),style: BorderStyle.solid)
                          )
                        )
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: new FlatButton(
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        onPressed: () {
                          print("取消");
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
                            child: GestureDetector(
                              child: Text(
                                '取消',
                                style: new TextStyle(
                                    color: Colors.blue, fontSize: ScreenAdapter.size(28.0),fontWeight: FontWeight.w500),
                              ),
                              onTap: (){
                                setState(() {
                                  numsController.clear();
                                });
                                Navigator.pop(context);
                                print("取消");
                              },
                            )
                        ),
                      )
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
                                  setState(() {
                                      if(numsController.text == null) {
                                        numsController.text = "1";
                                      }
                                      this.serviceList[index]['number'] = int.parse(numsController.text);
                                      numsController.text = "1";
                                      Navigator.pop(context);
                                  });
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


   /*自定义价格商品录入*/
   callInputOptions(BuildContext context,int index, dynamic value) async {
     await showCupertinoDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
            builder: (context, AsyncSnapshot snapshot){
              return CupertinoAlertDialog(
                title: Text('输入以下内容',  style: new TextStyle(
                    color: Colors.blue, fontSize: ScreenAdapter.size(28.0),fontWeight: FontWeight.w500)),
                content: Card(
                  color: Colors.white30,
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      TextField(
//                        maxLines: 2,
                        controller: serviceContentController,
                        decoration: InputDecoration(
                          hintText: '请输入服务内容',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 39, 78, 1),width: 1,style: BorderStyle.solid))
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(10)),
                      TextField(
                        controller: serviceFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入服务费金额",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 39, 78, 1),width: 1,style: BorderStyle.solid))
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(10)),
                      TextField(
                        controller: deviceFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入设备费金额",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 39, 78, 1),width: 1,style: BorderStyle.solid))
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(10)),
                      TextField(
                        controller: materialFeeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                        decoration: new InputDecoration(
                            labelText: "请输入材料费金额",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 39, 78, 1),width: 1,style: BorderStyle.solid))
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: new FlatButton(
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        onPressed: () {
                          print("取消");
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: ScreenAdapter.height(0)),
                            child: GestureDetector(
                              child: Text(
                                '取消',
                                style: new TextStyle(
                                    color: Colors.blue, fontSize: ScreenAdapter.size(28.0),fontWeight: FontWeight.w500),
                              ),
                              onTap: (){
                                setState(() {
                                  serviceContentController.clear();
                                  serviceFeeController.clear();
                                  deviceFeeController.clear();
                                  materialFeeController.clear();
                                });
                                Navigator.pop(context);
                                print("取消");
                              },
                            )
                        ),
                      )
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
                                //点击确定的时候跳转到一个新的页面
                                Navigator.pushNamed(context,"/showSelfService",arguments: {
                                  "serviceContent": this.serviceContent,
                                  "serviceFee": this.serviceFee,
                                  "deviceFee": this.deviceFee,
                                  "materialFee": this.materialFee,
                                  "orderId": widget.arguments['orderId'],
                                  "productId": value["productId"],
                                  "decorationId": widget.arguments['decorationId']
                                });
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
                  border: Border.all(width: 1, color: Colors.grey)
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(16.0)),
                  child: Container(
                    height: ScreenAdapter.height(88),
                    //使用三列布局,避免不在一行显示问题
                    child: Row(
                      children: <Widget>[
                        //第一列复选框
                        Container(
                          width: ScreenAdapter.width(80.0),
                          height: ScreenAdapter.height(80.0),
                          alignment: Alignment.centerLeft,
                          child: Checkbox(
                            value: this.serviceList[index]['flag'],
                            activeColor: Colors.blue,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (bool val) {
                              setState(() {
                                this.serviceList[index]['flag'] = !this.serviceList[index]['flag'];
                              });
                            },
                          ),
                        ),

                        //第二列，服务名称和服务价格
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,    //表示上下居中
//                            crossAxisAlignment: CrossAxisAlignment.start,   //表示左右居中
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: ScreenAdapter.width(0.0),right: ScreenAdapter.width(1.0)),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "${value["serviceName"]}",
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(23.0),
                                            color: value['backgroundColor'] == null ? Colors.black87 : value['textColor']
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child:  Padding(
                                  padding: EdgeInsets.only(right: ScreenAdapter.width(16.0),left: ScreenAdapter.width(1.0)),
                                  child: _judgeIdentifyType(value["identifyType"], value["serviceFee"], value["identifyFlag"],index,value),
                                ),
                              )

                            ],
                          ),
                        ),

                        //第三列   显示加减服务的按钮
                        _leftBtn(value['number'],index,value),
                        _centerArea(value['number'],index,value),
                        _rightBtn(value['number'],index,value),
                        SizedBox(width: ScreenAdapter.width(20.0),)

                      ],
                    )
                  ),
                  //设置点击事件回调
                  onTap: () {
                    if(value['flag']==false){
                      setState(() {
                        this.serviceList[index]['flag'] = true;
//                        this.serviceList[index]['backgroundColor'] = Colors.blue;
//                        this.serviceList[index]['textColor'] = Colors.white;
//                        this.serviceList[index]['lineColor'] = Colors.white70;
                      });
                    }else{
                      setState(() {
                        this.serviceList[index]['flag'] = false;
//                        this.serviceList[index]['backgroundColor'] = Color.fromRGBO(255, 255, 255, 1);
//                        this.serviceList[index]['textColor'] = Colors.black87;
//                        this.serviceList[index]['lineColor'] = Colors.black12;
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
              child: Text('修改服务'),
              color: Colors.lightBlue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(32))),
              onPressed: () {
                print("点击修改服务按钮$serviceFee");
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
        title: Text('修改服务'),
      ),
      body: ListView(
        children: getWidgetServiceInfo(),
      )
    );
  }
}
