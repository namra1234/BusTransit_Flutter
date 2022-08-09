

import 'package:school_bus_transit/common/constants.dart';
import 'package:school_bus_transit/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('User');

  dynamic getUser(String user_id) async {

    print(user_id);

    final docSnapshot = await collection
        .where("user_id", isEqualTo: user_id)
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

      Constants.userdata = UserModel.fromMap(UserMap as Map<String,dynamic>);
      return UserMap;

    });
  }

  dynamic getDriver(List<String> user_id) async {

    print(user_id);
    List<UserModel> driverList=[];
    final docSnapshot = await collection
        .where("bus_id", whereIn: user_id)
        .get()
        .then((var snapshot) async {
      final newDocRef = collection.doc();

      // dynamic d1=snapshot.docs[0].data();
      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;
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
      Constants.driverdataTemp = driverList;
      return driverList;

    });
  }


  dynamic createUser(UserModel Usermodel) async {

    final docSnapshot = await collection
        .where("user_id", isEqualTo: Usermodel.user_id)
        .get()
        .then((var snapshot) async {
      final newDocRef = collection.doc();
      if (snapshot.docs.length == 0) {
        final newDocRef = collection.doc(Constants.loggedInUserID);
        Map? UserMap = Usermodel.toJson();
        UserMap['user_id'] = Constants.loggedInUserID;
        await newDocRef.set(UserMap);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('user_id', Constants.loggedInUserID);
        return newDocRef;
      } else {
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // preferences.setString('id', snapshot.docs.first.data()['id']);
        return null;
      }
    });
  }



  // Future<bool> updateUser(UserModel userModel,String? docId) async{
  //   try{
  //     final newDocRef = collection.doc(docId);
  //     await newDocRef.update(userModel.toJson());
  //     Constants.userdata = userModel;
  //     return true;
  //   }
  //   catch(e){
  //     return false;
  //   }
  // }
  //
  //


}
