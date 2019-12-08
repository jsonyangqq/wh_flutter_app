import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
/*薪酬  &  工时  明细*/

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {



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
//              initialUrl: "http://127.0.0.1:9000/html/payment.html",
              initialUrl: "https://www.slashgo.cn/wx-slash-young/wechat/applet/orderGrabRob?userId=194697",
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
