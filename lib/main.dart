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

  String id = "YyFOQeZmNkk9k4en8Oav";

  db.collection('mensagens').doc(id).collection('arquivos').doc().set({
    //set({ content })
    // 'texto': 'Tudo 444444',
    // 'from': 'Teste 55555',
    // 'read': true,
    'arqname': 'foto.png'
  });

  final msg = <String, dynamic>{
    'texto': 'Tudo bem?',
    'from': 'MArcelo',
    'read': false,
  };

  // db.collection('mensagens').add(msg).then(
  //   (DocumentReference doc) =>
  //       print('DocumentSnapshot added with ID : ${doc.id}'));
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
