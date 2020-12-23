import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/model/User.dart';
import 'config/Config.dart';
import 'pages/Tabs.dart';
import 'services/EventBus.dart';
import 'utils/ScreenAdapter.dart';
import 'utils/Storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _globalKey = new GlobalKey(); //用来标记控件
  String _staffno='';
  String password='';
  bool _expand = false; //是否展示历史账号
  List<User> _users = new List(); //历史账号

  doLogin() async{
    var api ='${Config.domain}/mobile/mobileLogin/doLogin';
    var response =await Dio().post(api, data: {"staffno" : this._staffno, "password" : this.password});
    if(response.data["ret"] == true){
      print(response.data);
      //提交
//      Storage.saveUser(User(_staffno, password));
      Storage.addNoRepeat(_users, User(_staffno, password));
      //保存用户信息
      Storage.setString("userInfo", User(_staffno, password),response.data["data"]);
      Navigator.of(
          context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) => Tabs()), (route) => route == null
      );
    }else{
      Fluttertoast.showToast(
        msg: '${response.data["msg"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  //监听登录页面销毁的事件
  dispose(){
    super.dispose();
    eventBus.fire(UserEvent('登录成功...'));
  }

  @override
  void initState() {
    super.initState();
    _gainUsers();
  }
  var usernameController = new TextEditingController();
  var userPwdController = new TextEditingController();

  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        if(_globalKey.currentContext == null) {
          return null;
        }else {
          RenderBox renderObject = _globalKey.currentContext.findRenderObject();
          final position = renderObject.localToGlobal(Offset.zero);
          double screenW = MediaQuery.of(context).size.width;
          double currentW = renderObject.paintBounds.size.width;
          double currentH = renderObject.paintBounds.size.height;
          double margin = (screenW - currentW) / 2;
          double offsetY = position.dy;
          double itemHeight = 30.0;
          double dividerHeight = 2;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: ListView(
              itemExtent: itemHeight,
              padding: EdgeInsets.all(0),
              children: children,
            ),
            width: currentW,
            height: (children.length * itemHeight +
                (children.length - 1) * dividerHeight),
            margin: EdgeInsets.fromLTRB(margin, offsetY + currentH, margin, 0),
          );
        }
      }
    }
    return null;
  }

  ///构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = new List();
    for (int i = 0; i < _users.length; i++) {
      if (_users[i] != User(_staffno, password)) {
        //增加账号记录
        list.add(_buildItem(_users[i]));
        //增加分割线
        list.add(Divider(
          color: Colors.grey,
          height: 2,
        ));
      }
    }
    if (list.length > 0) {
      list.removeLast(); //删掉最后一个分割线
    }
    return list;
  }

  ///构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(user.username),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.highlight_off,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  _users.remove(user);
                  Storage.delUser(user);
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if (!(_users.length > 1 ||
                      _users[0] != User(_staffno, password))) {
                    //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                    _expand = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _staffno = user.username;
          password = user.password;
          _expand = false;
        });
      },
    );
  }

  ///获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await Storage.getUsers());
    //默认加载第一个账号
    if (_users.length > 0) {
      _staffno = _users[0].username;
      password = _users[0].password;
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return  Scaffold(
      body: SingleChildScrollView(
        child:  Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: ScreenAdapter.height(120)),
              Image.asset(
                "images/dianxin.png",
                width: ScreenAdapter.width(180),
                height: ScreenAdapter.height(180),
                fit: BoxFit.fill,
              ),
              SizedBox(height: ScreenAdapter.height(80)),
              Padding(
                padding: EdgeInsets.all(10.0),
                //用户名输入框
                child: TextField(
                  key: _globalKey,
                  //控制器
//                  controller: usernameController,
                  controller: usernameController = TextEditingController.fromValue(
                    TextEditingValue(
                      text: _staffno,
                      selection: TextSelection.fromPosition(
                        TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: _staffno == null ? 0 : _staffno.length,
                        ),
                      ),
                    ),
                  ),
                  maxLength: 12,
                  maxLines: 1,
                  //是否自动更正
                  autocorrect: true,
                  //是否自动对焦
                  //autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "请输入工号",
                    helperText: "工号",
                    icon: new Icon(Icons.account_box),
                    suffixIcon: GestureDetector(
                      child: _expand
                          ? Icon(
                        Icons.arrow_drop_up,
                        color: Colors.red,
                      )
                          : Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        if (_users.length > 1 || _users[0] != User(_staffno, password)) {
                          //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                          setState(() {
                            _expand = !_expand;
                          });
                        }
                      },
                    ),
                  ),
                  onChanged: (text) {
                    this._staffno = text;
                    //内容改变的回调
                    print('change $text');
                  },
                  onSubmitted: (text) {
                    this._staffno = text;
                    //内容提交(按回车)的回调
                    print('submit $text');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                //密码输入框
                child: TextField(
//                  controller: userPwdController,
                  controller: userPwdController = TextEditingController.fromValue(
                    TextEditingValue(
                      text: password,
                      selection: TextSelection.fromPosition(
                        TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: password == null ? 0 : password.length,
                        ),
                      ),
                    ),
                  ),
                  //输入密码格式限制
//                  inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9_]"))],
                  maxLength: 18,
                  maxLines: 1,
                  //是否自动更正
                  autocorrect: true,
                  //是否自动对焦
                  //autofocus: true,
                  decoration: new InputDecoration(
                    hintText: "请输入密码",
                    labelText: "请输入密码",
                    helperText: "密码",
                    icon: new Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    this.password = text;
                    print('change $text');
                  },
                  onSubmitted: (text) {
                    this.password = text;
                    //内容提交(按回车)的回调
                    print('submit $text');
                  },
                ),
              ),
              Container(
                //这里写800已经超出屏幕了，可以理解为match_parent
                width: ScreenAdapter.width(800.0),
                margin: EdgeInsets.all(ScreenAdapter.width(10.0)),
                padding: EdgeInsets.all(ScreenAdapter.width(10.0)),
                //类似cardview
                child: new Card(
                  color: Colors.blueAccent,
                  elevation: ScreenAdapter.size(5.0),
                  //按钮
                  child: new FlatButton(
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      onPressed: () {
                        if (usernameController.text.isEmpty) {
                          //第三方的插件Toast，https://pub.dartlang.org/packages/fluttertoast
                          Fluttertoast.showToast(
                              msg: "工号不能为空哦",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white);
                        } else if (userPwdController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "密码不能为空哦",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white);
                        } else {
                          //请求登录接口操作
                          doLogin();
                        }
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Text(
                          '登录',
                          style: new TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                      )),
                ),
              ),
              Offstage(
                child: _buildListView(),
                offstage: !_expand,
              ),
            ],
          ),
        ),
      )
    );
  }
}
