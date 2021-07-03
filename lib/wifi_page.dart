import 'package:esp_softap_provisioning/esp_softap_provisioning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:softap/check_config.dart';
import 'package:softap/widgets/wifi_dialog.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

class WifiPage extends StatefulWidget {
  static String wifipage = '/WifiScreen';
  WifiPage({Key key}) : super(key: key);

  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  Provisioning prov;
  bool _loading = true;
  var networks;
  List wifi = [];

  Future _loadData() async {
    // final noPermissions = await WifiFlutter.promptPermissions();
    // if (noPermissions) {
    //   return;
    // }

    networks = await WifiConfiguration.getWifiList();
    for (var entry in networks) {
      print('Entery:${entry}');
      var scanwifi = {
        'ssid': entry,
       // 'rssi': entry.rssi,
        //'private': entry.isSecure,
      };

      wifi.add(scanwifi);
    }

    print('Wifi:$wifi');
    //print(networks.first.ssid);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: networks.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WifiDialog(
                            wifiName: wifi[index]['ssid'],
                            onSubmit: (ssid, password) {
                              print('ssid =$ssid, password = $password');

                              //submitAction(ssid, password);
                            },
                          );
                        });
                  },
                  child: ListTile(
                    leading: Icon(Icons.wifi),
                    title: Text(wifi[index]['ssid']),
                    // trailing: Text(wifi[index]['rssi'].toString()),
                  ),
                );
              }),
    );
  }

  Future<void> submitAction(String ssid, String password) async {
    //print(wifiNameController.text + wifiPasswordController.text);
    prov = await startProvisioning("192.168.4.1:80", "abcd1234");
    try {
      await prov.sendWifiConfig(ssid: ssid, password: password);
      //await widget.prov.sendWifiConfig(ssid: 'Network.tcl', password: 'pr@apa@rmf');

      await prov.applyWifiConfig().then((value) {
        print(value);
        if (value) {
          Fluttertoast.showToast(
              msg: "Provisioning Successful!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Error Occured!! Try Again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } catch (e) {
      print(e);
    }
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
