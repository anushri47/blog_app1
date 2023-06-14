import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';


class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  Uint8List? uploadedImage;
  final picker = ImagePicker();
  bool _isLoading = false;
  String authorName = "", title = "", desc = "";

  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        uploadedImage = bytes;
      });
    }
  }

  Future<void> uploadBlog() async {
    if (uploadedImage != null) {
      setState(() {
        _isLoading = true;
      });

      final imageName = "${randomAlphaNumeric(9)}.jpg";
      final firebaseStorageRef =
      FirebaseStorage.instance.ref().child("blogImage").child(imageName);

      final uploadTask = firebaseStorageRef.putData(uploadedImage!);
      final taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, String> blogMap = {
        "imgUrl": imageUrl,
        "authorName": authorName,
        "title": title,
        "desc": desc
      };

      FirebaseFirestore.instance
          .collection("blogs")
          .add(blogMap)
          .then((value) {
        setState(() {
          _isLoading = false;
          uploadedImage = null;
          authorName = "";
          title = "";
          desc = "";
        });
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to add blog: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
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
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              GestureDetector(
                onTap: pickImage,
                child: uploadedImage != null
                    ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(uploadedImage!),
                )
                    : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.black45,
                  ),

                ),
              ),

              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(hintText: "Author Name"),
                onChanged: (val) {
                  setState(() {
                    authorName = val;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: "Title"),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: "Desc"),
                onChanged: (val) {
                  setState(() {
                    desc = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
