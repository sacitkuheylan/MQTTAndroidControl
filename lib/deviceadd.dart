import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_project_arduino/devicelist.dart';
import 'package:http/http.dart' as http;

void main() {
  //runApp(const MyAddDevicePage());
}

class MyAddDevicePage extends StatelessWidget {
  const MyAddDevicePage({Key? key, required this.IdData}) : super(key: key);
  final String IdData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AddDevicePage(IdData: IdData),
        routes: const <String, WidgetBuilder>{});
  }
}

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key, required this.IdData}) : super(key: key);
  final String IdData;

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  TextEditingController imei = TextEditingController();
  TextEditingController devicename = TextEditingController();
  TextEditingController devicelocation = TextEditingController();

  Future register() async {
    var url = "http://10.0.2.2:80/mqttAndroid/registerdevice.php";
    var response = await http.post(Uri.parse(url), body: {
      "DeviceIMEI": imei.text.toString(),
      "UserId": "2",
      "DeviceName": devicename.text.toString(),
      "DeviceLocation": devicelocation.text.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint("Cihaz zaten var debug");
    } else {
      debugPrint("Cihaz kayıt oldu");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyDeviceList(
                    userId: data,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyDeviceList(
                        userId: '2',
                      )));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(title: const Text("Cihaz Ekle")),
            body: Column(children: <Widget>[
              TextField(
                autocorrect: false,
                controller: imei,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.confirmation_number),
                  hintText: 'IMEI',
                ),
              ),
              TextField(
                autocorrect: false,
                controller: devicename,
                decoration: const InputDecoration(
                  icon: Icon(Icons.drive_file_rename_outline),
                  hintText: 'Cihaz Adı',
                ),
              ),
              TextField(
                autocorrect: false,
                controller: devicelocation,
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_on),
                  hintText: 'Cihaz Lokasyonu',
                ),
              ),
              ElevatedButton(
                  child: const Text('Cihaz Ekle'),
                  onPressed: () {
                    register();
                  }),
            ])));
  }
}
