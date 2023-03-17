import 'dart:io';

import 'package:chat_online__flutter/chat_message.dart';
import 'package:chat_online__flutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Usuario atual
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    //Sempre que a autenticação mudar chama a func do listen
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User?> _getUser() async {
    // Verifica se está logado
    if (_currentUser != null) return _currentUser;
    // Se for nulo, faz o LOGIN

    // Processo de LOGIN
    try {
      // Pega a conta que logou
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      // Pega os tokens p/ conectar com o Fireb
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      // Conexão com o Fireb
      // [1] GoogleAuthProvider
      final AuthCredential credential = GoogleAuthProvider.credential(
        // Pega o token
        idToken: googleSignInAuthentication.idToken,
        // Pega o accessToken
        accessToken: googleSignInAuthentication.accessToken,
      );
      // Login no Fb
      // Funciona para todos os tipos de login, basta mudar o provider [1]
      // Armazena o resultado do Login
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //Pega o user no Fb
      final User? user = authResult.user;

      // Ao terminar o login, retorna o user que acabou de logar
      return user;
    } catch (error) {
      // return null quando expirar o tempo de login do user
      return null;
    }
  }

  void _sendMessage({String? text, File? imgFile}) async {
    // Pega o user atual
    final User? user = await _getUser();

    // Se é null para poder enviar uma msg
    if (user == null) {
      //exibe a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Não foi possivel fazer o login. Tente novamente"),
        backgroundColor: Colors.red,
      ));
    }

    Map<String, dynamic> data = {
      'uid': user!.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'time': Timestamp.now()
    };

    if (imgFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      TaskSnapshot taskSnapshot = await task;
      //Pega a url de download
      String url = await taskSnapshot.ref.getDownloadURL();
      //Se for feito o upload da img, ela é armazenada no map
      data["imgUrl"] = url;
    }

    if (text != null) {
      data['text'] = text;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> docs =
                        snapshot.data!.docs.reversed.toList();

                    return ListView.builder(
                      itemCount: docs.length,
                      reverse: true, // msg aparece de baixo para cima
                      itemBuilder: (context, index) {
                        return ChatMessage(
                            docs[index].data() as Map<String, dynamic>, true);
                      },
                    );
                }
              },
            ),
          ),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}
