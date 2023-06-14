import 'package:flutter/material.dart';
import 'package:my_blog/home.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();
  runApp(MyApp());
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    // Add your Firebase configuration options here
    options: FirebaseOptions(
        apiKey: "AIzaSyDkFl9sG1KHUxGV6_rw3ORqypIQm9D2SSI",
        authDomain: "boop-631dc.firebaseapp.com",
        databaseURL: "https://boop-631dc-default-rtdb.firebaseio.com",
        projectId: "boop-631dc",
        storageBucket: "boop-631dc.appspot.com",
        messagingSenderId: "306638297608",
        appId: "1:306638297608:web:2cd250e5955dfd074c4fbd"
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
