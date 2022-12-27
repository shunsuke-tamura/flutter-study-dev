import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // 背景色
                color: Colors.blue,
                child: const Text('blue'),
              ),
              Container(
                // 横幅
                width: 200,
                // 縦幅
                height: 50,
                color: Colors.blue,
                child: const Text('200x50'),
              ),
              Container(
                // 内側の余白
                padding: const EdgeInsets.all(8),
                color: Colors.blue,
                child: const Text('padding'),
              ),
              Container(
                color: Colors.blue,
                child: Container(
                  // 外側の余白
                  margin: const EdgeInsets.all(8),
                  color: Colors.green,
                  child: const Text('margin'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  // 枠線
                  border: Border.all(color: Colors.blue, width: 2),
                  // 角丸
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Text('border'),
              ),
              Container(
                decoration: const BoxDecoration(
                  // 背景画像
                  image: DecorationImage(
                    // chromeで`--web-renderer html`をつけないと表示されない
                    image: NetworkImage('https://placehold.jp/200x100.png'),
                  ),
                ),
                width: 200,
                height: 100,
                child: const Text('image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
