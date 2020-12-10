import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _varifiController = TextEditingController();
  void fordetpass(String email) async {
    print("email------>$email");

    String loginApiUrl="http://qsnap.net/api/forgotPassword?email=$email";

    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);

    if(result["status"]==200){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Check your email for the verification code"),
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
                      setState((){

                      });
                      Navigator.of(context).pop();

                    },
                  )
                ],
              );
            });




    }

  }
  void getvirifi(String email,String varifi) async {
    print("email------>$email");
    print("password------>$varifi");
    String loginApiUrl="http://qsnap.net/api/resetPassword?email=$email&code=$varifi";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount=result["response"]["status"];
    print("acount--------------->"+acount.toString());
    if(result["status"]==200){
      if(result["response"]["reset"]==2){
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen()
            ),
          );
        });
      }
      else if(result["response"]["reset"]==1){

      }

    }

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
          "FORGOT PASSWORD",
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
                                "GET PASSWORD",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => LoginScreen()),
                                  // );
                                  fordetpass(_emailController.text);
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
    );
  }
}
