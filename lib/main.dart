import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      home: const SignUpPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: const Text('リスト一覧'),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(title: Text(todos[index])),
            );
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: Container(
          padding: const EdgeInsets.all(64),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'email'),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'password(6文字以上)'),
                  onChanged: (value) {
                    setState(() {
                      password = value;
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
                    child: const Text('submit'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result =
                            await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final User user = result.user!;
                        print(user);
                      } catch (e) {
                        setState(() {
                          msg = e.toString();
                        });
                        return;
                      }
                      if (!mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TodoListPage()));
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    msg,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ]),
        ));
  }
}
