import 'package:flutter/material.dart';

class Activitesview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Activitesview({super.key, this.onShowSnackBar});

  @override
  State<Activitesview> createState() => _ActivitesviewState();
}

class _ActivitesviewState extends State<Activitesview> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          Text("activity ")
        ],
      )),
    );
  }
}
