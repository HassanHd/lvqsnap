import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'mywallet.dart';

class qecoode extends StatefulWidget {
  @override
  _qecoodeState createState() => _qecoodeState();
}

class _qecoodeState extends State<qecoode> {
  GlobalKey qrKey = GlobalKey();
  var qrtext;
  QRViewController controller;
  var id;
  getid () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id= prefs.get("id");
    setState(() {
      id= prefs.get("id");
       print("id-----"+id);
    });

  }
  void updatqsnap(
      String idd,
      String qrcode
      ) async {
    String updetUrl = "http://qsnap.net/api/scanqrcode";
    var response = await http.post(updetUrl, body: {
      'id': idd,
      'data': qrcode,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      if(result["response"]["inserted"] == 1){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyWallet()),
        );
      }
      else if(result["response"]["inserted"] == 0){
        _showConfirmationAlert(context);
        controller?.resumeCamera();

      }

      print("done edit______------>200");
    }
  }
  @override
  void initState() {
    this.getid ();
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
          onPressed: (){
            Navigator.pop(context);
          },),
//        toolbarHeight: 65,
        title: Text("SCAN QR CODE"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.yellow,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300
                ),
                onQRViewCreated: _onQRViewCreate),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: Text('scan reselt :$qrtext'),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller=controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrtext=scanData;
        if(qrtext!=null){
          print("id-----"+id);
          print("qrtext-----"+qrtext);
          controller.pauseCamera();
          updatqsnap(id,qrtext);
        }
      });

    });

  }
}
_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("This contact already exists",style: TextStyle(color: Color(0xffffd800),),textAlign: TextAlign.center,),
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