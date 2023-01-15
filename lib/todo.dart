// リスト一覧画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_study_dev/chat.dart';

class Todo {
  final String uuid, content;
  Todo(this.uuid, this.content);

  Map<String, String> toMap() {
    return {'uuid': uuid, 'content': content};
  }
}

class TodoListPage extends StatefulWidget {
  final String currentEmail;
  final User currentUser;
  const TodoListPage(
      {super.key, required this.currentEmail, required this.currentUser});

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Todo> todos = [];
  List<Todo> otherTodos = [];

  void fetchTdos() {
    CollectionReference collectionRef = db.collection('users');
    DocumentReference docRef = collectionRef.doc(widget.currentUser.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          (doc.data() as Map<String, dynamic>)['todos']
              .forEach((e) => todos.add(Todo(e['uuid'], e['content'])));
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          (doc.data() as Map<String, dynamic>)['otherTodos']
              .forEach((e) => otherTodos.add(Todo(e['uuid'], e['content'])));
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTdos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // AppBarを表示し、タイトルも設定
          appBar: AppBar(
            title: const Text('リスト一覧'),
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
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: '自分のもの'),
                Tab(text: '他人のもの'),
              ],
            ),
          ),
          body: TabBarView(children: [
            ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                            todo: todos[index],
                                            currentUser: widget.currentUser,
                                          )));
                                },
                                child: Card(
                                  child: ListTile(
                                      title: Text(todos[index].content)),
                                ))),
                        SizedBox(
                            width: 50,
                            child: IconButton(
                                onPressed: (() {
                                  setState(() {
                                    todos.removeAt(index);
                                  });
                                  db
                                      .collection("users")
                                      .doc(widget.currentUser.uid)
                                      .set({'todos': todos}).onError((e, _) =>
                                          print("Error writing document: $e"));
                                }),
                                icon: const Icon(Icons.delete_forever)))
                      ]);
                }),
            ListView.builder(
                itemCount: otherTodos.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                            todo: otherTodos[index],
                                            currentUser: widget.currentUser,
                                          )));
                                },
                                child: Card(
                                  child: ListTile(
                                      title: Text(otherTodos[index].content)),
                                ))),
                        const SizedBox(width: 50, child: Text('hoge'))
                      ]);
                }),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // "push"で新規画面に遷移
              final String? newContent =
                  await Navigator.of(context).push<String?>(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return const TodoAddPage();
                }),
              );
              if (newContent != null) {
                setState(() {
                  final String newUid = const Uuid().v4();
                  todos.add(Todo(newUid, newContent));
                });
                db
                    .collection("users")
                    .doc(widget.currentUser.uid)
                    .set({'todos': todos.map((e) => e.toMap())}).onError(
                        (e, _) => print("Error writing document: $e"));
                db
                    .collection("chatRooms")
                    .doc(todos.last.uuid)
                    .set({"title": todos.last.content, "messages": []});
              }
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  TodoAddPageState createState() => TodoAddPageState();
}

class TodoAddPageState extends State<TodoAddPage> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ToDo作成"),
        ),
        body: Container(
          padding: const EdgeInsets.all(64),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  content,
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  onChanged: (String value) {
                    setState(() {
                      content = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    // ボタンをクリックした時の処理
                    onPressed: () {
                      // "pop"で前の画面に戻る
                      Navigator.of(context).pop(content);
                    },
                    child: const Text('追加'),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    // ボタンをクリックした時の処理
                    onPressed: () {
                      // "pop"で前の画面に戻る
                      Navigator.of(context).pop();
                    },
                    child: const Text('キャンセル'),
                  ),
                )
              ]),
        ));
  }
}
