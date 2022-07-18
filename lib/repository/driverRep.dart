import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:school_bus_transit/model/userModel.dart';

import '../model/busModel.dart';


class DriverRepository{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('User');

  Future<List<UserModel>> getAllDriver() async {

    print("----------------------------------------> call getAllDriver");

    List<UserModel> driverList=[];
    final docSnapshot = await collection.where("user_type", isEqualTo: "DRIVER")
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {

        Map<String, dynamic>? data=snapshot.docs[0].data() as Map<String, dynamic>?;
        String? user_id = data!["user_id"].toString();
        String email_id = data['email_id'].toString();
        String phone_no = data['phone_no'].toString();
        String address = data['address'].toString();
        String user_type = data['user_type'].toString();
        String gender = data['gender'].toString();

        String fullName = data['fullName'].toString();
        String user_lat = data['user_lat'].toString();
        String user_long = data['user_long'].toString();
        String photo_url = data['photo_url'].toString();
        String bus_id = data['bus_id'].toString();
        List<dynamic> school_id = data['school_id'] as List<dynamic>;

        Map? UserMap =  UserModel(user_id,email_id,fullName,address,photo_url,phone_no,user_type,bus_id,gender,user_lat,user_long,school_id).toJson();

        driverList.add(UserModel.fromMap(UserMap as Map<String,dynamic>));
      }

    });

    return driverList;
  }

  Future<List<UserModel>> getAllNonAllocatedDriver() async {

    print("----------------------------------------> call get All Non Allocated Driver()");

    List<UserModel> driverList=[];
    final docSnapshot = await collection
        .where("user_type", isEqualTo: "DRIVER")
        .where("bus_id", isEqualTo: "")
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {

        Map<String, dynamic>? data=snapshot.docs[0].data() as Map<String, dynamic>?;
        String? user_id = data!["user_id"].toString();
        String email_id = data['email_id'].toString();
        String phone_no = data['phone_no'].toString();
        String address = data['address'].toString();
        String user_type = data['user_type'].toString();
        String gender = data['gender'].toString();

        String fullName = data['fullName'].toString();
        String user_lat = data['user_lat'].toString();
        String user_long = data['user_long'].toString();
        String photo_url = data['photo_url'].toString();
        String bus_id = data['bus_id'].toString();
        List<dynamic> school_id = data['school_id'] as List<dynamic>;

        Map? UserMap =  UserModel(user_id,email_id,fullName,address,photo_url,phone_no,user_type,bus_id,gender,user_lat,user_long,school_id).toJson();

        driverList.add(UserModel.fromMap(UserMap as Map<String,dynamic>));
      }

    });

    return driverList;
  }

  dynamic getBusDriver(String bus_id) async {

    print(bus_id + " -- from driverRap ->  getBusDriver()");

    final docSnapshot = await collection
        .where("user_type", isEqualTo: "DRIVER")
        .where("bus_id", isEqualTo: bus_id)
        .get()
        .then((var snapshot) async {
      final newDocRef = collection.doc();

      // dynamic d1=snapshot.docs[0].data();
      Map<String, dynamic>? data=snapshot.docs[0].data() as Map<String, dynamic>?;
      String? user_id = data!["user_id"].toString();
      String email_id = data['email_id'].toString();
      String phone_no = data['phone_no'].toString();
      String address = data['address'].toString();
      String user_type = data['user_type'].toString();
      String gender = data['gender'].toString();

      String fullName = data['fullName'].toString();
      String user_lat = data['user_lat'].toString();
      String user_long = data['user_long'].toString();
      String photo_url = data['photo_url'].toString();
      String bus_id = data['bus_id'].toString();
      List<dynamic> school_id = data['school_id'] as List<dynamic>;

      Map? UserMap =  UserModel(user_id,email_id,fullName,address,photo_url,phone_no,user_type,bus_id,gender,user_lat,user_long,school_id).toJson();

      print("$fullName --------------> from driverRap ---> getBusDriver()");
      Constants.CurrentDriverdata=UserModel.fromMap(UserMap as Map<String,dynamic>);
      return UserMap;
    });
  }

  dynamic driverCount() async {

    int count = 0;
    print("----------------------------------------> call busCount");
    final docSnapshot = await collection.where("user_type", isEqualTo: "DRIVER").get().then((var snapshot)
    async {
      final newDocRef = collection.doc();
      count = snapshot.docs.length;
      print(count);
    });
    return count;
  }

  dynamic driverBusCount(String bus_id) async {
    int count = 0;
    print("----------------------------------------> call busCount");
    final docSnapshot = await collection
        .where("user_type", isEqualTo: "DRIVER")
        .where("bus_id", isEqualTo: bus_id).get().then((var snapshot)
    async {
      final newDocRef = collection.doc();
      count = snapshot.docs.length;
      print(count);
    });
    return count;
  }

  //----------------- update Driver info ------------------

  dynamic updateDriver(Map<String, Object?> driverModel,String? docId) async{
    try{
      final newDocRef = collection.doc(docId);
      await newDocRef.update(driverModel);
      return true;
    }
    catch(e){
      return false;
    }
  }

  dynamic updateDriverSpecificDetails(String Key, String Val,String? docId) async{
    try{
      final newDocRef = collection.doc(docId);
      await newDocRef.update({Key: Val});
      return true;
    }
    catch(e){
      return false;
    }
  }



}