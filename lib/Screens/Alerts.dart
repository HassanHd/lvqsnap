import 'package:flutter/material.dart';
class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
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
          title: Text("ALERTS"),

        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),

          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: ListTile(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  title: Text(
                    "Test",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "22-33-22:56",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Divider(
              height: .5,
              color: Colors.grey,
              ),
              Container(
                color: Colors.white,

                child: ListTile(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  title: Text(
                    "Test",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "22-33-22:56",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Divider(
                height: .5,
                color: Colors.grey,
              ),
              Container(
                color: Colors.white,

                child: ListTile(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  title: Text(
                    "Test",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "22-33-22:56",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Divider(
                height: .5,
                color: Colors.grey,
              ),
            ],
          ),


        )
    );
  }
}

