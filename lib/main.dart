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
        body: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.grey[200],
              child: Row(
                // 横に並べる
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('first')),
                  Container(color: Colors.blue, child: const Text('second')),
                  Container(color: Colors.green, child: const Text('third')),
                ],
              ),
            ),
            SizedBox(
              // colorを指定しない時はSizeBoxでOKらしい
              width: double.infinity,
              height: 60,
              child: Row(
                // 中央寄せ
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('***')),
                  Container(color: Colors.blue, child: const Text('中央寄せ')),
                  Container(color: Colors.green, child: const Text('---')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.grey[200],
              child: Row(
                // 右寄せ
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('***')),
                  Container(color: Colors.blue, child: const Text('右寄せ')),
                  Container(color: Colors.green, child: const Text('---')),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Row(
                // 均等配置
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('***')),
                  Container(color: Colors.blue, child: const Text('均等配置')),
                  Container(color: Colors.green, child: const Text('---')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.grey[200],
              child: Row(
                // 上寄せ
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('***')),
                  Container(color: Colors.blue, child: const Text('上寄せ')),
                  Container(color: Colors.green, child: const Text('---')),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Row(
                // 下寄せ
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(color: Colors.red, child: const Text('***')),
                  Container(color: Colors.blue, child: const Text('下寄せ')),
                  Container(color: Colors.green, child: const Text('---')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
