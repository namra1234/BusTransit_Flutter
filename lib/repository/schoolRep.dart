import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:school_bus_transit/model/schoolModel.dart';

class SchoolRepository{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('School');

  Future<List<SchoolModel>> getAllSchool() async {

      print("----------------------------------------> call getAllSchool");

      List<SchoolModel> schoolList=[];
    final docSnapshot = await collection.get().then((var snapshot)
    async {
      final newDocRef = collection.doc();

      for(int i=0;i<snapshot.docs.length;i++)
      {
        Map<String, dynamic>? data=snapshot.docs[i].data() as Map<String, dynamic>?;
        String? school_id = data!["school_id"].toString();
        String? name =      data!["name"].toString();
        String? email_id =  data!["email_id"].toString();
        String? phone_no =  data!["phone_no"].toString();
        String? address =   data!["address"].toString();
        String? lat =       data!["lat"].toString();
        String? long =      data!["long"].toString();

        // print(name);
        Map? SchoolMap =  SchoolModel(school_id, name, email_id, phone_no,address,lat, long).toJson();

        schoolList.add(SchoolModel.fromMap(SchoolMap as Map<String,dynamic>));
      }

    });
    //   print(" total length---------------->");
    // print(schoolList.length);
    //   print(" total length---------------->");
      return schoolList;
  }


  dynamic addNewSchool(Map<String, dynamic> schoolModel) async {

    try{
      final newDocRef = collection.doc();
      await newDocRef.set(schoolModel);
      return newDocRef.id;
    }
    catch(e){
      print(e);
      return "false";
    }

  }

  dynamic updateSchool(Map<String, Object?> schoolModel,String? docId) async{
    try{
      final newDocRef = collection.doc(docId);
      await newDocRef.update(schoolModel);
      return true;
    }
    catch(e){
      return false;
    }
  }


  dynamic SchoolCount() async {

    int count = 0;
    print("----------------------------------------> call SchoolCount");
    final docSnapshot = await collection.get().then((var snapshot)
    async {
      final newDocRef = collection.doc();
      count = snapshot.docs.length;
    });
    return count;
  }


}