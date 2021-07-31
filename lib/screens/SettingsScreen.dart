import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: new Stack(
        children: [Text('TODO')],
      ),
    );
  }
}
