import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // TODO: find out a way to be more explicit
      title: Text("ERREUR"),
      content: Text("Quelque chose s'est mal passé..."),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          child: Text("Fermer"),
          onPressed: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        ),
      ],
    );
  }
}
