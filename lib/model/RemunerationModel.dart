class RemunerationModel {
  dynamic accumulateRemuneration;
  dynamic accumulateDeductions;
  dynamic accumulateManhour;
  dynamic currentFirstAccumulate;
  dynamic averageAccumulate;
  dynamic accumulateReceiveNum;
  dynamic accumulateChargebackNum;
  int totalRank;
  dynamic accumulateRemunerateTarget;
  dynamic accumulateWorkOrderTarget;

  RemunerationModel(
      {this.accumulateRemuneration,
        this.accumulateDeductions,
        this.accumulateManhour,
        this.currentFirstAccumulate,
        this.averageAccumulate,
        this.accumulateReceiveNum,
        this.accumulateChargebackNum,
        this.totalRank,
        this.accumulateRemunerateTarget,
        this.accumulateWorkOrderTarget});

  RemunerationModel.initData(this.accumulateRemuneration, this.accumulateDeductions,
      this.accumulateManhour, this.currentFirstAccumulate,
      this.averageAccumulate, this.accumulateReceiveNum,
      this.accumulateChargebackNum, this.totalRank,this.accumulateRemunerateTarget,this.accumulateWorkOrderTarget);

  RemunerationModel.fromJson(Map<String, dynamic> json) {
    accumulateRemuneration = json['accumulateRemuneration'];
    accumulateDeductions = json['accumulateDeductions'];
    accumulateManhour = json['accumulateManhour'];
    currentFirstAccumulate = json['currentFirstAccumulate'];
    averageAccumulate = json['averageAccumulate'];
    accumulateReceiveNum = json['accumulateReceiveNum'];
    accumulateChargebackNum = json['accumulateChargebackNum'];
    totalRank = json['totalRank'];
    accumulateRemunerateTarget = json['accumulateRemunerateTarget'];
    accumulateWorkOrderTarget = json['accumulateWorkOrderTarget'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accumulateRemuneration'] = this.accumulateRemuneration;
    data['accumulateDeductions'] = this.accumulateDeductions;
    data['accumulateManhour'] = this.accumulateManhour;
    data['currentFirstAccumulate'] = this.currentFirstAccumulate;
    data['averageAccumulate'] = this.averageAccumulate;
    data['accumulateReceiveNum'] = this.accumulateReceiveNum;
    data['accumulateChargebackNum'] = this.accumulateChargebackNum;
    data['totalRank'] = this.totalRank;
    data['accumulateRemunerateTarget'] = this.accumulateRemunerateTarget;
    data['accumulateWorkOrderTarget'] = this.accumulateWorkOrderTarget;
    return data;
  }
}