import 'package:authentications/screens/authentication%20page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthenticationUI()));
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: (
          Center(
        child: const Text("Home Page"),
      )),
    );
  }
}
