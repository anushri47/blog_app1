import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class CrudMethods{

  Future<void> addData(blogData) async{

    FirebaseFirestore.instance.collection("blogs").add(blogData).catchError((e){
      print(e);
    });

  }
}