//import 'package:connectivity/connectivity.dart';
import 'package:esp_softap_provisioning/esp_softap_provisioning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:softap/qr_screen.dart';
import 'package:softap/wifi_page.dart';
import 'package:softap/wifi_screen.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';

class HomeScreen extends StatefulWidget {
  static String homescreen = '/homescreen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Provisioning prov;
  String ssid = 'PROV_89876C';
  String password = 'PROV_PASS';

  @override
  void initState() {
    // TODO: implement initState
    checkWifiPermission();
    
  }

  Future checkWifiPermission() async{
    final noPermissions = await WifiFlutter.promptPermissions();
            if (noPermissions) {
              return;
            }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connect to Your Device',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
            Text(
                'To Provision your phone,Please make sure it is turned on.Connect your phone with wifi network with name like PROV_XXXX',
                textAlign: TextAlign.center),
            // SizedBox(height: 15),
            // RaisedButton(
            //   child: Text('Set Connection'),
            //   onPressed: () async {
            //     await SystemSettings.wifi();
            //   },
            // ),
            SizedBox(height: 10,),
            RaisedButton(
            child: Text('Go to Wifi Provisioning'),  
            onPressed:() async{

              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>QRScreen()));

              //TODO: Coonect to wifi 
              //await connection();

              // var connectivityResult =
              //         await (Connectivity().checkConnectivity());
              //     if (connectivityResult == ConnectivityResult.wifi) {
              //       Fluttertoast.showToast(
              //           msg: "Connected Successfully!!",
              //           toastLength: Toast.LENGTH_SHORT,
              //           gravity: ToastGravity.BOTTOM,
              //           timeInSecForIosWeb: 1,
              //           backgroundColor: Colors.black,
              //           textColor: Colors.white,
              //           fontSize: 16.0);
              //       Navigator.of(context)
              //           .push(MaterialPageRoute(builder: (ctx) => Wifi()));
              //     } else {
              //       Fluttertoast.showToast(
              //           msg: "Please Connect with WIFI!!",
              //           toastLength: Toast.LENGTH_SHORT,
              //           gravity: ToastGravity.BOTTOM,
              //           timeInSecForIosWeb: 1,
              //           backgroundColor: Colors.black,
              //           textColor: Colors.white,
              //           fontSize: 16.0);
              //     }
            } ,)
          ],
        ),
      ),
    );
  }

  Future connection() async{
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
    }
  }
}
