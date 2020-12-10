import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class EditQsnap extends StatefulWidget {
  var id, edit;

  EditQsnap(this.id, this.edit);

  @override
  _EditQsnapState createState() => _EditQsnapState();
}

class _EditQsnapState extends State<EditQsnap> {
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
  var fname, lname, mobile, job_title, company, phone;
  var dob = "";
  var image = "";

  Future _getuser() async {
    var url =
        'http://qsnap.net/api/getContactById?id=${widget.id}&edit=${widget.edit}';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["contact"];
    if (responsbody["status"] == 200) {
      setState(() {
        _fnameController.text = data["fname"];
        _lnameController.text = data["lname"];
        _mobileController.text = data["mobile"];
        _phoneController.text = data["phone"];
        _jobtitleController.text = data["job_title"];
        _companyController.text = data["company"];
        _nationalityController.text = data["nationality"];
        _emailController.text = data["email"];
        dob = data["dob"];
        image = data["image"];
      });
    }
    print(responsbody);
    return "Sucess";
  }

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
      String email
      ) async {
    print("im in fun update edit------------>");

    String updetUrl = "http://qsnap.net/api/updateContact";
    var response = await http.post(updetUrl, body: {
      "id": widget.id,
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
    if (result["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  void initState() {
    this._getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getuser();
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
        title: Text("EDIT QSNAP"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Stack(
//          alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(top: 40.0),
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
                          ? new Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                              color: Color(0xffffd800), width: 5.0),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(80.0)),
                        ),
                      )
                          : new Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: new BoxDecoration(
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
//
//                    },
//                    child: Container(
//                      height: 80.0,
//                      width: double.infinity,
//
//                      decoration: new BoxDecoration(
//                        image: DecorationImage(
//                            image: FileImage(
//                              imageFile),
//                            fit: BoxFit.fill
//                        ),
//                        shape: BoxShape.circle,
//                        border:
//                            Border.all(color: const Color(0xffffd800), width: 3),
//                        // image: new Image.asset(_image.)
//                      ),
//                      child: CircleAvatar(
//                      child: imageFile == null
//                      ? Image.asset(
//                          "assats/images/logowhite.png",
//                          height: 50.0,
//                          width: 50.0,
//                        ):
//                      Image.file(
//                        imageFile,
//                        height: 50.0,
//                        width: 50.0,
//                        fit: BoxFit.cover,
//                      ),
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
                        hintText: "Nationality",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Nationality';
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
                      padding: const EdgeInsets.only(left: 10.0, top: 5),
                      child: Text(
                        dobfun(),
                        // "${selectedDate.toLocal()}".split(' ')[0],
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
                    height: 50,
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
                            "EDIT",
                            style:
                            TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                          onPressed: () {
                            print("im in fun onPressed------------>");
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Text("Loading..")
                                );
                              },
                            );

                            dob=selectedDate.toString();
                            updatprfile(
                              _fnameController.text,
                              _lnameController.text,
                              _nationalityController.text,
                              dob,
                              _companyController.text,
                              _jobtitleController.text,
                              _mobileController.text,
                              _phoneController.text,
                              _emailController.text,
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
        print("imageFile----------------------------->$imageFile");
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
        print("imageFile----------------------------->$imageFile");
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);

      });
    }
  }
  String dobfun() {
    if (selectedDate == DateTime(2010, 1, 1)) {
      return dob;
    } else {
      return "${selectedDate.toLocal()}".split(' ')[0];
    }
  }
}
