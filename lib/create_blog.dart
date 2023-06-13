import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_blog/crud.dart';
import 'package:random_string/random_string.dart';


class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName="", title="",desc="";


  late File? selectedImage = null;
  final picker = ImagePicker();

  //@override
  //void initState() {
  //selectedImage = 'https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fmountains&psig=AOvVaw36rZTTtTdwF4hzbAioUugC&ust=1686723145521000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPDH7cDLv_8CFQAAAAAdAAAAABAE';
  //super.initState();
  bool _isLoading = false;
  CrudMethods crudMethods = new CrudMethods();


  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile!= null){
        selectedImage = File(pickedFile.path);
      }else{
        print("no image selected");
      }

    });
  }

  Future<void> uploadBlog() async{
    if(selectedImage != null){
      setState(() {
        _isLoading = true;
      });

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child("${randomAlphaNumeric(9)}.jpg");
      final UploadTask task= firebaseStorageRef.putFile(selectedImage!);

      var imageUrl;
      await task.whenComplete(() async{
        try{
          imageUrl= await firebaseStorageRef.getDownloadURL();
        }catch(onError){
          print("error");
        }
        print(imageUrl);
      });


      // var imageUrl = await (await task).ref.getDownloadURL();
      // print("this is url $downloadUrl");

      Map<String, dynamic> blogMap = {
        "imgUrl": imageUrl,
        "authorName": authorName,
        "title": title,
        "desc": desc
      };
      crudMethods.addData(blogMap).then((result){
        Navigator.pop(context);
      });
    }else{}
  }


  ///Future<void> getLostData() async {
  ///final ImagePicker picker = ImagePicker();
  ///final LostDataResponse response = await picker.retrieveLostData();
  ///if (response.isEmpty) {
  ///return;
  ///}
  ///final List<XFile>? files = response.files;
  ///if (files != null) {
  ///_handleLostFiles(files);
  ///} else {
  ///_handleError(response.exception);
  ///}
  ///}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Flutter", style: TextStyle(
                  fontSize: 22
              ),
              ),
              Text("Blog", style: TextStyle(fontSize: 22, color: Colors.blue),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.file_upload)),
            )
          ],
        ),
        body: _isLoading
            ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
            : Container(
          child: Column(children: <Widget>[
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage != null
                  ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://unsplash.com/s/photos/mountains',
                    //selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  :Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black45,
                ),

              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Author Name"),
                    onChanged: (val){
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Title"),
                    onChanged: (val){
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Desc"),
                    onChanged: (val){
                      desc = val;
                    },
                  )
                ],),)

          ],),)
    );
  }
}