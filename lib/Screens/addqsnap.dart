import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class AddQsnap extends StatefulWidget {
  @override
  _AddQsnapState createState() => _AddQsnapState();
}

class _AddQsnapState extends State<AddQsnap> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
    });
  }

  DateTime selectedDate = DateTime(2010, 1, 1);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 1),
      lastDate: DateTime(2010),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _getFromGallery();
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _getFromCamera();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  // Variables
  File imageFile;
  var base64Image="";
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  //updatprfile
  void updatprfile(
      String fname,
      String lname,
      String nationality,
      String dob,
      String company,
      String job_title,
      String mobile,
      String phone,
      String id,
      String email) async {
    print(dob);
    print("im in fun add------------>");

    String updetUrl = "http://qsnap.net/api/addToContact";
    var response = await http.post(updetUrl, body: {
      "customerId": id,
      'fname': fname,
      'lname': lname,
      'nationality': nationality,
      'dob': dob,
      'company': company,
      'job_title': job_title,
      'mobile': mobile,
      'phone': phone,
      'email': email,
      'image': base64Image,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
      print("done edit______------>200");
    }
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
        title: Text("ADD QSNAP"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Stack(
//          alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 20,
                margin: const EdgeInsets.only(top: 50.0),
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    color: Color(0xff000000),
                    border: Border.all(color: Color(0xff000000), width: 3.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _showSelectionDialog(context),
                    child: Center(
                      child: imageFile == null
                          ? Stack(
                              children: [
                                new Center(
                                  child: new CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: const Color(0xFF000000),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: new Center(
                                    child: Icon(
                                      Icons.camera_enhance,
                                      color: Color(0xffffd800),
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : new Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: new DecorationImage(
                                  image: new FileImage(imageFile),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                    color: Color(0xffffd800), width: 5.0),
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(80.0)),
                              ),
                            ),
                    ),
                  ),
//                  InkWell(
//                    onTap: () {
//                      _showSelectionDialog(context);
//                    },
//                    child: Container(
//                      height: 80.0,
//                      width: double.infinity,
//                      decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                        border:
//                        Border.all(color: const Color(0xffffd800), width: 3),
//                        // image: new Image.asset(_image.)
//                      ),
//                      child: CircleAvatar(
//                        child: imageFile == null
//                            ? Image.asset(
//                          "assats/images/logowhite.png",
//                          height: 50.0,
//                          width: 50.0,
//                        ):
//                        Image.file(
//                          imageFile,
//                          height: 50.0,
//                          width: 50.0,
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                    ),
//                  ),
                  ListTile(
                    title: Text(
                      "FIRST NAME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _fnameController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black87,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          hintText: "First Name",
                          hoverColor: Colors.white60),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "LAST NAME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _lnameController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffffd800)),
                          ),
                          hintText: "Last Name"),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "NATIONALITY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nationalityController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: "Nationalty",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Nationalty';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _selectDate(context);
                    },
                    title: Text(
                      "DATE OF BIRTH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left:10.0,top: 5.0),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: Color(0xffffd800),
                      size: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Divider(
                      height: 1,
                      indent: 15.0,
                      endIndent: 15.0,
                      thickness: 1,
                      color: Color(0xffffd800),
                    ),
                  ),

                  ListTile(
                    title: Text(
                      "COMPANY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _companyController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: "Company",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Company';
                        }
                        return null;
                      },
                    ),
                  ),

                  ListTile(
                    title: Text(
                      "JOB TITLE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _jobtitleController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: "Job Title",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Job Title';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "MOBILE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: " Mobile",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Mobile';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "HOME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: " Home",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter home';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "EMAIL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffd800)),
                        ),
                        hintText: " Email",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                          color: Color(0xffffd800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "ADD",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                          onPressed: () {
                            print("im in fun onPressed------------>");
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return
                                  Text("Loading..");
                              },
                            );
                            updatprfile(
                                _fnameController.text,
                                _lnameController.text,
                                _nationalityController.text,
                                selectedDate.toString(),
                                _companyController.text,
                                _jobtitleController.text,
                                _mobileController.text,
                                _phoneController.text,
                                id.toString(),
                                _emailController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home()),
                            );
                          }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      });
    }
  }
}
