
class BusModel{

  String bus_id;
  final int bus_number;
  final String school_id;
  bool active_sharing;
  bool going_to_school;
  String current_lat;
  String current_long;
  String destination;
  String destination_lat;
  String destination_long;
  String source;
  String source_lat;
  String source_long;





  BusModel(this.bus_id,this.bus_number,this.school_id,this.active_sharing,this.going_to_school,this.current_lat,this.current_long,this.source,this.source_lat,this.source_long,this.destination,this.destination_lat,this.destination_long);

  Map<String, dynamic> toJson() {
    return {
    'bus_id' : bus_id,
    'bus_number' : bus_number,
    'school_id' : school_id,
    'active_sharing' : active_sharing,
    'going_to_school' : going_to_school,
    'current_lat' : current_lat,
    'current_long' : current_long,
      'source' : source,
      'source_lat' : source_lat,
      'source_long' : source_long,
    'destination' : destination,
    'destination_lat' : destination_lat,
    'destination_long' : destination_long
    };
  }

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
        map['bus_id'],
        map['bus_number'],
        map['school_id'],
        map['active_sharing'],
        map['going_to_school'],
        map['current_lat'],
        map['current_long'],
        map['source'],
        map['source_lat'],
        map['source_long'],
        map['destination'],
        map['destination_lat'],
        map['destination_long']

    );
  }


}