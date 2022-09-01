import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key, required this.error}) : super(key: key);
  String? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: Column(
            children: [
              const Text("Something Went Wrong, find the details below:"),
              Text(error.toString())
            ],
          ),
        ));
  }
}
