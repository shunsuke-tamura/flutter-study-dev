import 'dart:io';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final String currentEmail;

  const ChatPage({super.key, required this.title, required this.currentEmail});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
