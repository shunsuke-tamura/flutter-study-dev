import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> listItems = [
    {
      'text': 'Item 1',
      'color': Colors.blue[600],
    },
    {
      'text': 'Item 2',
      'color': Colors.blue[300],
    },
    {
      'text': 'Item 3',
      'color': Colors.blue[100],
    },
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: 125,
              padding: const EdgeInsets.all(4),
              // childrenを指定してリスト表示
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.blue[600],
                    child: const Text('Item 1'),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[300],
                    child: const Text('Item 2'),
                  ),
                  Container(
                    height: 50,
                    color: Colors.blue[100],
                    child: const Text('Item 3'),
                  ),
                ],
              ),
            ),
            Container(
              height: 125,
              padding: const EdgeInsets.all(4),
              // 配列を元にリスト表示
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    color: listItems[index]['color'],
                    child: Text(listItems[index]['text']),
                  );
                },
              ),
            ),
            Container(
              height: 125,
              padding: const EdgeInsets.all(4),
              // 各アイテムの間にスペースなどを挟みたい場合
              child: ListView.separated(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    color: listItems[index]['color'],
                    child: Text(listItems[index]['text']),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
            // タイトル・サブタイトル・画像・アイコン等を含めたアイテムが作れる
            ListTile(
              leading: Image.network('https://placehold.jp/50x50.png'),
              title: const Text('ListTile'),
              subtitle: const Text('subtitle'),
              trailing: const Icon(Icons.more_vert),
            ),
            // 影のついたカードUIが作れる
            const Card(
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Text('Card'),
              ),
            ),
            // 組み合わせることもOK
            Card(
              child: ListTile(
                leading: Image.network('https://placehold.jp/50x50.png'),
                title: const Text('Card and ListTile'),
                subtitle: const Text('subtitle'),
                trailing: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
