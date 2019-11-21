

import 'package:flutter/material.dart';
import 'package:wh_flutter_app/pages/tabs/Service.dart';

import 'tabs/Home.dart';

class Tabs extends StatefulWidget {
  final index;
  Tabs({Key key,this.index=1}) : super(key: key);

  _TabsState createState() => _TabsState(this.index);
}

class _TabsState extends State<Tabs> {

  int _currentIndex;
  _TabsState(index){
    this._currentIndex=index;
  }

  List _pageList=[
    ServicePage(),
    HomePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("万号工程师"),
      ),
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,   //配置对应的索引值选中
        onTap: (int index){
          setState(() {  //改变状态
            this._currentIndex=index;
          });
        },
        iconSize:36.0,      //icon的大小
        fixedColor:Colors.blue,  //选中的颜色
        type:BottomNavigationBarType.fixed,   //配置底部tabs可以有多个按钮
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("服务")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("我的")
          )
        ],
      ),
    );
  }
}