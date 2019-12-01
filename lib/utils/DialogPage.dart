import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogPage{

  static alertDialog (BuildContext context,String serviceName)async{

    var result = await showDialog(
        barrierDismissible: false,//表示点击灰色背景时弹窗是否消失
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Color.fromRGBO(243, 246, 253, 1),
            title: Text("提示信息"),
            content: Text("确定要删除【我的工单宽带整装】吗"),
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
    print("result = "+result);

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