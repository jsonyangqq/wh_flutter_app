import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/config/Config.dart';
import 'package:wh_flutter_app/model/RemunerationModel.dart';
import 'package:wh_flutter_app/services/DecorationUserServices.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';
import 'package:wh_flutter_app/utils/Storage.dart';
import 'package:wh_flutter_app/utils/TextClickView.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _remunerate = new TextEditingController(); //初始化的时候给表单赋值
  var _workOrderNum = new TextEditingController(); //初始化的时候给表单赋值
  bool visibleTarget = false;   //输入目标输入框，默认显示，如果存在完成情况隐藏
  bool visibleComplete = true;  //有完成情况显示，没有完成情况隐藏，默认是没有完成情况
  bool visibleText = true;      //表示修改薪酬目标和工单目标文字相应事件，和上面的visibleComplete显示隐藏一致
  Map<String,dynamic> userInfo = Map();
  RemunerationModel _remunerationData = RemunerationModel.initData(0.00,0.00,0.00,0.00,0.00,0,0,0,0.00,0.00);
  double _accumulateRemunerateTarget = 0.00;  //输入的本月薪酬目标
  double _accumulateWorkOrderTarget = 0.00;   //输入的本月工单目标



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPowerExeu();
//    _getUserInfoData();
//    Future.delayed(Duration(seconds: 1), (){
//      _getRemunerationData();
//    });
//    });
  }


  Future _loadPowerExeu() async{
    _getUserInfoData().then((info){
      _getRemunerationData().then((info){
        setState(() {
          if((this._remunerationData.accumulateRemunerateTarget != null && this._remunerationData.accumulateRemunerateTarget !=0.00 && this._remunerationData.accumulateRemunerateTarget !=0.0) ||
              (this._remunerationData.accumulateWorkOrderTarget !=null && this._remunerationData.accumulateWorkOrderTarget !=0.00 && this._remunerationData.accumulateWorkOrderTarget !=0.0)){
            visibleComplete = false;
            visibleText = false;
            visibleTarget = true;
          }else{
            visibleComplete = true;
            visibleText = true;
            visibleTarget = false;
          }
        });
      });
    });
  }

  ///获取用户数据
  _getUserInfoData() async {
    Map<String,dynamic> userInfo = json.decode(await Storage.getString("userInfo"));
    setState(() {
      this.userInfo = userInfo;
    });
  }

  ///展示师傅薪酬详情
  _getRemunerationData() async {
    int decorationId = this.userInfo["decorationId"];
    var api = Config.domain + "/mobile/remuneration/mine?decorationId=$decorationId";
    var response = await Dio().get(api);
    if(response.data['ret']==true){
      print(response.data);
      setState(() {
        this._remunerationData = RemunerationModel.fromJson(response.data["data"]);
      });
    }
  }

  ///改变薪酬目标和工单数目标
  void changeRemunerationTarget() async{
    ///如果目标输入框中的值还是初始化的值，那我们就不修改本月目标,否则进行修改
    if(this._accumulateRemunerateTarget == 0.00 && this._accumulateWorkOrderTarget == 0.00){
      return;
    }
    int decorationId = this.userInfo["decorationId"];
    var api = Config.domain + "/mobile/remuneration/updateCurMothPayAndWkOTarget";
    var response =await Dio().post(
        api,
        data: {
          "decorationId" : decorationId,
          "accumulateRemunerateTarget" : this._accumulateRemunerateTarget,
          "accumulateWorkOrderTarget" : this._accumulateWorkOrderTarget,
          "accumulateRemuneration": this._remunerationData.accumulateRemuneration,
          "accumulateDeductions": this._remunerationData.accumulateDeductions,
          "accumulateReceiveNum": this._remunerationData.accumulateReceiveNum,
        }
     );
    if(response.data["ret"] == true){
      print(response.data["data"]);
      setState(() {
        if(response.data["data"]["accumulateRemunerateTarget"]!=null){
          this._remunerationData.accumulateRemunerateTarget = response.data["data"]["accumulateRemunerateTarget"];
        }
        if(response.data["data"]["accumulateWorkOrderTarget"]!=null){
          this._remunerationData.accumulateWorkOrderTarget = response.data["data"]["accumulateWorkOrderTarget"];
        }
        visibleComplete = false;
        visibleText = false;
        visibleTarget = true;
      });
      Fluttertoast.showToast(
        msg: '目标制定成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }else{
      Fluttertoast.showToast(
        msg: '薪酬目标修改失败～',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  ///获取我得页面星星显示
  List<Widget> _getSkillGradeStarShow() {
    int skillGradeId = (userInfo["skillGradeId"] == "" || userInfo["skillGradeId"] == null)  ? -5 : int.parse(userInfo["skillGradeId"]);
    List<Widget> list = new List();
    for(int i=0;i<3;i++){
      if(i<=skillGradeId){
        list.add(Icon(Icons.star, color: Colors.yellow, size: ScreenAdapter.size(48.0)));
      }else{
        list.add(Icon(Icons.star_border, color:Colors.yellow, size: ScreenAdapter.size(48.0)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: ScreenAdapter.height(900)
          ),
          child: SizedBox(
            height: ScreenAdapter.height(1100),
            child: Column(
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
                              Text('我是师傅名字', style: TextStyle(fontSize: ScreenAdapter.size(38.0))),
                              SizedBox(
                                height: ScreenAdapter.height(6.0),
                              ),
                              Row(
                                children: _getSkillGradeStarShow(),
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
                                        Text('${this._remunerationData.totalRank}',
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
                                          Text('当前第一名薪酬：${this._remunerationData.currentFirstAccumulate}',
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
                                              Text('${this._remunerationData.accumulateRemuneration}元',
                                                  style: TextStyle(
                                                      fontSize: ScreenAdapter.size(32.0),
                                                      fontWeight: FontWeight.w300)),
                                              SizedBox(
                                                height: ScreenAdapter.height(5.0),
                                              ),
                                              Text('${this._remunerationData.accumulateDeductions}元',
                                                  style: TextStyle(
                                                      fontSize: ScreenAdapter.size(32.0),
                                                      fontWeight: FontWeight.w300)),
                                              SizedBox(
                                                height: ScreenAdapter.height(5.0),
                                              ),
                                              Text('${this._remunerationData.accumulateManhour}小时',
                                                  style: TextStyle(
                                                      fontSize: ScreenAdapter.size(32.0),
                                                      fontWeight: FontWeight.w300)),
                                              SizedBox(
                                                height: ScreenAdapter.height(5.0),
                                              ),
                                              Text(
                                                '本月平均薪酬：${this._remunerationData.averageAccumulate}',
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
                        child: Ink(
                          child: InkWell(
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
                                    '本月接单数：${this._remunerationData.accumulateReceiveNum}',
                                    style: TextStyle(fontSize: ScreenAdapter.size(32.0)),
                                  ),
                                  SizedBox(
                                    width: ScreenAdapter.width(80.0),
                                  ),
                                  Text(
                                    '本月退单数：${this._remunerationData.accumulateChargebackNum}',
                                    style: TextStyle(
                                      fontSize: ScreenAdapter.size(32.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              print("跳转到工单列表页面");
                              Navigator.pushNamed(context, '/workOrderList');
                            },
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
                                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                          hintText: "本月薪酬目标",
                                          border: OutlineInputBorder(
                                            //圆角边大小
                                            borderRadius: BorderRadius.circular(ScreenAdapter.width(32.0)),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        controller: _remunerate,
                                        onChanged: (value) {
                                          setState(() {
                                            this._accumulateRemunerateTarget = double.parse(value);
                                          });
                                        },
                                        onSubmitted: (value){
                                          setState(() {
                                            this._accumulateRemunerateTarget = double.parse(value);
                                          });
                                        }
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenAdapter.width(32.0),
                                ),
                                Container(
                                  child: Expanded(
                                      child: TextField(
                                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                        style: TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                            hintText: "本月目标工单数",
                                            border: OutlineInputBorder(
                                              //圆角边大小
                                              borderRadius: BorderRadius.circular(ScreenAdapter.width(32.0)),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white
                                        ),
                                        controller: _workOrderNum,
                                        onChanged: (value) {
                                          setState(() {
                                            this._accumulateWorkOrderTarget = double.parse(value);
                                          });
                                        },
                                        onSubmitted: (value){
                                          setState(() {
                                            this._accumulateWorkOrderTarget = double.parse(value);
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
                                    changeRemunerationTarget();
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
                                    // value: (this._remunerationData.accumulateRemunerateTarget/100),
                                    value: 0,
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
                                  '本月薪酬目标   已完成${this._remunerationData.accumulateRemunerateTarget}%',
                                  style: TextStyle(
//                            color: Color(0xffFFFFFF),
                                    color: Colors.yellow,
                                    fontSize: ScreenAdapter.size(32.0),
                                  ),
                                ),
                              ),
                            ],
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
                                    // value: (this._remunerationData.accumulateWorkOrderTarget/100),
                                    value: 0,
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
                                  '本月工单目标   已完成${this._remunerationData.accumulateWorkOrderTarget}%',
                                  style: TextStyle(
//                            color: Color(0xffFFFFFF),
                                    color: Colors.yellow,
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
                        TextClickView(
                          title: '退出微信登录',
                          color: Colors.red,
                          style: TextStyle(fontSize: ScreenAdapter.size(29.0),color: Colors.red),
                          rightClick: (){
                            DecorationUserServices.loginOut();
                            this._getUserInfoData();
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
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
            ),
          )
        ),
    );
  }
}
