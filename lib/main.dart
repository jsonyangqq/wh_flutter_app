import 'dart:convert';

import 'package:flutter/material.dart';
import 'routes/Routes.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import 'utils/Storage.dart';

//void main() => runApp(MyApp());

main() async{
//  final server = Jaguar(address: "118.24.9.160",port: 22);
//  server.addRoute(serveFlutterAssets());
//  await server.serve(logRequests: true);
//  server.log.onRecord.listen((r) => print(r));
  runApp(MyApp());
}


class MyApp extends StatefulWidget  {

  @override
  _MyAppState createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp> {

  Map<String,dynamic> userInfo = Map();

  @override
  void initState() {
    super.initState();
    _getUserInfoData();
    initPlatformState();
  }

  ///获取用户数据
  _getUserInfoData() async {
    Map<String,dynamic> userInfo = json.decode(await Storage.getString("userInfo"));
    setState(() {
      this.userInfo = userInfo;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: onGenerateRoute,
    );
  }

//  _initFluwx() async {
//    await fluwx.registerWxApi(
//        appId: "wxe3651df7028fcd16",
//        doOnAndroid: true,
//        doOnIOS: true,
//        universalLink: "https://your.univerallink.com/link/");
//    var result = await fluwx.isWeChatInstalled();
//    print("is installed $result");
//  }

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
    jpush.setAlias(this.userInfo['decorationId']).then((map) {
      print("设置别名成功");
    });
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: false, alert: false, badge: false));
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

