import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_study_dev/todo.dart';
import 'package:flutter_study_dev/user_list.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatRoom extends StatefulWidget {
  final Todo todo;
  final User currentUser;
  const ChatRoom({super.key, required this.todo, required this.currentUser});

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<types.Message> _messages = [];
  late types.User _user;

  @override
  void initState() {
    super.initState();

    _user = types.User(
        id: widget.currentUser.uid, firstName: widget.currentUser.email);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.todo.content),
          actions: [
            Container(
                width: 100,
                height: double.infinity,
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text('招待',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserListPage()));
                  },
                ))
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('chatRooms').doc(widget.todo.uuid).snapshots(),
          builder: (context, snapshot) {
            _messages = [];
            (snapshot.data!.data() as Map<String, dynamic>)['messages']
                .forEach((e) => _messages.add(types.Message.fromJson(e)));
            return Chat(
              user: _user,
              messages: _messages,
              onSendPressed: _handleSendPressed,
              showUserNames: true,
            );
          },
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    db.collection("chatRooms").doc(widget.todo.uuid).set({
      'title': widget.todo.content,
      'messages': _messages.map((e) => e.toJson())
    }).onError((e, _) => print("Error writing document: $e"));
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }
}
