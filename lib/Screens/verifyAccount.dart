import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'Home.dart';
class verifyAccount extends StatefulWidget {
  @override
  _verifyAccountState createState() => _verifyAccountState();
}

class _verifyAccountState extends State<verifyAccount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  savelogin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
  }
  void getvirifi(var email,var varifi) async {
    print("password------>$varifi");
    print("email------>$email");
    String loginApiUrl="http://qsnap.net/api/verifyAccount?email=$email&code=$varifi";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount=result["response"]["status"];
    if(result["status"]==200){
      if(result["response"]["verified"]==2){
        var idddd=result["response"]["customerId"];
        _showvrfieAlert(context);
        setState(() {
          savelogin(idddd);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Home()
          //
          //   ),
          // );
        });      }

    }

  }
  void resendCode(var email) async {
    print("email------>$email");
    String loginApiUrl="http://qsnap.net/api/resendVerificationMail?email=$email";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    if(result["status"]==200){
      _showConfirmationAlert(context);      }


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
          "VERIFY ACCOUNT",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset('assats/images/logo-colored.png',
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width /2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
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
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              hintText: "Email"),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Code:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _codeController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffffd800)),
                              ),
                              hintText: "Code"),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        InkWell(
                          onTap: () {
                            resendCode(_emailController.text);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Resend Code ?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xffffd800),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                              color: Color(0xffffd800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "ENTER",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {


                                  getvirifi(_emailController.text,_codeController.text);

                                 // fordetpass(_emailController.text);
                                }

                              }),
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );  }
}
_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("Please check your email for a new verification code.",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
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
_showvrfieAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("The account has been verified successfully.",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok"),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()

              ),
            );
          },
        ),
      ],
    ),
  );
}