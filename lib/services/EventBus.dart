import 'package:event_bus/event_bus.dart';



//Bus 初始化

EventBus eventBus = EventBus();


//用户中心广播
class UserEvent{
  String str;
  UserEvent(String str){
    this.str=str;
  }
}




