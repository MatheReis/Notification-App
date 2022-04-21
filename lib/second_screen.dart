// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:notifications_app/main.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: RaisedButton(
          splashColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  title: 'First Screen',
                ),
              ),
            );
          },
          child: const Text('First Screen'),
        ),
      ),
    );
  }
}
