import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bus_transit/model/notificationModel.dart';
import '../model/busModel.dart';


class NotificationRepository{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Notification');

  Future<List<NotificationModel>> getAllBus(String school_id) async {

    print("----------------------------------------> call getAllBus");

    List<NotificationModel> notificationList=[];

    final docSnapshot = await collection.where("school_id", isEqualTo: school_id)
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;

        String? notification_id  = data!["notification_id"].toString();
        String? driver_id        = data!["driver_id"].toString();
        String? bus_id           = data!["bus_id"].toString();
        String? school_id        = data!["school_id"].toString();
        String? title            = data!["title"].toString();
        String? message          = data!["message"].toString();
        DateTime timestamp      = data["timestamp"].toDate();

        Map? NotificationMap =  NotificationModel(notification_id,driver_id,bus_id,school_id,title,message,timestamp).toJson();

        notificationList.add(NotificationModel.fromMap(NotificationMap as Map<String,dynamic>));
      }

    });
    //   print(" total length---------------->");
    // print(schoolList.length);
    //   print(" total length---------------->");
    return notificationList;
  }


  Future<List<NotificationModel>> getAllBusNotification(List<dynamic> school_name) async {

    print("----------------------------------------> call getAllBus");

    List<NotificationModel> notificationList=[];

    List<dynamic> school_id=[];


    final docSnapshot = await FirebaseFirestore.instance.collection('School').where("name", whereIn: school_name)
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;
        String? s_id       = data!["school_id"].toString();

        school_id.add(s_id);
      }

    });

    final docSnapshot1 = await collection.where("school_id", whereIn: school_id)
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;

        String? notification_id  = data!["notification_id"].toString();
        String? driver_id        = data!["driver_id"].toString();
        String? bus_id           = data!["bus_id"].toString();
        String? school_id        = data!["school_id"].toString();
        String? title            = data!["title"].toString();
        String? message          = data!["message"].toString();
        DateTime timestamp      = data["timestamp"].toDate();

        Map? NotificationMap =  NotificationModel(notification_id,driver_id,bus_id,school_id,title,message,timestamp).toJson();

        notificationList.add(NotificationModel.fromMap(NotificationMap as Map<String,dynamic>));
      }

    });
    //   print(" total length---------------->");
    // print(schoolList.length);
    //   print(" total length---------------->");
    return notificationList;
  }


  dynamic addNotification(Map<String, dynamic> notificationModel) async {
    try{
      final newDocRef = collection.doc();
      await newDocRef.set(notificationModel);
      return newDocRef.id;
    }
    catch(e){
      print(e);
      return "false";
    }

  }

  dynamic updateNotification(Map<String, Object?> notificationModel,String? docId) async{
    try{
      final newDocRef = collection.doc(docId);
      await newDocRef.update(notificationModel);
      return true;
    }
    catch(e){
      return false;
    }
  }

  dynamic deleteNotification(String? notification_id) async{
    try{
      final newDocRef = collection.doc(notification_id);
      await newDocRef.delete();
      return true;
    }
    catch(e){
      return false;
    }
  }




}