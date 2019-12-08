
import 'dart:ui';

class AbilityModel {
  int abilityTagId;
  String name;
  bool flag;
  Color backgroundColor;
  Color textColor;

  AbilityModel(
      {this.abilityTagId,
        this.name,
        this.flag,
        this.backgroundColor,
        this.textColor});

  AbilityModel.fromJson(Map<String, dynamic> json) {
    abilityTagId = json['abilityTagId'];
    name = json['name'];
    flag = json['flag'];
    backgroundColor = json['backgroundColor'];
    textColor = json['textColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abilityTagId'] = this.abilityTagId;
    data['name'] = this.name;
    data['flag'] = this.flag;
    data['backgroundColor'] = this.backgroundColor;
    data['textColor'] = this.textColor;
    return data;
  }
}
