// リスト一覧画面用Widget
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final _users = ['hoge', 'fuga', 'piyo'];
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
                                child: ListTile(title: Text(_users[index])),
                              ))),
                    ]);
              }),
        ));
  }
}
