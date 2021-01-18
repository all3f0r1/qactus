import 'package:Qactus/screens/HomePageScreen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(Qactus());
}

class Qactus extends StatefulWidget {
  @override
  _QactusState createState() => _QactusState();
}

class _QactusState extends State<Qactus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qactus',
      home: SafeArea(child: HomePageScreen()),
    );
  }
}
