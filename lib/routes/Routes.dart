import 'package:flutter/material.dart';
import 'package:wh_flutter_app/pages/AppendService.dart';
import 'package:wh_flutter_app/pages/ChargeBackApply.dart';
import 'package:wh_flutter_app/pages/ComfirmService.dart';
import 'package:wh_flutter_app/pages/Payment.dart';
import 'package:wh_flutter_app/pages/Receipt.dart';
import 'package:wh_flutter_app/pages/ShowSelfService.dart';
import 'package:wh_flutter_app/pages/UnComfirmService.dart';
import 'package:wh_flutter_app/pages/WorkOrderList.dart';
import 'package:wh_flutter_app/pages/tabs/Appointment.dart';
import 'package:wh_flutter_app/pages/tabs/Home.dart';
import 'package:wh_flutter_app/pages/tabs/Service.dart';
import 'package:wh_flutter_app/utils/DatePickerRange.dart';
import 'package:wh_flutter_app/utils/PhotpAssetGalleryPage.dart';
import 'package:wh_flutter_app/utils/PhotpGalleryPage.dart';
import '../Login.dart';
import '../pages/Tabs.dart';

//配置路由
final routes={
      '/login':(context)=>LoginPage(),
      '/tab':(context)=>Tabs(),
      '/service':(context,{arguments})=>ServicePage(arguments: arguments),
      '/appointment':(context)=>AppointmentPage(),
      '/home':(context)=>HomePage(),
      '/workOrderList':(context,{arguments})=>WorkOrderListPage(arguments: arguments),
      '/chargeBackApply':(context,{arguments})=>ChargeBackApplyPage(arguments: arguments),
      '/appendService':(context,{arguments})=>AppendServicePage(arguments: arguments),
      '/comfirmService':(context,{arguments})=>ComfirmServicePage(arguments: arguments),
      '/unComfirmService':(context,{arguments})=>UnComfirmServicePage(arguments: arguments),
      '/payment':(context,{arguments})=>PaymentPage(arguments: arguments),
      '/receipt':(context,{arguments})=>ReceiptPage(arguments: arguments),
      '/photoGallery':(context,{arguments})=>PhotpGalleryPage(arguments: arguments),
      '/photoAssetGallery':(context,{arguments})=>PhotpAssetGalleryPage(arguments: arguments),
      '/datePickerRange' :(context)=> DatePickerRange(),
      '/showSelfService' :(context, {arguments})=> ShowSelfServicePage(arguments: arguments),
};
//固定写法
// ignore: top_level_function_literal_block
var onGenerateRoute=(RouteSettings settings) {
      // 统一处理
      final String name = settings.name;
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
            final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
            return route;
        }
      }
};