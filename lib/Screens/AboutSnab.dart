import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class AboutQsnap extends StatefulWidget {
  @override
  _AboutQsnapState createState() => _AboutQsnapState();
}

class _AboutQsnapState extends State<AboutQsnap> {
  var description;
  Future _getuser() async {
    var url = 'http://qsnap.net/api/getPage?slug=about';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data=responsbody["response"]["page"];
    if(responsbody["status"]==200){
      setState(() {
        description=data["description"];

        // print("id------>$fname");
      });
    }
    // print(responsbody);
    return "Sucess";
  }

  @override
  void initState() {
    this._getuser ();
    super.initState();
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
          onPressed: (){
            Navigator.pop(context);
          },),
//        toolbarHeight: 65,
        title: Text("ABOUT QSNAP"),


      ),
      body: FutureBuilder(
        future: _getuser(), builder: (context, snapshot) {

    // print(snapshot.data);
    if(snapshot.data == null){
    return Center(
    child: CircularProgressIndicator(
    backgroundColor: Colors.yellow,
    )
    );
    }

    else {
      return Padding(
        padding: const EdgeInsets.only(top: 25,right: 10,left: 10,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ABOUT US",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            ),
            SizedBox(height: 10,),
            Text(description,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),

          ],
        ),



      );
    }
      }


      )
    );
  }
}
