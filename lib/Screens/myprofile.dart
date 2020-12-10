import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qsnap/Screens/qrcodeimg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Editprofile.dart';
import 'mywallet.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      // print("ssssssid-----"+id);
    });
  }

  var fname,
      lname,
      email,
      mobile,
      nationality,
      country_name,
      city_name,
      image,
      qrcode,
      dob,
      job_title,
      company,
      phone;

  Future _getuser() async {
    var url = 'http://qsnap.net/api/getProfile?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["customer"];
    if (responsbody["status"] == 200) {
      setState(() {
        fname = data["fname"];
        lname = data["lname"];
        email = data["email"];
        mobile = data["mobile"];
        dob = data["dob"];
        job_title = data["job_title"];
        company = data["company"];
        country_name = data["country_name"];
        city_name = data["city_name"];
        image = data["image"];
        qrcode = data["qrcode"];
        phone = data["phone"];
        nationality = data["nationality"];
        // print("id------>$nationality");
      });
    }
    // print(responsbody);
    return "Sucess";
  }

  @override
  void initState() {
    this.getid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        toolbarHeight: 55,
        title: Image.asset('assats/images/logowhite.png',
            height: 45.0, fit: BoxFit.cover),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => qrcodeimg(qrcode)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getuser(),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (snapshot.data == null) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.yellow,
              ));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Stack(
//          alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(top: 65.0),
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffffd800), width: 3.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    Column(
                      children: [
                        Center(
                          child: image == null
                              ? Container(
                                  height: 90.0,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            "assats/images/profilee.png")),
                                    border: Border.all(
                                        color: const Color(0xffffd800),
                                        width: 3),
                                  ),
                                )
                              : Container(
                                  height: 90.0,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffffd800),
                                    image: new DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: NetworkImage(
                                        image,
                                      ),
                                    ),
                                    border: Border.all(
                                        color: const Color(0xffffd800),
                                        width: 3),
                                  ),
                                ),
                        ),
                        ListTile(
                          title: Text(
                            "FIRST NAME",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            fname,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "LAST NAME",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            lname,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "COUNTRY",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            country_name,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "CITY",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            city_name,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "NATIONALITY",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            nationality,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "DATE OF BIRTH",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            dob,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "COMPANY",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            company,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "JOB TITLE",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            job_title,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "MOBILE",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            mobile,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "HOME",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            phone,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(0xff000000),
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Editprofile()),
                              );
//          Navigator.pop(context);
                            },
                          ),
                        ),
                        // Row(
                        //   children: [
                        //
                        //     Text(
                        //       "Edit",
                        //       style: TextStyle(
                        //         color: Color(0xff000000),
                        //         fontSize: 18,
                        //       ),
                        //     ),
                        //     // Padding(
                        //     //   padding: const EdgeInsets.only(bottom: 10.0),
                        //     //   child: Image.network(
                        //     //     qrcode,
                        //     //     height: 70,
                        //     //     width: 90,
                        //     //   ),
                        //     // )
                        //   ],
                        // )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
