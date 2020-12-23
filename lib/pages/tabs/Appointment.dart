import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/utils/Storage.dart';

class AppointmentPage extends StatefulWidget {


  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  Map<String,dynamic> userInfo = Map();

  double progress = 0;

  @override
  void initState() {
    super.initState();
    _getUserInfoData();
  }

  ///获取用户数据
  _getUserInfoData() async {
    Map<String,dynamic> userInfo = json.decode(await Storage.getString("userInfo"));
    setState(() {
      this.userInfo = userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    int decorationId = this.userInfo["decorationId"];
    return decorationId == null ? Text("加载中...") :Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrl: Config.domain + "/orderGrabRob?decorationId=$decorationId",
              initialOptions: InAppWebViewWidgetOptions(
                  inAppWebViewOptions: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onProgressChanged: (InAppWebViewController controller, int progress) {
                if(progress/100>0.999) {
                  print("加载完成了");
                }
              },
            ),
          )
        ],
      );
  }
}
