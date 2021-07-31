import 'package:Qactus/components/DeactivableButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void PageChangeCallback(int page);

class BottomMenu extends StatefulWidget {
  BottomMenu({required this.callback}) : super();
  final Color btnColor = Colors.white;
  final Color btnTextColor = Colors.black;

  final PageChangeCallback callback;

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int?> _currentPage;
  int _lastKnownPage = 1;

  @override
  initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      prefs.setInt('currentPage', 1);
    });
    _currentPage = _getCurrentPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _currentPage,
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        // The following block is to prevent flickering
        // from rebuilding this whole widget
        int currentPage;
        snapshot.connectionState == ConnectionState.done
            ? currentPage = snapshot.data!
            : currentPage = _lastKnownPage;
        _lastKnownPage = currentPage;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              DeactivatableButton(
                isDeactivated: currentPage <= 1,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: widget.btnColor,
                  textColor: widget.btnTextColor,
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    _decCurrentPage(currentPage);
                    widget.callback(currentPage - 1);
                  },
                ),
              ),
              Text("Page " + currentPage.toString()),
              // TODO: hardcoded value "100", change it to be dynamic (if possible at all)
              // DeactivatableButton(
              //   isDeactivated: currentPage >= 100,
              //   child: RaisedButton(
              //     color: widget.btnColor,
              //     textColor: widget.btnTextColor,
              //     child: Icon(Icons.arrow_forward),
              //     onPressed: () {
              //       _incCurrentPage(currentPage);
              //       widget.callback(currentPage + 1);
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<int?> _getCurrentPage() async {
    return await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('currentPage');
    });
  }

  _decCurrentPage(int page) {
    setState(() {
      _currentPage = _prefs.then((SharedPreferences prefs) {
        prefs.setInt('currentPage', page - 1);
        return page - 1;
      });
    });
  }
}
