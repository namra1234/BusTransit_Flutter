import 'dart:convert';

class parentScreenModel {
  final String driverName;
  final String driverImage;
  final String bus_id;
  final String busNumber;
  final String phone_no;
  final String photo_url;
  final bool toSchool;


  parentScreenModel(this.busNumber,this.driverImage,this.bus_id,  this.driverName,this.photo_url,this.phone_no,this.toSchool);

  Map<String, dynamic> toJson() {
    return {
      'busNumber': busNumber,
      'driverImage': driverImage,
      'bus_id':bus_id,
      'driverName': driverName,
      'photo_url': photo_url,
      'phone_no': phone_no,
      'toSchool' : toSchool
    };
  }

  factory parentScreenModel.fromMap(Map<String, dynamic> map) {

    return parentScreenModel(
        map['busNumber'],
        map['driverImage'],
        map['bus_id'],
        map['driverName'],
        map['photo_url'],
        map['phone_no'],
        map['toSchool']
    );
  }

  factory parentScreenModel.fromJson(String source) => parentScreenModel.fromMap(
        json.decode(source),
      );
}
