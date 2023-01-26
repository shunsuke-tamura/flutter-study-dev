// リスト一覧画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_dev/todo.dart';

class UserOnDb {
  final String email, uid;
  UserOnDb(this.email, this.uid);

  Map<String, String> toMap() {
    return {'email': email, 'uid': uid};
  }
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

  Future<List<UserOnDb>> fetchMembers() async {
    List<UserOnDb> members = [];
    CollectionReference collectionRef = db.collection('chatRooms');
    DocumentReference docRef = collectionRef.doc(widget.selectedTodo.uuid);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        setState(() {
          (doc.data() as Map<String, dynamic>)['members']
              .forEach((e) => members.add(UserOnDb(e['email'], e['uid'])));
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return members;
  }

  void fetchUsers() async {
    List<UserOnDb?> currentMembers = await fetchMembers();
    CollectionReference collectionRef = db.collection('users');
    QuerySnapshot<Object?> snapshot = await collectionRef.get();
    List<QueryDocumentSnapshot<Object?>> docs = snapshot.docs;
    for (var doc in docs) {
      bool isExist = false;
      for (var e in currentMembers) {
        if (e?.uid == doc.id) {
          isExist = true;
          break;
        }
      }
      if (!isExist) {
        String email = (doc.data() as Map<String, dynamic>)['email'];
        setState(() {
          _users.add(UserOnDb(email, doc.id));
        });
      }
    }
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
                                List<UserOnDb> currentMembers =
                                    await fetchMembers();
                                await db
                                    .collection("chatRooms")
                                    .doc(widget.selectedTodo.uuid)
                                    .set({
                                  'members': [
                                    ...currentMembers.map((e) => e.toMap()),
                                    _users[index].toMap()
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
