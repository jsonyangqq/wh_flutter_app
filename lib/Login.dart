import 'package:flutter/material.dart';

import 'utils/ScreenAdapter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _result = "无";
  bool _falg=true;

  @override
  void initState() {
    super.initState();
    fluwx.responseFromAuth.listen((data) {
      setState(() {
        _result = "${data.errCode}";
        String code = data.code;
        print('code  $code');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _result = null;
  }


  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('登录页面'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: ScreenAdapter.height(120)),
            Image.asset(
              "images/dianxin.png",
               width: ScreenAdapter.width(400),
               height: ScreenAdapter.height(400),
               fit: BoxFit.fill,
            ),
            SizedBox(height: ScreenAdapter.height(140)),
            Container(
              width: ScreenAdapter.width(560),
              child: RaisedButton(
                child: Text('微信授权快捷登录'),
                color: Colors.lightBlue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  fluwx
                      .sendWeChatAuth(
                      scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
                      .then((data) {
                          setState(() {
                            this._falg = data;
                          });
                       });
                },
              )
            ),
            SizedBox(height: ScreenAdapter.height(36)),
            Text('温馨提示：未注册的用户，初次登陆时将完成注册'),
            Text("响应结果;"),
            Text(_result),
            Text('${_falg}')
          ],
        ),
      ),
    );
  }
}
