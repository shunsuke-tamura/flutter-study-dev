import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

// StatefulWidgetを継承するとStateを扱える
// このWidgetを表示すると、Stateを元にUIが作成される
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  // 使用するStateを指定
  @override
  MyWidgetState createState() => MyWidgetState();
}

// Stateを継承して使う
class MyWidgetState extends State<MyWidget> {
  // データを宣言
  int count = 0;

  // データを元にWidgetを作る
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(count.toString()),
        TextButton(
          onPressed: () {
            // データを更新する時は setState を呼ぶ
            setState(() {
              // データを更新
              count = count + 1;
            });
          },
          child: const Text('カウントアップ'),
        ),
      ],
    );
  }
}
