import 'package:Qactus/screens/HomePageScreen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(Qactus());
}

class Qactus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qactus',
      home: SafeArea(child: HomePageScreen()),
    );
  }
}
