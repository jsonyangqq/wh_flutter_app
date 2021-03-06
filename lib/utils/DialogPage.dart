import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wh_flutter_app/pages/Tabs.dart';

import 'ScreenAdapter.dart';

class DialogPage{

  static var serviceContentController = new TextEditingController();
  static var serviceFeeController = new TextEditingController();
  static var deviceFeeController = new TextEditingController();
  static var materialFeeController = new TextEditingController();

  static dynamic alertDialog (BuildContext context,String serviceName)async{

    var result = await showDialog(
        barrierDismissible: false,//表示点击灰色背景时弹窗是否消失
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Color.fromRGBO(243, 246, 253, 1),
            title: Text("提示信息"),
            content: Text("确定要删除【${serviceName}】吗"),
            actions: <Widget>[
              //定义浮动按钮
              FlatButton(
                child: Text("取消"),
                onPressed: (){
                  print("取消");
                  Navigator.pop(context,"Cancle");
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: (){
                  print("确定");
                  Navigator.pop(context,"OK");
                },
              ),
            ],
          );
        }
    );
    return result;

  }

  static dynamic comfirmDialog (BuildContext context,String hintInfo,String hintInfoTwo)async{
    var result = await showDialog(
        barrierDismissible: false,//表示点击灰色背景时弹窗是否消失
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Color.fromRGBO(243, 246, 253, 1),
            title: Text("提示信息",style: TextStyle(color: Colors.blue)),
            content: Container(child: Text('${hintInfo} \n ${hintInfoTwo}',textAlign: TextAlign.center,
              style: TextStyle(fontSize: ScreenAdapter.size(36),fontFamily: "微软雅黑"),)),
            actions: <Widget>[
              FlatButton(
                child: Text("确定"),
                onPressed: (){
                  print("确定");
                  Navigator.pop(context,"OK");
                  ///动态传递参数
//                  Navigator.push(context, new MaterialPageRoute(
//                    builder: (context) =>
//                      new Tabs(index: 0)
//                  ));
                  Navigator.of(
                      context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => Tabs(index: 0)), (route) => route == null
                  );
                },
              ),
            ],
          );
        }
    );
    return result;

  }


  static simpleDialog(BuildContext context) async{

    var result=await showDialog(
        barrierDismissible:false,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            title:Text("选择内容"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Option A"),
                onPressed: (){
                  print("Option A");
                  Navigator.pop(context,"A");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text("Option B"),
                onPressed: (){
                  print("Option B");
                  Navigator.pop(context,"B");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text("Option C"),
                onPressed: (){
                  print("Option C");
                  Navigator.pop(context,"C");
                },
              ),
              Divider(),

            ],

          );
        }
    );

    print(result);
  }


  ///简单的输入内容弹窗
  static simpleTextFieldDialog(BuildContext context) async{

    var result=await showDialog(
        barrierDismissible:false,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            title:Text("输入以下内容"),
            children: <Widget>[
              SimpleDialogOption(
                child: TextField(
                  controller: serviceContentController,
                  decoration: new InputDecoration(
                    labelText: "请输入服务内容",
                    border: InputBorder.none
                  ),
                ),
                onPressed: (){
                  print("Option A");
                  Navigator.pop(context,"A");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: TextField(
                  controller: serviceFeeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                  decoration: new InputDecoration(
                      labelText: "请输入服务费金额",
                      border: InputBorder.none
                  ),
                ),
                onPressed: (){
                  print("Option B");
                  Navigator.pop(context,"B");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: TextField(
                  controller: deviceFeeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                  decoration: new InputDecoration(
                      labelText: "请输入设备费金额",
                      border: InputBorder.none
                  ),
                ),
                onPressed: (){
                  print("Option C");
                  Navigator.pop(context,"C");
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: TextField(
                  controller: serviceFeeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),//设置键盘为可录入小数的数字
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//设置只能录入数字[0-9]
                  decoration: new InputDecoration(
                      labelText: "请输入材料费金额",
                      border: InputBorder.none
                  ),
                ),
                onPressed: (){
                  print("Option D");
                  Navigator.pop(context,"D");
                },
              ),
              Divider(),

            ],

          );
        }
    );

    print(result);
  }



  static modelBottomSheet(BuildContext context) async{

    var result=await showModalBottomSheet(
        context:context,
        builder: (context){
          return Container(
            height: 220,
            child: Column(
              children: <Widget>[

                ListTile(
                  title: Text("分享 A"),
                  onTap: (){
                    Navigator.pop(context,"分享 A");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("分享 B"),
                  onTap: (){
                    Navigator.pop(context,"分享 B");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("分享 C"),
                  onTap: (){
                    Navigator.pop(context,"分享 C");
                  },
                )
              ],
            ),
          );
        }
    );

    print(result);
  }
  toast(){

    Fluttertoast.showToast(
        msg: "提示信息",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}