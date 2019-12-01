import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'config/Config.dart';
import 'pages/Tabs.dart';
import 'services/EventBus.dart';
import 'utils/ScreenAdapter.dart';
import 'utils/Storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _staffno='';
  String password='';

  doLogin() async{
    var api ='${Config.domain}/mobile/mobileLogin/doLogin';
    var response =await Dio().post(api, data: {"staffno" : this._staffno, "password" : this.password});
    if(response.data["ret"] == true){
      print(response.data);
      //保存用户信息
      Storage.setString("userInfo", response.data["data"]);
      Navigator.of(
          context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => Tabs()), (route) => route == null
      );
    }else{
      Fluttertoast.showToast(
        msg: '${response.data["msg"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  //监听登录页面销毁的事件
  dispose(){
    super.dispose();
    eventBus.fire(UserEvent('登录成功...'));
  }

  @override
  void initState() {
    super.initState();
  }
  var usernameController = new TextEditingController();
  var userPwdController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: ScreenAdapter.height(120)),
            Image.asset(
              "images/dianxin.png",
               width: ScreenAdapter.width(180),
               height: ScreenAdapter.height(180),
               fit: BoxFit.fill,
            ),
            SizedBox(height: ScreenAdapter.height(80)),
            Padding(
              padding: EdgeInsets.all(10.0),
              //用户名输入框
              child: TextField(
                //控制器
                controller: usernameController,
                maxLength: 11,
                maxLines: 1,
                //是否自动更正
                autocorrect: true,
                //是否自动对焦
                //autofocus: true,
                decoration: new InputDecoration(
                  labelText: "请输入工号",
                  helperText: "工号",
                  icon: new Icon(Icons.account_box),
                ),
                onChanged: (text) {
                  this._staffno = text;
                  //内容改变的回调
                  print('change $text');
                },
                onSubmitted: (text) {
                  this._staffno = text;
                  //内容提交(按回车)的回调
                  print('submit $text');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              //密码输入框
              child: TextField(
                controller: userPwdController,
                //输入密码格式限制
                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9_]"))],
                maxLength: 18,
                maxLines: 1,
                //是否自动更正
                autocorrect: true,
                //是否自动对焦
                //autofocus: true,
                decoration: new InputDecoration(
                  hintText: "请输入密码",
                  labelText: "请输入密码",
                  helperText: "密码",
                  icon: new Icon(Icons.account_box),
                ),
                obscureText: true,
                onChanged: (text) {
                  this.password = text;
                  print('change $text');
                },
                onSubmitted: (text) {
                  this.password = text;
                  //内容提交(按回车)的回调
                  print('submit $text');
                },
              ),
            ),
            Container(
              //这里写800已经超出屏幕了，可以理解为match_parent
              width: ScreenAdapter.width(800.0),
              margin: EdgeInsets.all(ScreenAdapter.width(10.0)),
              padding: EdgeInsets.all(ScreenAdapter.width(10.0)),
              //类似cardview
              child: new Card(
                color: Colors.blueAccent,
                elevation: ScreenAdapter.size(5.0),
                //按钮
                child: new FlatButton(
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    onPressed: () {
                      if (usernameController.text.isEmpty) {
                        //第三方的插件Toast，https://pub.dartlang.org/packages/fluttertoast
                        Fluttertoast.showToast(
                            msg: "工号不能为空哦",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white);
                      } else if (userPwdController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "密码不能为空哦",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white);
                      } else {
                        //请求登录接口操作
                        doLogin();
                      }
                    },
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text(
                        '登录',
                        style: new TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
