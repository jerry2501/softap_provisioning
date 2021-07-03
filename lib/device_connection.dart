import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:softap/home.dart';
import 'package:softap/qr_screen.dart';
import 'package:softap/wifi_page.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:wifi_iot/wifi_iot.dart';

class DeviceConnetion extends StatefulWidget {
  Map qrdata;
  DeviceConnetion({this.qrdata}) ;

  @override
  _DeviceConnetionState createState() => _DeviceConnetionState();
}

class _DeviceConnetionState extends State<DeviceConnetion> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDeviceData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CircularProgressIndicator()
    );
  }

  

  void _showDialogBox(String title,String body){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text(title),
        content:Text(body),
        actions:[
          FlatButton(
            child: Text('Try Again'),
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder:(_)=>HomeScreen()),
                ModalRoute.withName(HomeScreen.homescreen),
              );
            },
          ),
        ]
      );
    });
  }

  Future _getDeviceData() async {
    try{
    print('getDeviceData called');
    var url = Uri.parse('http://65.2.33.12:7000/tempApi');
    var response = await http.post(url,
        body: {'product': widget.qrdata['product'], 'deviceId': widget.qrdata['deviceId']});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    final data  = json.decode(response.body);
    final ssid = data['ssid'];
    final password = data['password'];
    connection(ssid, password);
    }catch(e){
      print(e);
      _showDialogBox('Information Getting error','Device data not fetched due to some Error!!');
    }
  }


  Future connection(String ssid,String password) async{
    var connected=WifiConfiguration.connectedToWifi();
    print('ssid:$ssid');
    var status= await WifiConfiguration.connectToWifi(ssid,password,'com.example.softap');
    print(status);
    if(status==WifiConnectionStatus.connected){
      await WiFiForIoTPlugin.forceWifiUsage(true);
      print('Forced Wifi Usage');
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>WifiPage()));
    }
    else{
      print('error occured');
       _showDialogBox('Wifi Connection error','Wifi Connection not established. Please make sure that your device is online and try again');
    }
  }
}