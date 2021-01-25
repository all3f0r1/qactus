import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final _animationController = AnimationController();

  void initState() {
    _animationController.drive(
      ColorTween(
        begin: Colors.red,
        end: Colors.blue,
      ),
    );
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/loading.png"),
          CircularProgressIndicator(
              // TODO: can we describe what's going on?
              ),
        ],
      ),
    );
  }
}
