import 'package:flutter/material.dart';
import 'package:jaguar/jaguar.dart';
import 'package:wh_flutter_app/routes/jaguar_flutter_asset.dart';
import 'routes/Routes.dart';

//void main() => runApp(MyApp());

main() async{
  final server = Jaguar(address: "127.0.0.1",port: 9000);
  server.addRoute(serveFlutterAssets());
  await server.serve(logRequests: true);
  server.log.onRecord.listen((r) => print(r));


  runApp(MyApp());
}


class MyApp extends StatefulWidget  {

  @override
  _MyAppState createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp> {

//  @override
//  void initState() {
//    super.initState();
//    _initFluwx();
//  }

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

}

