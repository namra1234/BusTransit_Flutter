import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bus_transit/common/constants.dart';

import '../model/busModel.dart';


class BusRepository{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Bus');

  Future<List<BusModel>> getAllBus(String school_id) async {

    print("----------------------------------------> call getAllBus");

    List<BusModel> busList=[];

    final docSnapshot = await collection.where("school_id", isEqualTo: school_id)
        .get()
        .then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;
        String? bus_id          = data!["bus_id"].toString();
        int    bus_number      = data!["bus_number"];
        String? school_id       = data!["school_id"].toString();
        bool   active_sharing  = data!["active_sharing"];
        bool   going_to_school = data!["going_to_school"];
        String? current_lat     = data!["current_lat"].toString();
        String? current_long    = data!["current_long"].toString();
        String? destination     = data!["destination"].toString();
        String? destination_lat = data!["destination_lat"].toString();
        String? destination_long= data!["destination_long"].toString();
        String? source          = data!["source"].toString();
        String? source_lat      = data!["source_lat"].toString();
        String? source_long     = data!["source_long"].toString();

        print("------");
        print(bus_id);
        print("------");
        Map? BusMap =  BusModel(bus_id,bus_number,school_id,active_sharing,going_to_school,current_lat,current_long,source,source_lat,source_long,destination,destination_lat,destination_long).toJson();

        busList.add(BusModel.fromMap(BusMap as Map<String,dynamic>));
      }

    });
    //   print(" total length---------------->");
    // print(schoolList.length);
    //   print(" total length---------------->");
    return busList;
  }


  dynamic addNewBus(Map<String, dynamic> busModel) async {

    try{
      final newDocRef = collection.doc();
      await newDocRef.set(busModel);
      return newDocRef.id;
    }
    catch(e){
      print(e);
      return "false";
    }

  }

  dynamic updateBus(Map<String, Object?> busModel,String? docId) async{
    try{
      final newDocRef = collection.doc(docId);
      await newDocRef.update(busModel);
      return true;
    }
    catch(e){
      return false;
    }
  }

  dynamic BusCount() async {

    int count = 0;
    print("----------------------------------------> call busCount");
    final docSnapshot = await collection.get().then((var snapshot)
    async {
      final newDocRef = collection.doc();
      count = snapshot.docs.length;
      print(count);
    });
    return count;
  }


}