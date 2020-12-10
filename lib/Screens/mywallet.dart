import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qsnap/Screens/qrcodeee.dart';

// import 'package:qsnaps/Screens/qrcodeee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'Home.dart';

// import 'WalletDescraption.dart';
import 'WalletDescraption.dart';
import 'addqsnap.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
       print("ssssssid-----" + id);
    });
  }

  Future<List<User>> _getlistcontacts() async {
    var url = 'http://qsnap.net/api/getCustomerContacts?customerId=$id';
    var response = await http.get(url);
    var responsbody = json.decode(response.body)["response"]["contacts"];
     print(responsbody);
    List<User> list = [];
    for (var u in responsbody) {
      User x = User(u["id"], u["fname"], u["lname"], u["image"], u["edit"]);
      list.add(x);
    }

    for (var c in list) {
      print(c.fname);
    }

     print("ssssssssssssssssss$list");
    return list;
  }

  @override
  void initState() {
    super.initState();
    this.getid();
    this._getlistcontacts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQsnap()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.camera_enhance,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => qecoode()),
              );
            },
          ),
        ],
//        toolbarHeight: 65,
        title: Text("MY WALLET"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: FutureBuilder(
            future: _getlistcontacts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
               print(snapshot.data);
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading...")));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Card(
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              WalletDescraption(
                                                  snapshot.data[i].id,
                                                  snapshot.data[i].edit)));
                                },
                                title:
                                Container(
                                  height: 50.0,
                                  width: 50.5,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                    image: new DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                        snapshot.data[i].image,                                      ),
                                    ),
                                    border:
                                    Border.all(color: const Color(0xffffd800), width: 3),

                                  ),


                                ),

                                // Container(
                                //
                                //   height: 60,
                                //   width: 60,
                                //   decoration: new BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //         color: const Color(0xffffd800),
                                //         width: 3),
                                //     // image: new Image.asset(_image.)
                                //   ),
                                //   child: CircleAvatar(
                                //     backgroundColor: Colors.black,
                                //     child: Image.network(
                                //       snapshot.data[i].image,
                                //       height: 60.0,
                                //       width: 60.0,
                                //     ),
                                //   ),
                                // ),
                                subtitle: Container(
                                  padding: EdgeInsets.only(top: 3, bottom: 10),
                                  child: Text(
                                    snapshot.data[i].fname +
                                        " " +
                                        snapshot.data[i].lname,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xffffd800),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      // return ListTile(
                      //   title: Text(snapshot.data[i].fname+" "+snapshot.data[i].fname),
                      //   leading: CircleAvatar(
                      //     backgroundImage: NetworkImage(
                      //         snapshot.data[i].image),
                      //   ),
                      // );
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => WalletDescraption()),
                      //     );
                      //   },
                      //
                      // );
                    });
              }
            }),

        // ListView(
        //   children: [

        //
        //
        //
        //   ],
        // ),
      ),
    );
  }
}

class User {
  var id;
  var fname;
  var lname;
  var image;
  var edit;
  User(this.id, this.fname, this.lname, this.image, this.edit);
}
