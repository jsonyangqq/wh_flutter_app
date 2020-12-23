import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

class ReceiptPage extends StatefulWidget {
  Map arguments;

  ReceiptPage({Key key, this.arguments}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool hiddenInputOpt = true;   //如果下拉框选中为个人，则隐藏最后面二个输入框
  bool visibleInputOpt = false;  //如果下拉框选中为企业，则显示最后面二个输入框
  int workOrderId;
  String dropdownValue = "个人";
  String dropdownIndexValue  = "0";
  String email = "";
  String company = "";
  String paytaxes = "";


  @override
  void initState() {
    super.initState();
    this.workOrderId = widget.arguments['workOrderId'];
  }

  _submitReceiptInfo() async {
      //判断邮箱不能为空
      if(this.email == null || this.email == "") {
        Fluttertoast.showToast(
          msg: '邮箱信息不能为空',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }
      RegExp exp = RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$');
      if(!exp.hasMatch(email)) {
        Fluttertoast.showToast(
          msg: '邮箱格式输入有误',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }
      if(dropdownValue.contains("企业")) {
        if(this.company == null || this.company == "") {
          Fluttertoast.showToast(
            msg: '公司名称不能为空',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          return;
        }
        if(this.paytaxes == null || this.paytaxes == "") {
          Fluttertoast.showToast(
            msg: '公司纳税人编号不能为空',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          return;
        }
      }
      if(dropdownValue == "企业") {
        dropdownIndexValue = "1";
      }
      //提交表单信息
      var api = Config.domain + "/wechat/wxOrderView/incoicApply?receiptType=${dropdownIndexValue}&workOrderId=$workOrderId&email=${email}&company=${company}&paytaxes=${paytaxes}";
      var response = await Dio().post(api);
      if(response.data['ret']==true){
        Fluttertoast.showToast(
          msg: '提单发票申请成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        //跳转到上一个页面
        Navigator.pop(context);
      }else {
        Fluttertoast.showToast(
          msg: '${response.data["msg"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }


  }


  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('申请发票'),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenAdapter.width(20.0),
                    top: ScreenAdapter.height(16.0),
                    bottom: ScreenAdapter.height(8.0),
                    right: ScreenAdapter.width(20)),
                child: Text(
                  '请填写一下发票信息',
                  style: TextStyle(fontSize: ScreenAdapter.size(32)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenAdapter.width(16)),
                child: Wrap(
                  spacing: ScreenAdapter.width(60.0),
                  runSpacing: ScreenAdapter.height(10),
                  alignment: WrapAlignment.spaceEvenly,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenAdapter.width(16.0),
                    top: ScreenAdapter.height(16.0),
                    bottom: ScreenAdapter.height(8.0),
                    right: ScreenAdapter.width(16)),
                child: Container(
                  width: ScreenAdapter.getScreenWidth(),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: ScreenAdapter.width(1), color: Colors.grey),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdapter.width(32))),
                  ),
                  child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down,size: ScreenAdapter.size(30)),
                      iconSize: ScreenAdapter.size(24),
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.white12,
                      ),
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          this.hiddenInputOpt = !hiddenInputOpt;
                          this.visibleInputOpt = !visibleInputOpt;
                        });
                      },
                      items: <String>['个人', '企业']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(left: ScreenAdapter.width(20),right: ScreenAdapter.width(600)),
                            child: Text(value),
                          )
                        );
                      }).toList()),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8),
                    ScreenAdapter.width(16),
                    ScreenAdapter.height(8)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "请填写接收发票的邮箱",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(242, 242, 242, 1),
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    this.email = text;
                  },
                  onSubmitted: (text) {
                    this.email = text;
                  },
                ),
              ),
            Offstage(
                offstage: hiddenInputOpt,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(16),
                      ScreenAdapter.height(8),
                      ScreenAdapter.width(16),
                      ScreenAdapter.height(8)),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "请填写公司名称",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1),
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      this.company = text;
                    },
                    onSubmitted: (text) {
                      this.company = text;
                    },
                  ),
                ),
              ),
            Offstage(
                offstage: hiddenInputOpt,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(16),
                      ScreenAdapter.height(8),
                      ScreenAdapter.width(16),
                      ScreenAdapter.height(8)),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "请填写公司纳税人编号",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1),
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      this.paytaxes = text;
                    },
                    onSubmitted: (text) {
                      this.paytaxes = text;
                    },
                  ),
                ),
              ),
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
                          child: Text(
                            '提交申请',
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(30),
                                fontWeight: FontWeight.w500),
                          ),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenAdapter.width(32))),
                          onPressed: () {
                            print("提交申请");
                            _submitReceiptInfo();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
