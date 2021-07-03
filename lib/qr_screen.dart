import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:softap/device_connection.dart';
import 'package:softap/wifi_page.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:wifi_iot/wifi_iot.dart';

class QRScreen extends StatefulWidget {
  static String qrpage = '/qrpage';
  const QRScreen({Key key}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  GlobalKey _qrKey = GlobalKey();
  var _qrtext = '';
  QRViewController controller;
  Map _qrdata;
  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_qrdata == null)
            ? Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: _qrKey,
                      overlay: QrScannerOverlayShape(
                        borderRadius: 10,
                        borderColor: Colors.red,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300,
                      ),
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('Scan Result:$_qrtext'),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        _qrtext = scanData;
        _qrdata = json.decode(_qrtext);
        print(_qrdata['deviceId']);
        await controller.pauseCamera();
        //_getDeviceData();
        Navigator.of(context).push(MaterialPageRoute(builder: (_ctx)=>DeviceConnetion(qrdata:_qrdata)));
      });
    });
  }

  // void _showDialogBox(String title,String body){
  //   showDialog(context: context, builder: (_){
  //     return AlertDialog(
  //       title: Text(title),
  //       content:Text(body),
  //       actions:[
  //         FlatButton(
  //           child: Text('Try Again'),
  //           onPressed: (){
  //             Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(builder:(_)=>QRScreen()),
  //               ModalRoute.withName(QRScreen.qrpage),
  //             );
  //           },
  //         ),
  //       ]
  //     );
  //   });
  // }

  // Future _getDeviceData() async {
  //   try{
  //   print('getDeviceData called');
  //   var url = Uri.parse('http://65.2.33.12:7000/tempApi');
  //   var response = await http.post(url,
  //       body: {'product': _qrdata['product'], 'deviceId': _qrdata['deviceId']});
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //   final data  = json.decode(response.body);
  //   final ssid = data['ssid'];
  //   final password = data['password'];
  //   connection(ssid, password);
  //   }catch(e){
  //     print(e);
  //     _showDialogBox('Information Getting error','Device data not fetched due to some Error!!');
  //   }
  // }


  // Future connection(String ssid,String password) async{
  //   var connected=WifiConfiguration.connectedToWifi();
  //   print('ssid:$ssid');
  //   var status= await WifiConfiguration.connectToWifi(ssid,password,'com.example.softap');
  //   print(status);
  //   if(status==WifiConnectionStatus.connected){
  //     await WiFiForIoTPlugin.forceWifiUsage(true);
  //     print('Forced Wifi Usage');
  //     Navigator.of(context).push(MaterialPageRoute(builder: (_)=>WifiPage()));
  //   }
  //   else{
  //     print('error occured');
  //      _showDialogBox('Wifi Connection error','Wifi Connection not established. Please make sure that your device is online and try again');
  //   }
  // }
}
