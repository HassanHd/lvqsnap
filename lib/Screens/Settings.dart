import 'package:flutter/material.dart';
import 'AboutSnab.dart';
import 'Alerts.dart';
import 'Home.dart';
import 'Privacy policy.dart';
import 'faq.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginscreen.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String os = Platform.operatingSystem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
//        toolbarHeight: 65,
        title: Text("SETTINGS"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutQsnap()),
                  );
                },
                title: Text(
                  "ABOUT QSNAP",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.error_outline,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                title: Text(
                  "SHARE APP",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.share,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Alerts()),
                  );
                },
                title: Text(
                  "ALERTS",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.add_alert,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  _showConfirmationAlert(context);
                },
                title: Text(
                  "UPGRADE TO GOLD",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.file_upload,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivcyPolicy()),
                  );
                },
                title: Text(
                  "PRIVACY POLICY",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.security,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  // Or, use a predicate getter.
                  if (Platform.isIOS) {
                    print('is a IOS');
                    _showToast(context);
                  } else if (Platform.isAndroid) {
                    print('is a Andriod');
                    _showToast(context);
                  } else {}
                },
                title: Text(
                  "RATE US",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.rate_review,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQ()),
                  );
                },
                title: Text(
                  "FAQ",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                title: Text(
                  "LOGOUT",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Color(0xffffd800),
                  size: 30,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "V1.0.0",
                style: TextStyle(
                    color: Color(0xffffd800),
                    // color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('im in android'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " UPGRADE TO GOLD",
        style: TextStyle(
          color: Color(0xffffd800),
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Coming Soon.",
        style: TextStyle(fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        BasicDialogAction(
          title: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
