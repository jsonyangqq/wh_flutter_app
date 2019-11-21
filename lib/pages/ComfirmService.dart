
import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

/*已完成 确认服务页面*/

class ComfirmServicePage extends StatefulWidget {
  @override
  _ComfirmServicePageState createState() => _ComfirmServicePageState();
}

class _ComfirmServicePageState extends State<ComfirmServicePage> {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('服务确认'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: ScreenAdapter.width(20.0),top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(8.0),right: ScreenAdapter.width(20)),
            child: Text('请填写一下必要信息',style: TextStyle(fontSize: ScreenAdapter.size(32)),),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenAdapter.width(30.0),top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(8.0),right: ScreenAdapter.width(30)),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: ScreenAdapter.width(1),color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(32))),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      width: ScreenAdapter.width(500),
                      height: ScreenAdapter.height(80),
                      child: TextField(
                        decoration:InputDecoration(
                            hintText:"请上传图片用于工单凭证",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            )
                        ) ,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(height: ScreenAdapter.height(40), child: VerticalDivider(color: Colors.grey)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('点击上传'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:  Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset('images/4.0x/u8634.png',width: ScreenAdapter.width(480.0),height: ScreenAdapter.height(480.0),),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: ScreenAdapter.width(30),right: ScreenAdapter.width(30.0)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:  RaisedButton(
                              child: Text('现金支付',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w500),),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              onPressed: () {
                                print("现金支付");
                              },
                            ),
                          ),
                          SizedBox(width: ScreenAdapter.size(60.0),),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              child: Text('完成服务',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w500),),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                print("完成服务");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
