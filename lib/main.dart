//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String id = "YyFOQeZmNkk9k4en8Oav";

  //Pega UM documento
  // DocumentSnapshot snapshot =
  //     await FirebaseFirestore.instance.collection("mensagens").doc(id).get();
  // print(snapshot.data());

  //Pega VÁRIOS documentos
  await Firebase.initializeApp();

  await FirebaseFirestore.instance
      .collection("mensagens")
      .doc('YyFOQeZmNkk9k4en8Oav')
      .snapshots()
      .listen((dado) {
    print(dado.data());
  });

  // Pega toda a coleção sempre que um dado for alterado
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
