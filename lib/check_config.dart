import 'package:esp_softap_provisioning/esp_softap_provisioning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:softap/home.dart';

class CheckConfig extends StatefulWidget {
  String ssid, password;
  CheckConfig({@required this.ssid, @required this.password});

  @override
  _CheckConfigState createState() => _CheckConfigState();
}

class _CheckConfigState extends State<CheckConfig> {
  bool _isSending = true,
      _isapplying = true,
      _isSuccessfulLoading = true,
      _isSuccessful = true;
  Provisioning prov;
  @override
  void initState() {
    // TODO: implement initState
    _submitAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_isSending) ? CircularProgressIndicator() : Icon(Icons.check),
                SizedBox(width: 15),
                Text('Sending Wifi Credentials'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_isapplying) ? CircularProgressIndicator() : Icon(Icons.check),
                SizedBox(width: 15),
                Text('Applying Wifi Credentials'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_isSuccessfulLoading)
                    ? CircularProgressIndicator()
                    : (_isSuccessful)
                        ? Icon(Icons.check)
                        : Icon(Icons.cancel),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Checking Provsioning Status'),
                    if (!_isSuccessful)
                      Text('Error Occured during Provisioning!!',
                          style: TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
              SizedBox(height: 20,),
              if(!_isSuccessful) ElevatedButton(onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_)=>HomeScreen()),
                  ModalRoute.withName(HomeScreen.homescreen),
                  );
              },
               child: Text('Try Again')),
          ],
        ),

      
      ),
    );
  }

  Future<void> _submitAction() async {
    prov = await startProvisioning("192.168.4.1:80", "abcd1234");
    await prov
        .sendWifiConfig(ssid: widget.ssid, password: widget.password)
        .then((value) {
      setState(() {
        _isSending = false;
      });
    });
    //await widget.prov.sendWifiConfig(ssid: 'Network.tcl', password: 'pr@apa@rmf');
    await prov.applyWifiConfig().then((value) {
      if (value) {
        setState(() {
          _isapplying = false;
        });
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
    Future.delayed(Duration(seconds: 10)).then((_) async {
      bool status = await prov.checkWifiConfig();
      print(status);
      if (status) {
        setState(() {
          _isSuccessfulLoading = false;
          _isSuccessful = true;
        });
        Fluttertoast.showToast(
            msg: "Connected Successfully!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          _isSuccessfulLoading = false;
          _isSuccessful = false;
        });
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
        transport: TransportHTTP(hostname),
        security: Security1(pop: 'abcd1234'));
    var success = await prov.establishSession();
    if (!success) {
      throw Exception('Error establishSession');
    } else {
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
