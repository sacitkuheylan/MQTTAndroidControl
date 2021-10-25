import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  _AddDevicePageState({required this.idData}) : super();
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
    if (data == "Bu IMEI Kayıtlı") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Kaydetmek istediğiniz cihaz daha önce kayıt edilmiş')));
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
              backgroundColor: const Color(0xFF2c3e50),
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                controller: imei,
                decoration: InputDecoration(
                  hintText: 'IMEI (15 Haneli)',
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
                        minimumSize: const Size(350, 40),
                      ),
                      onPressed: () {
                        if (devicename.text.contains(RegExp(r'[0-9]')) &&
                            devicelocation.text.contains(RegExp(r'[0-9]'))) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Cihaz ismi ve/veya Lokasyonu Sadece Harf İçermelidir')));
                        } else if (imei.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Eksik veya Hatalı IMEI Girdiniz')));
                        } else if (devicename.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cihaz ismi boş olamaz')));
                        } else if (devicelocation.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cihaz lokasyonu boş olamaz')));
                        } else {
                          register();
                        }
                      })),
            ])));
  }
}
