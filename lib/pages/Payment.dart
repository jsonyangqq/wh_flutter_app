import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:wh_flutter_app/config/Config.dart';
/*薪酬  &  工时  明细*/

class PaymentPage extends StatefulWidget {

  Map arguments;

  PaymentPage({Key key, this.arguments}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {

  InAppWebViewController webView;
  int decorationId;
//  String url = Config.domain + "/mobile/dtdeductions/info?decorationId=1";
//  String url = "https://www.slashgo.cn/wx-slash-young/wechat/wx/remuneration?startTimeList=null&endTimeList=null&startTime=&endTime=&userCode=JZ01927&userId=195034";
//  String url = "https://www.slashgo.cn/wx-slash-young/wechat/applet/orderGrabRob?userId=194697";

  double progress = 0;

  @override
  void initState() {
    super.initState();
    this.decorationId =widget.arguments['decorationId'];
  }


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
              initialUrl: Config.domain + "/mobile/dtdeductions/info?decorationId=$decorationId",
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
      ),
    );
  }
}
