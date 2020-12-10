import 'package:flutter/material.dart';

import 'Settings.dart';
import 'myprofile.dart';
import 'mywallet.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(

        body: [
          MyProfile(),
          MyWallet(),
          Settings(),

        ].elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff000000),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('MY PROFILE'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              title: Text('  MY WALLET'),
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.settings),
              title: Text(' SETTINGS '),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xffffd800),
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
        ),

      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); //Will exit the App
              },
            )
          ],
        );
      },
    ) ?? false;
  }

}
