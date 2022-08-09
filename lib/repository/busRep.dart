import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:school_bus_transit/repository/userRep.dart';

import '../model/busModel.dart';
import '../model/parentScreenModel.dart';


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

  Future<List<parentScreenModel>> getParentScreenDetils(List<dynamic> school_name) async {

    List<BusModel> busList=[];
    List<parentScreenModel> parentScreenData=[];
    List<String> bus_idList=[];
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
        bus_idList.add(bus_id);
        print("------");
        print(bus_id);
        print("------");
        Map? BusMap =  BusModel(bus_id,bus_number,school_id,active_sharing,going_to_school,current_lat,current_long,source,source_lat,source_long,destination,destination_lat,destination_long).toJson();

        busList.add(BusModel.fromMap(BusMap as Map<String,dynamic>));
      }

    });

    await UserRepository().getDriver(bus_idList);


    for(int i=0;i<busList.length;i++)
    {

      for(int j=0;j<Constants.driverdataTemp.length;j++)
        {
              if(busList[i].bus_id==Constants.driverdataTemp[j].bus_id)
                {
                  Map? parentMap =  parentScreenModel(busList[i].bus_number.toString(),Constants.driverdataTemp[j].photo_url , busList[i].bus_id, Constants.driverdataTemp[j].fullName, Constants.driverdataTemp[j].photo_url, Constants.driverdataTemp[j].phone_no, busList[i].going_to_school).toJson();

                  parentScreenData.add(parentScreenModel.fromMap(parentMap as Map<String,dynamic>));
                }
        }

    }

    Constants.parentScreenData = parentScreenData;
    return parentScreenData;
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

  dynamic getBusInfo(String bus_id) async {

    print(bus_id + " -- from BusRap ->  getBusInfo()");

    final docSnapshot = await collection
        .where("bus_id", isEqualTo: bus_id)
        .get()
        .then((var snapshot) async {
      final newDocRef = collection.doc();

      // dynamic d1=snapshot.docs[0].data();

      Map<String, dynamic>? data=snapshot.docs[0].data() as Map<String, dynamic>?;
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


      Map? BusMap =  BusModel(bus_id,bus_number,school_id,active_sharing,going_to_school,current_lat,current_long,source,source_lat,source_long,destination,destination_lat,destination_long).toJson();

      Constants.singleBusData =BusModel.fromMap(BusMap as Map<String,dynamic>);
      return BusMap;
    });
    return Constants.singleBusData;
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

  dynamic deleteBus(String? bus_id) async{
    try{
      final newDocRef = collection.doc(bus_id);
      await newDocRef.delete();
      return true;
    }
    catch(e){
      return false;
    }
  }

  getBus(String busId) async {
    return collection.doc(busId).snapshots();
  }

}