import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';



class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("id--------------------" + id);
      _getuser();
    });
  }

  String _dropDownValue;
  String _dropDownkey;
  List data = List();

  Future<String> _getcountry() async {
    var url = 'http://qsnap.net/api/getCountries';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      data = responsbody;
    });
    // print(responsbody);
    return "Sucess";
  }

  String _dropDownValuecity;
  List datacity = List();

  Future<String> fetchcity(String code) async {
    var url = 'http://qsnap.net/api/getCitiesByCountry?countryCode=$code';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      datacity = responsbody;
    });

    // print(responsbody);
    return "Sucess";
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

  /// Variables
  File imageFile;
  var base64Image;
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var fname, lname, mobile, job_title, company, phone ;
  var dob=" ";
  var image=" ";
  var country_name = "";
 var city_name= "";
 var country_id= "";
 var city_id= "";
  Future _getuser() async {
    var url = 'http://qsnap.net/api/getProfile?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["customer"];
    print('Response status: ${response.statusCode}');

    if (responsbody["status"] == 200) {
      setState(() {
        _fnameController.text =data["fname"];
        image=data["image"];
        _lnameController.text = data["lname"];
        _nationalityController.text = data["nationality"];
        _mobileController.text = data["mobile"];
        dob = data["dob"];
        _jobtitleController.text = data["job_title"];
        _companyController.text = data["company"];
        _phoneController.text = data["phone"];
         country_name = data["country_name"];
        city_name= data["city_name"];
        country_id= data["countryId"];
        city_id= data["cityId"];
        print("country_name------>$country_name");
        print("fname------>$city_name");
      });
    }
    // print(responsbody);
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
      String id,
      String password

      ) async {
    print(dob);
    String updetUrl = "http://qsnap.net/api/updateProfile";
    var response = await http.post(updetUrl, body: {
      "id": id,
      'fname': fname,
      'lname': lname,
      'nationality': nationality,
      'dob': dob,
      'company': company,
      'job_title': job_title,
      'mobile': mobile,
      'phone': phone,
      'password': password,
       'countryCode': valcountry(),
       'cityId': valcity(),
    });
    print('country_name---------------------------> ${_dropDownValue}');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var result = json.decode(response.body);
    print('Response convert body: ${result}');
    if (result["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      print("done edit______------>200");
    }
  }

  //uplodeimg
  void updatimge(var base64Image, String id) async {
    print("uplodeimg----------------------------->" + id);
    print("base64Image----------------------->" + base64Image);
    String updetUrl = "http://qsnap.net/api/updateProfileImage";
    var response = await http.post(updetUrl, body: {
      'image': base64Image,
      "id": id,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    //var result = json.decode(response.body);


  }

  @override
  void initState() {
    this.getid();
    this._getuser();
    super.initState();
    this._getcountry();

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
        title: Text("EDIT PROFILE"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
          child: Stack(
//          alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height ,
                 margin: const EdgeInsets.only(top: 70.0),
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    color: Color(0xff000000),
                    border: Border.all(color: Color(0xff000000), width: 3.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: ListView(
                      children: [

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
                              color: Colors.grey,
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
                              color: Colors.grey,
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
                              color: Colors.grey,
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
                        //country
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "COUNTRY:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: _dropDownValue == null
                                  ? Text(country_name,style:TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),)
                                  : Text(
                                _dropDownValue,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: TextStyle(color: Colors.grey),
                              items: data.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['name']),
                                  value: item['code'],
                                );
                              },
                              ).toList(),
                              onChanged: (newVal) {
                                setState(
                                      () {
                                    _dropDownValue = newVal;
                                    print(data);
                                    print("_dropDownValue------>"+_dropDownValue);
                                    // I get full country info
                                    this.fetchcity(_dropDownValue);
                                  },
                                );
                              },
                              value: _dropDownValue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3,left: 15,right: 15),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                        ),
                        //city
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "CITY:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: _dropDownValuecity == null
                                  ? Text(city_name,style:  TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),)
                                  : Text(
                                _dropDownValuecity,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: TextStyle(color: Colors.grey),
                              items: datacity.map(
                                    (val) {
                                  return DropdownMenuItem<String>(
                                    value: val['id'],
                                    child: Text(val['name'],),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                setState(
                                      () {
                                    _dropDownValuecity = newVal;
                                    print(datacity);
                                    // var data = [{'id': 1, 'descripcion': 'Asier'}, {'id': 2, 'descripcion': 'Pepe'}];
                                    // var estateSelected = data.firstWhere((dropdown) => dropdown['id'] == 1);
                                    // print(estateSelected);
                                    print("_dropDownValuecity------>"+_dropDownValuecity);
                                  },
                                );
                              },
                              value: _dropDownValuecity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3,left: 15,right: 15),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xffffd800),
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
                            padding: const EdgeInsets.only(top: 5.0,left: 10),
                            child: Text(
                              dobfun(),
                              // "${selectedDate.toLocal()}".split(' ')[0],}
                              style: TextStyle(color: Colors.grey),
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
                              color: Colors.grey,
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
                              color: Colors.grey,
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
                              color: Colors.grey,
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
                              color: Colors.grey,
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
                            "PASSWORD",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            style: TextStyle(
                              color: Colors.grey,
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
                              hintText: " Password",
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter password';
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
                                  "EDIT",
                                  style:
                                  TextStyle(color: Colors.black54, fontSize: 18),
                                ),
                                onPressed: () {
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
                                      id.toString(),
                                      _passwordController.text

                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),

              ),
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: new Center(
                          child: Container(
                            height: 90.0,
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                              image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  image,
                                ),
                              ),

                            ),


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

        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print(imageBytes);
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);
        updatimge(base64Image,id );
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
        // print("imageFile----------------------------->$imageFile");
        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print("dddd$imageBytes");
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);

        updatimge(base64Image,id);
      });
    }
  }

  String dobfun() {
    if(selectedDate==DateTime(2010, 1, 1)){
      return dob;
    }else{
      return "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  valcountry() {
    if(_dropDownValue==null){
      return country_id;
    }
    else{
      return _dropDownValue;
    }

  }
  valcity() {
    if(_dropDownValuecity==null){
      return city_id;
    }
    else{
      return _dropDownValuecity;
    }

  }
}
