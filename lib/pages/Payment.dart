import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:wh_flutter_app/config/Config.dart';
/*薪酬  &  工时  明细*/

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {

  InAppWebViewController webView;
  String url = "";
  //    String url = "https://www.slashgo.cn/wx-slash-young/wechat/applet/orderGrabRob?userId=194697",

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('薪酬 & 工时 明细'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrl: "https://www.originsf.com.cn/wx_tenthousand_no/mobile/dtdeductions/info?decorationId=1",
              initialOptions: {
                "useShouldOverrideUrlLoading" : true,
              },
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                if(progress/100>0.999) {
                  print("加载完成了");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
