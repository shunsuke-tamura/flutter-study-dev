// リスト一覧画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_dev/todo.dart';

class UserOnDb {
  final String email, uid;
  UserOnDb(this.email, this.uid);
}

class UserListPage extends StatefulWidget {
  final String currentEmail;
  final Todo selectedTodo;
  const UserListPage(
      {super.key, required this.currentEmail, required this.selectedTodo});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<UserOnDb> _users = [];

  Future<List<Todo>> fetchOtherTodos(String uid) async {
    List<Todo> otherTodos = [];
    CollectionReference collectionRef = db.collection('users');
    DocumentReference docRef = collectionRef.doc(uid);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          (doc.data() as Map<String, dynamic>)['otherTodos']
              .forEach((e) => otherTodos.add(Todo(e['uuid'], e['content'])));
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return otherTodos;
  }

  void fetchUsers() {
    CollectionReference collectionRef = db.collection('users');
    collectionRef.get().then(
      (QuerySnapshot snapshot) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          setState(() {
            String email = (doc.data() as Map<String, dynamic>)['email'];
            if (email != widget.currentEmail) {
              _users.add(UserOnDb(email, doc.id));
            }
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // AppBarを表示し、タイトルも設定
          appBar: AppBar(
            title: const Text('ユーザー一覧'),
          ),
          body: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: InkWell(
                              onTap: () async {
                                List<Todo> currentOtherTodos =
                                    await fetchOtherTodos(_users[index].uid);
                                await db
                                    .collection("users")
                                    .doc(_users[index].uid)
                                    .set({
                                  'otherTodos': [
                                    ...currentOtherTodos.map((e) => e.toMap()),
                                    widget.selectedTodo.toMap()
                                  ],
                                }, SetOptions(merge: true)).onError((e, _) =>
                                        print("Error writing document: $e"));
                                if (mounted) Navigator.of(context).pop();
                              },
                              child: Card(
                                child:
                                    ListTile(title: Text(_users[index].email)),
                              ))),
                    ]);
              }),
        ));
  }
}
