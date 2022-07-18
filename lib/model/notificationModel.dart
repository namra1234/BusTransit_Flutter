
class NotificationModel{

  String notification_id;
  String driver_id;
  String bus_id;
  String school_id;
  String title;
  String message;
  DateTime timestamp;

  NotificationModel(this.notification_id,this.driver_id,this.bus_id,this.school_id,this.title,this.message,this.timestamp);

  Map<String, dynamic> toJson() {
    return {
    'notification_id':notification_id,
    'driver_id' : driver_id,
    'bus_id' : bus_id,
    'school_id': school_id,
    'title': title,
    'message': message,
    'timestamp': timestamp
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        map['notification_id'],
        map['driver_id'],
        map['bus_id'],
        map['school_id'],
        map['title'],
        map['message'],
        map['timestamp']
    );
  }

}