import 'package:flutter/material.dart';

void main() {
  runApp(const MyAddDevicePage());
}

class MyAddDevicePage extends StatelessWidget {
  const MyAddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyAddDevicePage(),
        routes: <String, WidgetBuilder>{
          'main': (BuildContext context) => const MyAddDevicePage(),
        });
  }
}

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

var errorText = "";

class _AddDevicePageState extends State<AddDevicePage> {
  TextEditingController imei = TextEditingController();
  TextEditingController deviceName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cihaz Ekle")),
        body: Column(children: <Widget>[
          TextField(
            controller: deviceName,
            decoration: const InputDecoration(
              icon: Icon(Icons.drive_file_rename_outline),
              hintText: 'Cihaz Adı',
            ),
          ),
          TextField(
            controller: imei,
            maxLength: 15,
            decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number),
              hintText: '15 Haneli IMEI Numarası',
            ),
          ),
          ElevatedButton(child: const Text('Cihaz Ekle'), onPressed: () {}),
        ]));
  }
}
