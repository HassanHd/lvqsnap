import 'package:flutter/material.dart';
class qrcodeimg extends StatefulWidget {
var qrcode;

qrcodeimg(this.qrcode);

  @override
  _qrcodeimgState createState() => _qrcodeimgState();
}

class _qrcodeimgState extends State<qrcodeimg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        toolbarHeight: 55,
        title: Image.asset('assats/images/logowhite.png',
            height: 45.0, fit: BoxFit.cover),

      ),
      body: Center(

    child: Image.network(
     widget.qrcode,
      height: double.infinity,
        width: double.infinity,
   ),

      ),


    );
  }
}
