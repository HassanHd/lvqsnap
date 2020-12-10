import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:qsnap/Screens/verifyAccount.dart';
import 'dart:async';
import 'dart:convert';
import 'loginscreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _dropDownValue;
  String _dropDownkey;
  List data = List();

  Future<String> _getuser() async {
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

  void postSignup(String fname, String lname, String email, String mobile,String password) async {
    String SignApiUrl = "http://qsnap.net/api/register";
    var response = await http.post(SignApiUrl, body: {
      'fname': fname,
      'lname': lname,
      'email': email,
      'mobile': mobile,
      'countryCode': _dropDownValue,
      'cityId': _dropDownValuecity,
      'password': password,
      // 'uuid': '',
      // 'version': '',
      // 'platform': ' ',
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      if(result["response"]["inserted"]==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => verifyAccount()),
      );}
      else if(result["response"]["inserted"]==0){
        _showConfirmationAlert(context);
      }

      print("done signup______------>200");
    }
  }

  @override
  void initState() {
    super.initState();
    this._getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: .5,
        title: Text(
          "SIGN UP",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "First Name:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _fnameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "First Name"),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter First Name';
                        }
                        return null;
                      },
                    ),
                    //lastname
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Last Name:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _lnameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "Last Name"),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Last Name';
                        }
                        return null;
                      },
                    ),
                    //Email
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Email:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Email",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                    ),
                    //mobile
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Mobile:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Mobile",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Mobile';
                        }
                        return null;
                      },
                    ),
                    //country
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Country:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: _dropDownValue == null
                              ? Text('Country' )
                              : Text(
                                  _dropDownValue,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: TextStyle(color: Colors.black87),
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
                                // var data = [{'id': 1, 'descripcion': 'Asier'}, {'id': 2, 'descripcion': 'Pepe'}];
                                // var estateSelected = data.firstWhere((dropdown) => dropdown['id'] == 1);
                                // print(estateSelected);
                                print("_dropDownValue------>"+_dropDownValue);
                                // I get full country info
                                this.fetchcity(_dropDownValue);


                                // do what you want with the selection....



                              },
                            );
                          },
                          value: _dropDownValue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black87,
                      ),
                    ),
                    //city
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "City:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: _dropDownValuecity == null
                              ? Text('City')
                              : Text(
                                  _dropDownValuecity,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: TextStyle(color: Colors.black87),
                          items: datacity.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val['id'],
                                child: Text(val['name']),
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
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black87,
                      ),
                    ),

                    //password
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Password:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Password",
                      ),
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                          color: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Color(0xffffd800), fontSize: 18),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              postSignup(
                                  _fnameController.text,
                                  _lnameController.text,
                                  _emailController.text,
                                  _mobileController.text,
                                  _passwordController.text);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(" This Email Already Exists",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
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