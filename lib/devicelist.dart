import 'package:flutter/material.dart';

void main() {
  runApp(const MyDeviceListPage());
}

class MyDeviceListPage extends StatelessWidget {
  const MyDeviceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DeviceListPage(),
        routes: <String, WidgetBuilder>{
          'main': (BuildContext context) => const MyDeviceListPage(),
        });
  }
}

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({Key? key}) : super(key: key);

  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

var errorText = "";

class _DeviceListPageState extends State<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cihazlarım")),
      body: const Center(
          child: Text('Cihazlarınızı + butonunu kullanarak ekleyebilirsiniz.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
