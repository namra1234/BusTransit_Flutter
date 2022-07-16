
class SchoolModel{

  String school_id;
  final String name;
  final String email_id;
  final String phone_no;
  final String address;
  final String lat;
  final String long;

  SchoolModel(this.school_id, this.name, this.email_id, this.phone_no,
      this.address, this.lat, this.long);

  Map<String, dynamic> toJson() {
    return {
      'school_id':school_id,
      'name':name,
      'email_id':email_id,
      'phone_no':phone_no,
      'address':address,
      'lat':lat,
      'long':long,
    };
  }

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
        map['school_id'],
        map['name'],
        map['email_id'],
        map['phone_no'],
        map['address'],
        map['lat'],
        map['long'],
    );
  }


}