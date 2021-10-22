import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_project_arduino/devicelist.dart';
import 'package:http/http.dart' as http;

void main() {
  //runApp(const MyAddDevicePage());
}

class MyAddDevicePage extends StatelessWidget {
  const MyAddDevicePage({Key? key, required this.idData}) : super(key: key);
  final String idData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AddDevicePage(idData: idData.toString()),
        routes: const <String, WidgetBuilder>{});
  }
}

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key, required this.idData}) : super(key: key);
  final String idData;

  @override
  _AddDevicePageState createState() =>
      _AddDevicePageState(idData: idData.toString());
}

class _AddDevicePageState extends State<AddDevicePage> {
  _AddDevicePageState({Key? key, required this.idData}) : super();
  var idData;

  TextEditingController imei = TextEditingController();
  TextEditingController devicename = TextEditingController();
  TextEditingController devicelocation = TextEditingController();

  Future register() async {
    var url = "http://10.0.2.2:80/mqttAndroid/registerdevice.php";
    var response = await http.post(Uri.parse(url), body: {
      "DeviceIMEI": imei.text.toString(),
      "UserId": idData.toString(),
      "DeviceName": devicename.text.toString(),
      "DeviceLocation": devicelocation.text.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint("Bu IMEI Kayıtlı");
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
                  builder: (context) => MyDeviceList(
                        userId: idData.toString(),
                      )));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Cihaz Ekle"),
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyDeviceList(
                                userId: idData.toString(),
                              )));
                },
                child: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: Column(children: <Widget>[
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.phone,
                controller: imei,
                decoration: InputDecoration(
                  hintText: 'IMEI',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.confirmation_number,
                  ),
                ),
              ),
              TextFormField(
                obscureText: false,
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: devicename,
                decoration: InputDecoration(
                  hintText: 'Cihaz Adı',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.drive_file_rename_outline,
                  ),
                ),
              ),
              TextFormField(
                obscureText: false,
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: devicelocation,
                decoration: InputDecoration(
                  hintText: 'Cihaz Lokasyonu',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.location_on,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 25, 10, 15),
                  child: ElevatedButton(
                      child: const Text('Cihaz Ekle'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: Size(350, 40), //////// HERE
                      ),
                      onPressed: () {
                        register();
                      })),
            ])));
  }
}
