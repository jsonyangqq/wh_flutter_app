import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _username = new TextEditingController(); //初始化的时候给表单赋值
  bool visibleTarget = false;
  bool visibleComplete = true;
  bool visibleText = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username.text = '';
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            //设置线性渐变
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.blueAccent,
                    Color.fromRGBO(241, 243, 244, 0),
                  ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(ScreenAdapter.width(21)),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.itying.com/images/flutter/3.png'),
                      radius: ScreenAdapter.size(80),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('我是微信昵称', style: TextStyle(fontSize: ScreenAdapter.size(38.0))),
                      SizedBox(
                        height: ScreenAdapter.height(6.0),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.yellow, size: ScreenAdapter.size(48.0)),
                          Icon(Icons.star, color: Colors.yellow, size: ScreenAdapter.size(48.0)),
                          Icon(Icons.star, color: Colors.white, size: ScreenAdapter.size(48.0))
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenAdapter.width(128), bottom: ScreenAdapter.height(48)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text('排名：',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: ScreenAdapter.size(27.0))),
                                Text('26',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: ScreenAdapter.size(27.0)))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenAdapter.width(16), right: ScreenAdapter.width(16), top: ScreenAdapter.height(10)),
                child: Ink(
                  decoration: BoxDecoration(
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(10.0))),
                    //设置四周边框
                    border: Border.all(width: ScreenAdapter.width(1), color: Colors.cyan),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ScreenAdapter.width(10.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: ScreenAdapter.width(2), color: Colors.cyan),
                        borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.attach_money,
                                    color: Colors.blue, size: ScreenAdapter.size(136)),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenAdapter.height(8.0),
                              ),
                              Text('本月累计薪酬',
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(32.0),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: ScreenAdapter.width(2.0))),
                              SizedBox(
                                height: ScreenAdapter.height(5.0),
                              ),
                              Text('本月累计扣款',
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(32.0),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: ScreenAdapter.width(2.0))),
                              SizedBox(
                                height: ScreenAdapter.size(5.0),
                              ),
                              Text('本月累计工时',
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(32.0),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: ScreenAdapter.width(2))),
                              SizedBox(
                                height: ScreenAdapter.height(5.0),
                              ),
                              Text('当前第一名薪酬：4000',
                                  style:
                                  TextStyle(fontSize: ScreenAdapter.size(19.0), color: Colors.red)),
                              SizedBox(
                                height: ScreenAdapter.height(8.0),
                              )
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: ScreenAdapter.width(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: ScreenAdapter.height(8.0),
                                  ),
                                  Text('490.00元',
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(32.0),
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    height: ScreenAdapter.height(5.0),
                                  ),
                                  Text('30.00元',
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(32.0),
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    height: ScreenAdapter.height(5.0),
                                  ),
                                  Text('26小时',
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(32.0),
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    height: ScreenAdapter.height(5.0),
                                  ),
                                  Text(
                                    '本月平均薪酬：2000',
                                    style: TextStyle(
                                        fontSize: ScreenAdapter.size(19.0), color: Colors.red),
                                  ),
                                  SizedBox(
                                    height: ScreenAdapter.height(8.0),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      print("跳转到薪酬&工时页面");
                      Navigator.pushNamed(context, '/payment');
                    },
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenAdapter.width(16.0), right: ScreenAdapter.width(16.0), top: ScreenAdapter.height(10.0)),
                child: Container(
                  height: ScreenAdapter.height(80.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: ScreenAdapter.width(2.0),
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(ScreenAdapter.width(13.0))),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: ScreenAdapter.width(16.0),
                      ),
                      Icon(
                        Icons.flag,
                        color: Colors.red,
                        size: ScreenAdapter.size(48.0),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(30.0),
                      ),
                      Text(
                        '本月接单数：50',
                        style: TextStyle(fontSize: ScreenAdapter.size(32.0)),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(80.0),
                      ),
                      Text(
                        '本月退单数：10',
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(32.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: visibleTarget,
                child:  Padding(
                  padding: EdgeInsets.only(left: ScreenAdapter.width(16.0), right: ScreenAdapter.width(16.0), top: ScreenAdapter.height(13.0)),
                  child: Container(
                    height: ScreenAdapter.height(72.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "本月薪酬目标",
                                  border: OutlineInputBorder(
                                      //圆角边大小
                                      borderRadius: BorderRadius.circular(ScreenAdapter.width(32.0)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(32.0),
                        ),
                        Container(
                          child: Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "本月目标工单数",
                                    border: OutlineInputBorder(
                                      //圆角边大小
                                      borderRadius: BorderRadius.circular(ScreenAdapter.width(32.0)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white
                                ),
                                controller: _username,
                                onChanged: (value) {
                                  setState(() {
                                    this._username.text = value;
                                  });
                                },
                              )),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(32.0),
                        ),
                        //OffStage弹出布局
                        RaisedButton(
                          child: Text('GO!',style: TextStyle(fontSize: ScreenAdapter.size(32.0)),),
                          color: Colors.blue,
                          textColor: Colors.white,
                          elevation: ScreenAdapter.width(32.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenAdapter.width(32.0))),
                          onPressed: () {
                            setState(() {
                              visibleComplete = false;
                              visibleText = false;
                              visibleTarget = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: visibleComplete,
                child: Padding(
                  padding: EdgeInsets.only(left: ScreenAdapter.width(16.0), right: ScreenAdapter.width(16.0), top: ScreenAdapter.height(13.0)),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenAdapter.height(72.0),
                        // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                        child: ClipRRect(
                          // 边界半径（`borderRadius`）属性，圆角的边界半径。
                          borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0))),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: Color(0xffffff),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenAdapter.height(72.0),
                        padding: EdgeInsets.only(left: ScreenAdapter.width(11.0)),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(border: Border.all(width: ScreenAdapter.width(2.0),color: Colors.blue),borderRadius:BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0))), ),
                        child: Text(
                          '已抢60%',
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: ScreenAdapter.size(32.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: visibleText,
                child:  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(13.0)),
                    child: TextClickView(
                      title: '修改本月薪酬目标',
                      color: Colors.blue,
                      rightClick: (){
                        setState(() {
                          visibleComplete = true;
                          visibleText = true;
                          visibleTarget = false;
                        });
                      },
                    )
                ),
              )
            ],
          ),
        ),
        Expanded(
          child:  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('退出微信登录',style: TextStyle(fontSize: ScreenAdapter.size(29.0),color: Colors.red),),
                Divider(
                  //距离左边的距离
                  indent: ScreenAdapter.width(24.0),
                  //距离右边的距离
                  endIndent: ScreenAdapter.width(24.0),
                ),
                SizedBox(height: ScreenAdapter.height(48.0))
              ],
            ),
          ),
        )
      ],
    );
  }
}
