import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void PageChangeCallback(int page);

class BottomMenu extends StatefulWidget {
  final Color btnColor = Color.fromRGBO(232, 8, 50, 1);
  final Color btnTextColor = Colors.black;
  final Color btnColorDisabled = Colors.white;
  final Color btnTextColorDisabled = Colors.white;

  final PageChangeCallback callback;

  BottomMenu({this.callback});

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          RaisedButton(
            color: _currentPage > 1 ? widget.btnColor : widget.btnColorDisabled,
            textColor: _currentPage > 1
                ? widget.btnTextColor
                : widget.btnTextColorDisabled,
            elevation: _currentPage > 1 ? 1 : 0,
            child: Text("<--"),
            onPressed: () {
              if (_currentPage > 1) {
                _currentPage--;
                widget.callback(_currentPage);
              }
            },
          ),
          Text("Page $_currentPage"),
          RaisedButton(
            color:
                _currentPage < 100 ? widget.btnColor : widget.btnColorDisabled,
            textColor: _currentPage < 100
                ? widget.btnTextColor
                : widget.btnTextColorDisabled,
            elevation: _currentPage < 100 ? 1 : 0,
            child: Text("-->"),
            onPressed: () {
              if (_currentPage < 100) {
                _currentPage++;
                widget.callback(_currentPage);
              }
            },
          ),
        ],
      ),
    );
  }
}
