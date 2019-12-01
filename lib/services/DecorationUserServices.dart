/*装维人员服务接口调用*/

import 'dart:convert';

import 'package:wh_flutter_app/utils/Storage.dart';

class DecorationUserServices{

  /**
   * 获取用户基本信息
   */
  static getUserInfo() async{
    Map<String,dynamic> userinfo;
    try {
      Map<String,dynamic> userInfoData = json.decode(await Storage.getString("userInfo"));
      userinfo = userInfoData;
    } catch (e) {
      print("exceptiono:");
      userinfo = Map();
    }
    return userinfo;
  }

  /**
   * 获取用户的登录状态
   */
  static getUserLoginState() async{
    var userInfo=await DecorationUserServices.getUserInfo();
    if(userInfo.length>0&&userInfo["decorationId"]!=""){
      return true;
    }
    return false;
  }
  static loginOut(){
    Storage.remove('userInfo');
  }
}