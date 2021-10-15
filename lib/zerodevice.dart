import 'package:flutter/material.dart';

void main() {
  runApp(const ZeroDevicePage());
}

class ZeroDevicePage extends StatelessWidget {
  const ZeroDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ZeroDevice(),
        routes: <String, WidgetBuilder>{
          'main': (BuildContext context) => const ZeroDevicePage(),
        });
  }
}

class ZeroDevice extends StatefulWidget {
  const ZeroDevice({Key? key}) : super(key: key);

  @override
  _ZeroDeviceState createState() => _ZeroDeviceState();
}

var errorText = "";

class _ZeroDeviceState extends State<ZeroDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cihaz Listesi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Daha önce cihaz eklemediniz.\n'
              'Cihaz Eklemek için butonu kullanın',
            ),
            Padding(
                padding: EdgeInsets.all(7.0),
                child: ElevatedButton(
                    child: Text('Cihaz Ekle'), onPressed: () {})),
          ],
        ),
      ),
    );
  }
}
