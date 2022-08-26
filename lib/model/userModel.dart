import 'dart:convert';

class UserModel {
  final String address;
  final String email_id;
  final String fullName;
  final String user_id;
  final String phone_no;
  final String photo_url;
  final String user_type;

  final String bus_id;
  final String gender;
  final String user_lat;
  final String user_long;
  final List<dynamic> school_id;


  UserModel(this.user_id,this.email_id,this.fullName,  this.address,this.photo_url,this.phone_no,this.user_type,
      this.bus_id,  this.gender,this.user_lat,this.user_long,this.school_id);

  Map<String, dynamic> toJson()
  {
    return {
      'user_id': user_id,
      'email_id': email_id,
      'fullName':fullName,
      'address': address,
      'photo_url': photo_url,
      'phone_no': phone_no,
      'user_type' : user_type,
      'bus_id':bus_id,
      'gender': gender,
      'user_lat': user_lat,
      'user_long': user_long,
      'school_id' : school_id
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {

    return UserModel(
        map['user_id'],
        map['email_id'],
        map['fullName'],
        map['address'],
        map['photo_url'],
        map['phone_no'],
        map['user_type'],
        map['bus_id'],
        map['gender'],
        map['user_lat'],
        map['user_long'],
        map['school_id']
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        json.decode(source),
      );
}
