import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key});

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  // Habilita o btn se houver algum texto
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              //Comprime o input na vertical
              decoration: InputDecoration.collapsed(
                hintText: "Enviar uma mensagem",
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {},
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            onPressed: _isComposing ? () {} : null,
          ),
        ],
      ),
    );
  }
}
