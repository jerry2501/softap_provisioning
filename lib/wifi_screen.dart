import 'package:esp_softap_provisioning/esp_softap_provisioning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class WifiScreen extends StatefulWidget {
  //Provisioning prov;
  //WifiScreen({this.prov});

  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();
  String ssid, password;
  Provisioning prov=Provisioning();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: wifiNameController,
              decoration: InputDecoration(labelText: 'Wifi Name'),
              onChanged: (value) {
                setState(() {
                  ssid = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: wifiPasswordController,
              decoration: InputDecoration(labelText: 'Wifi Password'),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                print('ssid:$ssid,password:$password');
                submitAction(ssid, password);
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitAction(String ssid, String password) async {
    print(wifiNameController.text + wifiPasswordController.text);
     prov = await startProvisioning("192.168.4.1:80","abcd1234");
    await prov.sendWifiConfig(ssid: wifiNameController.text.toString(), password: wifiPasswordController.text.toString());
    //await widget.prov.sendWifiConfig(ssid: 'Network.tcl', password: 'pr@apa@rmf');
    await prov.applyWifiConfig().then((value){
      if(value){
        Fluttertoast.showToast(
                        msg: "Credential apply method called!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
      }
    });
    Future.delayed(Duration(seconds:10)).then((_) async{
      bool status  = await prov.checkWifiConfig();
      print(status);
    if(status){
      Fluttertoast.showToast(
                        msg: "Connected Successfully!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
    }
    else{
      Fluttertoast.showToast(
                        msg: "Error Occured!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
    }
    });
    
  }


   Future<Provisioning> startProvisioning(String hostname, String pop) async {
    Provisioning prov = Provisioning(
        transport: TransportHTTP(hostname), security: Security1(pop:'abcd1234'));
    var success = await prov.establishSession();
    if (!success) {
      throw Exception('Error establishSession');
    }
    else{
      Fluttertoast.showToast(
                        msg: "Session Establish Successful!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
    }
    return prov;
  }
}
