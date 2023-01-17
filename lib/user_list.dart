// リスト一覧画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserOnDb {
  final String email;
  UserOnDb(this.email);
}

class UserListPage extends StatefulWidget {
  final String currentEmail;
  const UserListPage({super.key, required this.currentEmail});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<UserOnDb> _users = [];

  void fetchUsers() {
    CollectionReference collectionRef = db.collection('users');
    collectionRef.get().then(
      (QuerySnapshot snapshot) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          setState(() {
            String email = (doc.data() as Map<String, dynamic>)['email'];
            if (email != widget.currentEmail) _users.add(UserOnDb(email));
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
                              onTap: () {
                                print(_users[index]);
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
