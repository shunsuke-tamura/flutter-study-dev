import 'package:flutter/material.dart';

void main() {
  // 最初に表示するWidget
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
      // リスト一覧画面を表示
      home: const TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: const Text('リスト一覧'),
      ),
      body: ListView(children: const <Widget>[
        Card(
            child: ListTile(
          title: Text('リスト一覧画面'),
        )),
        Card(
            child: ListTile(
          title: Text('リスト一覧画面'),
        )),
        Card(
            child: ListTile(
          title: Text('リスト一覧画面'),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return const TodoAddPage();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatelessWidget {
  const TodoAddPage({super.key});

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
                const TextField(),
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
                      Navigator.of(context).pop();
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
