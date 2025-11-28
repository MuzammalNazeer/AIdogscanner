import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Scaffold;

class Profileview extends StatefulWidget {
  const Profileview({super.key});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          Text("activity ")
        ],
      )),
    );
  }
}
