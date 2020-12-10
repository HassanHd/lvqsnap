import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'Signup.dart';
import 'forgotpassword.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
  TextEditingController _varifiController = TextEditingController();


  void getLogin(String email,String password) async {
    print("email------>$email");
    print("password------>$password");
    String loginApiUrl="http://qsnap.net/api/signin?email=$email&password=$password";

    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
   var acount=result["response"]["status"];
   //print("acount--------------->"+acount.toString());
    if(result["status"]==200){
      if(result["response"]["status"]==4){
        setState(() {
          String id=result["response"]["customer"]["id"];
          print("id------>$id");
          savelogin(id);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home()),
          );
        });      }
      else if(result["response"]["status"]==0){
        _showConfirmationAlert(context);      }
      else if(result["response"]["status"]==1){
        _showConfirmationAlert(context);      }
      else if(result["response"]["status"]==2){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Check your email for the verification code "),
                content: TextField(
                  controller: _varifiController,
                ),
                actions: [
                  MaterialButton(
                    elevation: 5.0,
                    child: Text("OK"),
                    onPressed: () {
                       getvirifi(_emailController.text,_varifiController.text);
                      // item.add(customController.text);
                      setState((){});
                      Navigator.of(context).pop();

                    },
                  )
                ],
              );
            });
      }
      else{
        _showConfirmationAlert(context);
      }


    }

  }
  savelogin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
  }
  getlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  var idchick= prefs.get("id");
  setState(() {
    if(idchick!= null){
      // wrong call in wrong place!
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home()
      ));
    }
  });
  }

  void getvirifi(String email,String varifi) async {
    print("email------>$email");
    print("password------>$varifi");
    String loginApiUrl="http://qsnap.net/api/verifyAccount?email=$email&code=$varifi";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount=result["response"]["status"];
    print("acount--------------->"+acount.toString());
    if(result["status"]==200){
      if(result["response"]["verified"]==2){
        var idddd=result["response"]["customerId"];
        setState(() {
          savelogin(idddd);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home()),
          );
        });      }

    }

  }

  void _showToastany(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('You do not have any  an account'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
@override
  void initState() {
   this.getlogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              'assats/images/logo-colored.png',
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width / 2,
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            "Password:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffffd800)),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffffd800)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffffd800)),
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
                          height: 20,
                          width: double.infinity,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Forgotpassword()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Forgot Password ?",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                                "Login",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  getLogin(_emailController.text,_passwordController.text);
                                }
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  " Don't have an account? ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  child: Text(
                                    " SIGN UP",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xffffd800),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
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
    );
  }
}
_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(" Please enter the correct password or email",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
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