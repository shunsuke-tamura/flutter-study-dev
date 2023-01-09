// リスト一覧画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  final String currentEmail;
  final String currentUid;
  const TodoListPage(
      {super.key, required this.currentEmail, required this.currentUid});

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> todos = [];

  void fetchTdos() {
    CollectionReference collectionRef = db.collection('users');
    DocumentReference docRef = collectionRef.doc(widget.currentUid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          todos = (doc.data() as Map<String, dynamic>)['todos'].cast<String>()
              as List<String>;
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
    return Scaffold(
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
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Card(
                    child: ListTile(title: Text(todos[index])),
                  )),
                  SizedBox(
                      width: 50,
                      child: IconButton(
                          onPressed: (() {
                            setState(() {
                              todos.removeAt(index);
                            });
                            db
                                .collection("users")
                                .doc(widget.currentUid)
                                .set({'todos': todos}).onError((e, _) =>
                                    print("Error writing document: $e"));
                          }),
                          icon: const Icon(Icons.delete_forever)))
                ]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          final String? newContent = await Navigator.of(context).push<String?>(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return const TodoAddPage();
            }),
          );
          if (newContent != null) {
            setState(() {
              todos.add(newContent);
            });
            db
                .collection("users")
                .doc(widget.currentUid)
                .set({'todos': todos}).onError(
                    (e, _) => print("Error writing document: $e"));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
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
