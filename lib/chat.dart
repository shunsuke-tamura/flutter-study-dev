import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_study_dev/todo.dart';

class ChatPage extends StatefulWidget {
  final Todo todo;
  final String currentEmail;

  const ChatPage({super.key, required this.todo, required this.currentEmail});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo.content),
        actions: [
          Container(
              width: 100,
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                widget.currentEmail,
                style: const TextStyle(fontSize: 15),
              ))
        ],
      ),
    );
  }
}
