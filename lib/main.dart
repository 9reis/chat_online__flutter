import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var db = await FirebaseFirestore.instance;

  // Create a new user with a first and last name
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

// Add a new document with a generated ID
  db.collection("users").add(user).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));

  // Create a new user with a first and last name
  final user2 = <String, dynamic>{
    "first": "Alan",
    "middle": "Mathison",
    "last": "Turing",
    "born": 1912
  };

// Add a new document with a generated ID
  db.collection("users").add(user2).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // FirebaseFirestore.instance
  //     .collection("col")
  //     .doc("doc")
  //     .set({"texto": "9reis"});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}
