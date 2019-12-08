/*工单列表页面*/

import 'package:flutter/material.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

class WorkOrderListPage extends StatefulWidget {
  @override
  _WorkOrderListPageState createState() => _WorkOrderListPageState();
}

class _WorkOrderListPageState extends State<WorkOrderListPage> {

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('工单列表'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false, //去掉头部返回按钮
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
                        tabs: <Widget>[Tab(text: '已完工'), Tab(text: '未完工')],
                      ),
                    )
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(16.0), ScreenAdapter.height(8.0), ScreenAdapter.width(16.0),ScreenAdapter.height(0.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0)))
                        ),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(
                              initiallyExpanded: this.flag,
                              trailing:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('订单状态',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                  Text('已完工',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                ],
                              ),
                              title: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('工单号',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                                      Text('12345678',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(20.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('上门时间',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                                      Text('2019-08-26',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(20.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('派单人',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                      Text('lalala',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(30.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('服务内容',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                      Text('路由器调式',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: <Widget>[
                                          Text('服务金额',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                          Text('500',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenAdapter.width(24.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                                  child: Text(
                                    '我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(16)),
                                      child: Wrap(
                                        spacing: ScreenAdapter.width(46.0),
                                        children: <Widget>[
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
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
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(16.0), ScreenAdapter.height(8.0), ScreenAdapter.width(16.0),ScreenAdapter.height(0.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(16.0)))
                        ),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(
                              initiallyExpanded: this.flag,
                              trailing:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('订单状态',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                  Text('未完工',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                ],
                              ),
                              title: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('工单号',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                                      Text('12345678',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(20.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('上门时间',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),),
                                      Text('2019-08-26',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(20.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('派单人',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                      Text('lalala',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  SizedBox(width: ScreenAdapter.width(30.0)),
                                  Column(
                                    children: <Widget>[
                                      Text('服务内容',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                      Text('路由器调式',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: <Widget>[
                                          Text('服务金额',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black)),
                                          Text('500',style: TextStyle(fontSize: ScreenAdapter.size(20),color: Colors.black),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenAdapter.width(24.0) , ScreenAdapter.height(0.0), ScreenAdapter.width(24.0), ScreenAdapter.height(0.0)),
                                  child: Text(
                                    '我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。我是用户对服务内容的描述。',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: ScreenAdapter.size(20.0)),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: ScreenAdapter.height(16.0),bottom: ScreenAdapter.height(16)),
                                      child: Wrap(
                                        spacing: ScreenAdapter.width(46.0),
                                        children: <Widget>[
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
                                          ),
                                          Image.asset(
                                            "images/shili.png",
                                            repeat: ImageRepeat.repeatX,
                                            width: ScreenAdapter.width(130.0),
                                            height: ScreenAdapter.width(130.0),
                                            fit: BoxFit.fill,
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
                )
              ],
            )),
      ),
    );
  }
}
