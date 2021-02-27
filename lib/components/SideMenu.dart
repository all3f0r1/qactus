import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info/package_info.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/appstore.png",
                    width: 100,
                  ),
                  Text(
                    'L\'INFORMATEUR.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Color.fromRGBO(237, 28, 36, 1),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "Options",
                style: _drawerFontStyle(),
              ),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "A propos",
                style: _drawerFontStyle(),
              ),
              leading: Icon(Icons.alternate_email),
              onTap: () {
                PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AboutDialog(
                        applicationName: "Qactus",
                        applicationVersion: packageInfo.version +
                            " build number " +
                            packageInfo.buildNumber,
                        applicationIcon: Image.asset(
                          "assets/appstore.png",
                          width: 100.0,
                          height: 100.0,
                        ),
                        children: [
                          Text(
                              "Un avis? Une suggestion? Juste quelque chose à me dire?"),
                          RaisedButton(
                            onPressed: () async {
                              final Email email = Email(
                                subject: 'App Qactus',
                                recipients: ['tournai.alexandre@gmail.com'],
                                isHTML: false,
                              );
                              await FlutterEmailSender.send(email);
                            },
                            child: Text("Contactez-moi"),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _drawerFontStyle() {
    return TextStyle(
      fontSize: 18,
      color: Color.fromRGBO(119, 119, 119, 1),
    );
  }
}
