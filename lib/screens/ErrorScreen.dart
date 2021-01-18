import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("ERROR"),
      content: Text("Sorry, something went wrong..."),
      actions: [
        FlatButton(
          child: Text("Exit"),
          onPressed: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        ),
      ],
    );
  }
}
