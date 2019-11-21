
import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

/*追加服务页面*/

class AppendServicePage extends StatefulWidget {

  Map arguments;
  AppendServicePage({Key key, this.arguments}) : super(key: key);
  @override
  _AppendServicePageState createState() => _AppendServicePageState();
}

class _AppendServicePageState extends State<AppendServicePage> {

  String serviceName = "这是第1条数据";
  double money=80;
  int number=1;

  Color backgroundColor;
  Color textColor;

  List<Widget> _listData = new List();

  @override
  void initState() {
    backgroundColor = Color.fromRGBO(255, 255, 255, 1);
    textColor = Color.fromRGBO(255, 204, 51, 1);
    // TODO: implement initState
    super.initState();
    for(var i=1;i<=20;i++){
      _listData.add(
          Padding(
            padding: EdgeInsets.only(left: ScreenAdapter.width(20.0),top: ScreenAdapter.height(8.0),bottom: ScreenAdapter.height(0.0),right: ScreenAdapter.width(20)),
            child: Ink(
              //用ink圆角矩形
              // color: Colors.red,
                decoration: BoxDecoration(
                  //背景
                  color: backgroundColor,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0))),
                  //设置四周边框
                  border: Border.all(width: 1, color: Colors.grey),
                ),
              child: InkWell(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(16.0)),
                  child: Container(
//                    decoration: BoxDecoration(
//                        border: Border.all(width: 1,color: Colors.grey),
//                        borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0)))
//                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: ScreenAdapter.width(16.0),right: ScreenAdapter.width(1.0)),
                          child: Container(
                            height: ScreenAdapter.height(88.0),
                            alignment: Alignment.centerLeft,
                            child: Text("服务名称：这是$i",style: TextStyle(fontSize: ScreenAdapter.size(22.0)),),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: ScreenAdapter.width(16.0),left: ScreenAdapter.width(1.0)),
                            child: Container(
                              alignment: Alignment.centerRight,
                              height: ScreenAdapter.height(88),
                              child: Text('\$\80', style: TextStyle(fontSize: ScreenAdapter.size(30),
                                  color: textColor,
                                  fontWeight: FontWeight.w500)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                //设置点击事件回调
                onTap: () {
                  print("这是点击的第$i个元素");
                  print(_listData[i]);
                },
              ),
            )
          ),
      );
    }
    _listData.add(
        Padding(
          padding: EdgeInsets.only(left: ScreenAdapter.width(200),right: ScreenAdapter.width(200),top: ScreenAdapter.height(68.0),bottom: ScreenAdapter.height(32)),
          child: RaisedButton(
            child: Text('追加服务'),
            color: Colors.lightBlue,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenAdapter.width(32))),
            onPressed: () {
              print("追加服务");
            },
          ),
        )
    );
  }


  List<Widget>  _getListData(){
    return  _listData;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('追加服务'),
      ),
      body: ListView(
        children: _getListData(),
      )
    );
  }
}
