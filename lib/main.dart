import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/Routes.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'utils/Storage.dart';

//void main() => runApp(MyApp());

main() async{
  runApp(MyApp());
}


class MyApp extends StatefulWidget  {

  @override
  _MyAppState createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp> {

  var loginState;


  Map<String,dynamic> userInfo = Map();

  @override
  void initState() {
    super.initState();
    _loadPowerExeu();
  }

  Future _loadPowerExeu() async{
    _getUserInfoData().then((info){
      _validateLogin().then((info) {
        initPlatformState();
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

  //验证是否登录
  Future _validateLogin() async{
    Future<dynamic> future = Future(()async{
      return Storage.getString("userInfo");
    });
    future.then((val){
      if(val == null){
        setState(() {
          loginState = 0;
        });
      }else{
        setState(() {
          loginState = 1;
        });
      }
    }).catchError((_){
      print("catchError");
    });

  }


  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    if(loginState == 0){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale('zh', 'CH'),
        initialRoute: '/login',
        onGenerateRoute: onGenerateRoute,
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      );
    }else{
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color.fromRGBO(46, 153, 240, 1)),
        locale: Locale('zh', 'CH'),
        initialRoute: '/tab',
        onGenerateRoute: onGenerateRoute,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      );
    }


  }


  Future<void> initPlatformState() async {
    JPush jpush = new JPush();
    jpush.getRegistrationID().then((rid) {
      print(rid);
    });
    //初始化
    jpush.setup(
      appKey: "0f0c2c32c44de0182e5ab113",
      channel: "theChannel",
      production: false,
      debug: true,
    );
    //设置别名，指定用户推送
    jpush.setAlias(this.userInfo['decorationId'].toString()).then((map) {
      print("设置别名成功"+this.userInfo['decorationId']);
    });
    //IOS10+ 可以通过该方法来设置推送是否前台展示，是否触发声音，是否设置应用角标badge
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } on Exception {
      print("Failed to get platform version");
    }
  }


}

