import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'todo.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen),
                          child: const Text('Sigin Up'),
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
                        )),
                    const SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Sigin In'),
                          onPressed: () async {
                            try {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final UserCredential result =
                                  await auth.signInWithEmailAndPassword(
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
                        )),
                  ],
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