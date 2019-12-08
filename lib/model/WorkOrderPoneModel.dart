
class WorkOrderPondModel {
  int workOrderId;
  String orderId;
  int decorationId;
  int orderItemId;
  String serviceName;
  double serviceFee;
  int number;
  String description;
  String imageUrl;
  String username;
  String telphone;
  String detailAddress;
  String appointUpTime;
  String appointUpEndTime;
  String isComplete;
  List<OrderItemDtoList> orderItemDtoList;
  bool visibleHomeEntry = false;
  bool visibleComplete = true;

  WorkOrderPondModel(
      {this.workOrderId,
        this.orderId,
        this.decorationId,
        this.orderItemId,
        this.serviceName,
        this.serviceFee,
        this.number,
        this.description,
        this.imageUrl,
        this.username,
        this.telphone,
        this.detailAddress,
        this.appointUpTime,
        this.appointUpEndTime,
        this.isComplete,
        this.orderItemDtoList,
        this.visibleComplete,
        this.visibleHomeEntry
      });

  WorkOrderPondModel.fromJson(Map<String, dynamic> json) {
    workOrderId = json['workOrderId'];
    orderId = json['orderId'];
    decorationId = json['decorationId'];
    orderItemId = json['orderItemId'];
    serviceName = json['serviceName'];
    serviceFee = json['serviceFee'];
    number = json['number'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    username = json['username'];
    telphone = json['telphone'];
    detailAddress = json['detailAddress'];
    appointUpTime = json['appointUpTime'];
    appointUpEndTime = json['appointUpEndTime'];
    isComplete = json['isComplete'];
    visibleComplete = json['visibleComplete'];
    visibleHomeEntry = json['visibleHomeEntry'];
    if (json['orderItemDtoList'] != null) {
      orderItemDtoList = new List<OrderItemDtoList>();
      json['orderItemDtoList'].forEach((v) {
        orderItemDtoList.add(new OrderItemDtoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workOrderId'] = this.workOrderId;
    data['orderId'] = this.orderId;
    data['decorationId'] = this.decorationId;
    data['orderItemId'] = this.orderItemId;
    data['serviceName'] = this.serviceName;
    data['serviceFee'] = this.serviceFee;
    data['number'] = this.number;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['username'] = this.username;
    data['telphone'] = this.telphone;
    data['detailAddress'] = this.detailAddress;
    data['appointUpTime'] = this.appointUpTime;
    data['appointUpEndTime'] = this.appointUpEndTime;
    data['isComplete'] = this.isComplete;
    data['visibleComplete'] = this.visibleComplete;
    data['visibleHomeEntry'] = this.visibleHomeEntry;
    if (this.orderItemDtoList != null) {
      data['orderItemDtoList'] =
          this.orderItemDtoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemDtoList {
  int workOrderId;
  int orderItemId;
  String serviceName;
  double serviceFee;
  int number;

  OrderItemDtoList(
      {this.workOrderId,
        this.orderItemId,
        this.serviceName,
        this.serviceFee,
        this.number});

  OrderItemDtoList.fromJson(Map<String, dynamic> json) {
    workOrderId = json['workOrderId'];
    orderItemId = json['orderItemId'];
    serviceName = json['serviceName'];
    serviceFee = json['serviceFee'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workOrderId'] = this.workOrderId;
    data['orderItemId'] = this.orderItemId;
    data['serviceName'] = this.serviceName;
    data['serviceFee'] = this.serviceFee;
    data['number'] = this.number;
    return data;
  }
}