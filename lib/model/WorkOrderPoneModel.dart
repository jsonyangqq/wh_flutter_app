class WorkOrderPondModel {
  int workOrderId;
  String resultBussback;
  String checkfaillReason;
  String orderId;
  int decorationId;
  String description;
  String imageUrl;
  String username;
  String telphone;
  String detailAddress;
  String appointUpTime;
  String isComplete;
  String orderType;
  bool visibleHomeEntry = false;
  bool visibleComplete = true;
  String newWfJobNumber;
  String areaName;
  String serviceName;
  double serviceFee;
  int number;
  String itvAccount;
  String snNumber;
  String broadbandWidth;
  String assignAccount;

  WorkOrderPondModel(
      {this.workOrderId,
        this.resultBussback,
        this.checkfaillReason,
        this.orderId,
        this.decorationId,
        this.description,
        this.imageUrl,
        this.username,
        this.telphone,
        this.detailAddress,
        this.appointUpTime,
        this.isComplete,
        this.orderType,
        this.visibleHomeEntry,
        this.visibleComplete,
        this.newWfJobNumber,
        this.areaName,
        this.serviceName,
        this.serviceFee,
        this.number,
        this.itvAccount,
        this.snNumber,
        this.broadbandWidth,
        this.assignAccount});

  WorkOrderPondModel.fromJson(Map<String, dynamic> json) {
    workOrderId = json['workOrderId'];
    resultBussback = json['resultBussback'];
    checkfaillReason = json['checkfaillReason'];
    orderId = json['orderId'];
    decorationId = json['decorationId'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    username = json['username'];
    telphone = json['telphone'];
    detailAddress = json['detailAddress'];
    appointUpTime = json['appointUpTime'];
    isComplete = json['isComplete'];
    orderType = json['orderType'];
    visibleHomeEntry = json['visibleHomeEntry'];
    visibleComplete = json['visibleComplete'];
    newWfJobNumber = json['newWfJobNumber'];
    areaName = json['areaName'];
    serviceName = json['serviceName'];
    serviceFee = json['serviceFee'];
    number = json['number'];
    itvAccount = json['itvAccount'];
    snNumber = json['snNumber'];
    broadbandWidth = json['broadbandWidth'];
    assignAccount = json['assignAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workOrderId'] = this.workOrderId;
    data['resultBussback'] = this.resultBussback;
    data['checkfaillReason'] = this.checkfaillReason;
    data['orderId'] = this.orderId;
    data['decorationId'] = this.decorationId;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['username'] = this.username;
    data['telphone'] = this.telphone;
    data['detailAddress'] = this.detailAddress;
    data['appointUpTime'] = this.appointUpTime;
    data['isComplete'] = this.isComplete;
    data['orderType'] = this.orderType;
    data['visibleHomeEntry'] = this.visibleHomeEntry;
    data['visibleComplete'] = this.visibleComplete;
    data['newWfJobNumber'] = this.newWfJobNumber;
    data['areaName'] = this.areaName;
    data['serviceName'] = this.serviceName;
    data['serviceFee'] = this.serviceFee;
    data['number'] = this.number;
    data['itvAccount'] = this.itvAccount;
    data['snNumber'] = this.snNumber;
    data['broadbandWidth'] = this.broadbandWidth;
    data['assignAccount'] = this.assignAccount;
    return data;
  }
}