class ThisMonthWorkOrderModel {
  int workOrderId;
  String wxJobNumber;
  int decorationId;
  double serviceMoney;
  String description;
  String imageUrl;
  String appointUpTime;
  String isComplete;
  String creater;
  String serviceFor;
  int haddone;
  String checkfaillReason;
  ThisMonthWorkOrderModel(
      {this.workOrderId,
      this.wxJobNumber,
      this.decorationId,
      this.serviceMoney,
      this.description,
      this.imageUrl,
      this.appointUpTime,
      this.isComplete,
      this.creater,
      this.serviceFor,
      this. haddone,
      this.checkfaillReason});

  ThisMonthWorkOrderModel.fromJson(Map<String, dynamic> json) {
    workOrderId = json['workOrderId'];
    wxJobNumber = json['wxJobNumber'];
    decorationId = json['decorationId'];
    serviceMoney = json['serviceMoney'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    appointUpTime = json['appointUpTime'];
    isComplete = json['isComplete'];
    creater = json['creater'];
    serviceFor = json['serviceFor'];
    haddone = json['haddone'];
    checkfaillReason = json['checkfaillReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workOrderId'] = this.workOrderId;
    data['wxJobNumber'] = this.wxJobNumber;
    data['decorationId'] = this.decorationId;
    data['serviceMoney'] = this.serviceMoney;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['appointUpTime'] = this.appointUpTime;
    data['isComplete'] = this.isComplete;
    data['creater'] = this.creater;
    data['serviceFor'] = this.serviceFor;
    data['haddone'] = this.haddone;
    data['checkfaillReason'] = this.checkfaillReason;
    return data;
  }
}