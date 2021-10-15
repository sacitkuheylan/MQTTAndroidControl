import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mqtt_project_arduino/zerodevice.dart';

class Spacecraft {
  final int id;
  final int DeviceIMEI;
  final String DeviceName, DeviceLocation;

  Spacecraft({
    required this.id,
    required this.DeviceIMEI,
    required this.DeviceName,
    required this.DeviceLocation,
  });
//TODO: Login sonrası gelecek id değişkeni ile istek oluşturarak sadece doğru cihaz listesini getir. PHP Backend kısmı yapıldı id ile istek göndermek gerekiyor.
  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      id: jsonData['DeviceId'],
      DeviceIMEI: jsonData['DeviceIMEI'],
      DeviceName: jsonData['DeviceName'],
      DeviceLocation: jsonData['DeviceLocation'],
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Spacecraft> spacecrafts;

  const CustomListView(this.spacecrafts);

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: spacecrafts.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(spacecrafts[currentIndex], context);
      },
    );
  }

  Widget noDeviceRegistered() {
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

  Widget createViewItem(Spacecraft spacecraft, BuildContext context) {
    return ListTile(
        title: Card(
          elevation: 5.0,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                    child: Text(
                      spacecraft.DeviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    padding: const EdgeInsets.all(1.0)),
                Row(children: <Widget>[
                  Padding(
                      child: Text(
                        "IMEI: " + spacecraft.DeviceIMEI.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(1.0)),
                  const Text(" | "),
                  Padding(
                      child: Text(
                        "Yer: " + spacecraft.DeviceLocation,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(1.0)),
                ]),
              ],
            ),
          ),
        ),
        onTap: () {
          //We start by creating a Page Route.
          //A MaterialPageRoute is a modal route that replaces the entire
          //screen with a platform-adaptive transition.
          var route = MaterialPageRoute(
            builder: (BuildContext context) => SecondScreen(value: spacecraft),
          );
          //A Navigator is a widget that manages a set of child widgets with
          //stack discipline.It allows us navigate pages.
          Navigator.of(context).push(route);
        });
  }
}

//Future is n object representing a delayed computation.
Future<List<Spacecraft>> downloadJSON(String UserId) async {
  /*
  final response = await http
      .post(Uri.parse("http://10.0.2.2:80/mqttAndroid/devices.php"), body: {
    'UserId': 2,
  });

  print(response.body);
  var datauser = json.decode(response.body);
  */
  //const jsonEndpoint = "http://10.0.2.2:80/mqttAndroid/devices.php";

  //final response = await get(Uri.parse(jsonEndpoint));

  final response = await http
      .post(Uri.parse("http://10.0.2.2:80/mqttAndroid/devices.php"), body: {
    'UserId': UserId,
  });

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    print(spacecrafts);
    return spacecrafts
        .map((spacecraft) => Spacecraft.fromJson(spacecraft))
        .toList();
  } else {
    throw Exception('Cihaz Detayları Alınamadı!');
  }
}

class SecondScreen extends StatefulWidget {
  final Spacecraft value;

  const SecondScreen({Key? key, required this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cihaz Detayları')),
      body: Center(
        child: Card(
          elevation: 5.0,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 8,
                ),
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  child: Text(
                    'Cihaz Detayları',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
                Padding(
                  //`widget` is the current configuration. A State object's configuration
                  //is the corresponding StatefulWidget instance.
                  child: Text(
                    'Cihaz IMEI : ${widget.value.DeviceIMEI}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
                Padding(
                  child: Text(
                    'Cihaz Adı : ${widget.value.DeviceName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
                Padding(
                  child: Text(
                    'Cihaz Lokasyonu : ${widget.value.DeviceLocation}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
                Card(
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    child: Padding(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Bağlantı durumu: Bağlı',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Cihaz durumu: Açık',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                                padding: EdgeInsets.all(7.0),
                                child: ElevatedButton(
                                    child: Text('Bağlan'),
                                    onPressed: () {
                                      Future.delayed(
                                          Duration(milliseconds: 3000), () {
                                        setState(() {});
                                      });
                                    })),
                            Padding(
                                padding: EdgeInsets.all(7.0),
                                child: ElevatedButton(
                                  child: const Text('Aç'),
                                  onPressed: () {},
                                )),
                            Padding(
                                padding: EdgeInsets.all(7.0),
                                child: ElevatedButton(
                                  child: const Text('Kapat'),
                                  onPressed: () {},
                                )),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(50.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDeviceList extends StatelessWidget {
  const MyDeviceList({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Cihaz Listesi')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          //FutureBuilder is a widget that builds itself based on the latest snapshot
          // of interaction with a Future.
          child: FutureBuilder<List<Spacecraft>>(
            future: downloadJSON(userId),
            //we pass a BuildContext and an AsyncSnapshot object which is an
            //Immutable representation of the most recent interaction with
            //an asynchronous computation.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Spacecraft>? spacecrafts = snapshot.data;
                return CustomListView(spacecrafts!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              //return  a circular progress indicator.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  //runApp(MyDeviceList());
}
