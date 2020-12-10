import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:qsnap/model/alligator.dart';
import 'package:share/share.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Editqsnap.dart';
import 'Home.dart';
import 'addqsnap.dart';
import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletDescraption extends StatefulWidget {
  var id, edit;

  WalletDescraption(this.id, this.edit);

  @override
  _WalletDescraptionState createState() => _WalletDescraptionState();
}

class _WalletDescraptionState extends State<WalletDescraption> {
// var idd= widget.id;
  var fname = " ";
  var lname = " ";
  var email;
  var mobile = " ";
  var country_name = " ";
  var city_name = " ";
  var image ;
  var qrcode;
  var dob = " ";
  var job_title = " ";
  var company = " ";
  var phone = "No Number";
  bool visible = false;

  Future _getuser() async {
    // print(widget.edit);
    // print(widget.id);
    var url ='http://qsnap.net/api/getContactById?id=${widget.id}&edit=${widget.edit}';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["contact"];
    // print('Response convert data:============>  ${data}');

    if (responsbody["status"] == 200) {
      setState(() {
        // print("companycompanycompanycompany--------" + data["company"]);
        // print("companycompanycompanycompany--------" + data["qrcode"]);
        // print("companycompanycompanycompany--------" + data["image"]);
        // print("companycompanycompanycompany--------" + data["email"]);
        fname = data["fname"];
        lname = data["lname"];
        mobile = data["mobile"];
        phone = data["phone"];
        dob = data["dob"];
        job_title = data["job_title"];
        company = data["company"];
        country_name = data["nationality"];
        qrcode = data["qrcode"];
        email = data["email"];
        image = data["image"];
      });
    }
    // print(responsbody);
    return "Sucess";
  }
  Future _deletuser() async {
    // print(widget.edit);
    // print(widget.id);
    var url ='http://qsnap.net/api/deleteCustomerContact?id=${widget.id}&edit=${widget.edit}';
    // print(url);
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    // print('Response status: ${response.statusCode}');
    if (responsbody["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    // print(responsbody);
    return "Sucess";
  }

  @override
  void initState() {
    if(widget.edit==1){
      visible=true;
    }
    super.initState();
  }

  String url = "https://picsum.photos/250?image=9";
  List<Alligator> alligators = [
    Alligator("https://picsum.photos/250?image=9"),
  ];

  String _text = '';
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> saveContactInPhone() async {
    try {
      // print("saving Conatct");
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = fname+" "+lname;
          newContact.emails = [Item(label: "email", value: email)];
          newContact.phones = [Item(label: "mobile", value: mobile)];
          _showvrfieAlert(context);
          await ContactsService.addContact(newContact);
        } else {


          //_handleInvalidPermissions(context);
        }
      } else {
        Contact newContact = new Contact();
        newContact.givenName = fname+" "+lname;
        newContact.emails = [Item(label: "email", value: email)];
        newContact.phones = [Item(label: "mobile", value: mobile)];
        _showvrfieAlert(context);
        await ContactsService.addContact(newContact);
      }
      // print("object");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _makeSmS(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // _getuser();
    // print("================>");
    // print(widget.edit);
    // print(widget.id);


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
            Navigator.pop(context);
          },
        ),
//        toolbarHeight: 65,
        title: Text(fname+" "+lname),
        actions: [
          Visibility(
            visible: visible,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Color(0xffffd800),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditQsnap(
                          widget.id, widget.edit)),
                );
              },
            ),
          ),

        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: _getuser(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                  ));
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,vertical: 10),
                    child: Stack(
//          alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.only(top: 80.0),
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                              color: Color(0xff000000),
                              border: Border.all(
                                  color: Color(0xff000000), width: 3.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        Column(
                          children: [
                            Container(
                              height:100.0,
                              width: double.infinity,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xffffd800), width: 3),
// image: new Image.asset(_image.)
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Image.network(
                                  image,
                                  height: 70.0,
                                  width: 70.0,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "FIRST NAME",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                fname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "LAST NAME",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                lname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "NATIONALITY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                country_name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "DATE OF BIRTH",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                dob,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "COMPANY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                company,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "JOB TITLE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                job_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "MOBILE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                mobile,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "HOME",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                phone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "EMAIL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     // Visibility(
                            //     //   visible: visible,
                            //     //   child: GestureDetector(
                            //     //     onTap: () {
                            //     //       Navigator.push(
                            //     //         context,
                            //     //         MaterialPageRoute(
                            //     //             builder: (context) => EditQsnap(
                            //     //                 widget.id, widget.edit)),
                            //     //       );
                            //     //     },
                            //     //     child: RichText(
                            //     //       text: TextSpan(
                            //     //         children: [
                            //     //           WidgetSpan(
                            //     //             child: Padding(
                            //     //               padding:
                            //     //                   const EdgeInsets.symmetric(
                            //     //                       horizontal: 10.0),
                            //     //               child: Icon(
                            //     //                 Icons.edit,
                            //     //                 color: Color(0xffffd800),
                            //     //                 size: 20,
                            //     //               ),
                            //     //             ),
                            //     //           ),
                            //     //           TextSpan(
                            //     //             text: 'Edit',
                            //     //             style: TextStyle(
                            //     //               color: Color(0xffffd800),
                            //     //               fontSize: 18,
                            //     //             ),
                            //     //           ),
                            //     //         ],
                            //     //       ),
                            //     //     ),
                            //     //   ),
                            //     // ),
                            //     // IconButton(
                            //     //
                            //     //   icon: Icon(
                            //     //     Icons.edit,
                            //     //     color: Color(0xffffd800),
                            //     //     size: 18,
                            //     //   ),
                            //     //   onPressed: () {
                            //     //     Navigator.push(
                            //     //       context,
                            //     //       MaterialPageRoute(
                            //     //           builder: (context) => EditQsnap(widget.id,widget.edit)),
                            //     //     );
                            //     //   },
                            //     // ),
                            //     // Text(
                            //     //   "Edit",
                            //     //   style: TextStyle(
                            //     //     color: Color(0xffffd800),
                            //     //     fontSize: 18,
                            //     //   ),
                            //     // ),
                            //   ],
                            // )
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 40.0),
                              child: Image.network(
                                qrcode,
                                height: 75,
                                width: 80,
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  );
                }
              })),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.black,
        closedBackgroundColor: Colors.yellow,
        openBackgroundColor: Colors.yellow,
//        labelsStyle:BlendMode.color(Colors.yellow) ,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.add_circle_outline),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: "Add to Contacts",
            onPressed: () {

              saveContactInPhone();
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.markunread),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Message',
            onPressed: () => setState(() {
              _launched = _makePhoneCall('sms:$mobile');
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.call),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Call',
            onPressed: () => setState(() {
              _launched = _makePhoneCall('tel:$mobile');
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.share),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Share',
            onPressed: () => share(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.delete),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Delete',
            onPressed: () {
              _deletuser();
            },
          ),
          // SpeedDialChild(
          //   child: Icon(Icons.settings),
          //   foregroundColor: Colors.black87,
          //   backgroundColor: Colors.white,
          //   label: 'Edit Qsnap',
          //   onPressed: () {
          //     setState(() {
          //
          //     });
          //   },
          // ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();

    Share.share("$image ",
        subject: image,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

}
_showvrfieAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("The contact has been added successfully.",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
      actions: <Widget>[
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