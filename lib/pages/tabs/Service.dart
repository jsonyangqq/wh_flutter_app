import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  bool flag = true;
  bool visibleHomeEntry = false;
  bool visibleComplete = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              elevation: 0, //去掉导航栏下方阴影效果
              backgroundColor: Color.fromRGBO(241, 243, 244, 0),
              brightness: Brightness.light,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TabBar(
                      //设置指示器的颜色
                      indicatorColor: Colors.blue,
                      //设置选中时文字的颜色
                      labelColor: Colors.blue,
                      //设置未选中时文字的颜色
                      unselectedLabelColor: Colors.black,
                      //让指示器大小和tab等宽
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: <Widget>[Tab(text: '工单池'), Tab(text: '我的工单')],
                    ),
                  )
                ],
              )),
          body: TabBarView(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  //一个容器里面有五行,点击第一行可以折叠
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            initiallyExpanded: this.flag,
                            trailing: Text('\$\80', style: TextStyle(fontSize: 20,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w500)
                            ),
                            title: Row(
                              children: <Widget>[
                                Container(child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text('服务名称：宽带整装', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),),
                                )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0.0),
                                    child: Text('预约时间：2019-05-26 16：30',
                                        style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.right),
                                  ),
                                )
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  '我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 20,
                                      children: <Widget>[
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 0.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('用户地址：武汉市洪山区中南路9号中商广场',
                                        style: TextStyle(fontSize: 12),),
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text('提单'),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    onPressed: () {
                                      print("普通按钮");
                                    },
                                  ),
                                ],
                              ),
                            ],
                            onExpansionChanged: (value){
                              value = false;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            initiallyExpanded: this.flag,
                            trailing: Text('\$\80', style: TextStyle(fontSize: 20,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w500)
                            ),
                            title: Row(
                              children: <Widget>[
                                Container(child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text('服务名称：宽带整装', style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),),
                                )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0.0),
                                    child: Text('预约时间：2019-05-26 16：30',
                                        style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.right),
                                  ),
                                )
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  '我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 20,
                                      children: <Widget>[
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 0.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('用户地址：武汉市洪山区中南路9号中商广场',
                                        style: TextStyle(fontSize: 12),),
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text('提单'),
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    onPressed: () {
                                      print("普通按钮");
                                    },
                                  ),
                                ],
                              ),
                            ],
                            onExpansionChanged: (value){
                              value = false;
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            initiallyExpanded: this.flag,
                            trailing: Text('\$\80', style: TextStyle(fontSize: 18,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w500)
                            ),
                            title: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text('服务名称：宽带整装', style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),),
                                )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0.0),
                                    child: Text('预约时间：2019-05-26 16：30',
                                        style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.right),
                                  ),
                                )
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  '我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 22,
                                      children: <Widget>[
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        ),
                                        Image.asset(
                                          "images/shili.png",
                                          repeat: ImageRepeat.repeatX,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 0.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('用户姓名：张三',
                                        style: TextStyle(fontSize: 12),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 0.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('联系方式：18900000000',
                                        style: TextStyle(fontSize: 12),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5.0, 10.0, 0.0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('用户地址：武汉市洪山区中南路9号中商广场',
                                        style: TextStyle(fontSize: 12),),
                                    ),
                                  ),
                                  Offstage(
                                    offstage: visibleComplete,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(15.0,10.0,10.0,5),
                                      child: Row(
                                        children: <Widget>[
                                          Transform.rotate(
                                            angle: math.pi/4.0 ,
                                            child:  IconButton(
                                              icon: ImageIcon(AssetImage('images/2.0x/u5944.png'),size: ScreenAdapter.size(30),),
                                              onPressed: (){
                                                Navigator.pushNamed(context, '/appendService');
                                              },
                                            ),
                                          ),
                                          SizedBox(width:ScreenAdapter.width(0)),
                                          Text("追加服务",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black87),)
                                        ],
                                      ),
                                    )
                                  ),
                                  Offstage(
                                    offstage: visibleHomeEntry,
                                    child: Wrap(
                                      spacing: 80,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text('确认入户'),
                                          color: Colors.lightBlue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          onPressed: () {
                                            print("确认入户");
                                            setState(() {
                                              visibleHomeEntry = true;
                                              visibleComplete = false;
                                            });
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text('退单'),
                                          color: Colors.lightBlue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          onPressed: () {
                                            print("跳转到退单页面");
                                            Navigator.pushNamed(context, '/chargeBackApply');
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Offstage(
                                    offstage: visibleComplete,
                                    child: Wrap(
                                      spacing: 80,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text('已完成'),
                                          color: Colors.lightBlue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                          onPressed: () {
                                            print("已完成");
                                            Navigator.pushNamed(context, '/comfirmService');
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text('无法完成'),
                                          color: Colors.lightBlue,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          onPressed: () {
                                            print("退单");
                                            Navigator.pushNamed(context, '/unComfirmService');
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            onExpansionChanged: (value){
                              value = false;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }


}