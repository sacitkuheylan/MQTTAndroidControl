import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/deviceadd.dart';
import 'dart:convert';

final client = MqttServerClient('broker.mqttdashboard.com', '');
bool connStatus = false;
bool stateOfLed = false;
String connStatusString = "Bağlı Değil";

Future<int> connectToBroker() async {
  if (connStatus == false) {
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client baglantisi basarili');
    } else {
      print('Client baglantisi basarisiz. Sebebi: ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    const topic = 'GsmCit/ledStatus';
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Topic: ${c[0].topic}, payload: $pt');
      print('');
      parseArduinoResponse(pt);
    });

    client.published!.listen((MqttPublishMessage message) {});

    const pubTopic = 'arduinoControl';
    final builder = MqttClientPayloadBuilder();
    builder.addString('MQTT Connection from Flutter Established!');
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

    /* Baglantinin kapanmasini saglamak icin
  await MqttUtilities.asyncSleep(120);
  client.unsubscribe(topic);
  await MqttUtilities.asyncSleep(2);
  client.disconnect();
  */
  }
  return 0;
}

void parseArduinoResponse(String payload) {
  debugPrint(payload);
  if (payload == '0') {
    debugPrint("Arduino sent success message");
    stateOfLed = true;
  } else {
    debugPrint("Success message failed!");
    stateOfLed = false;
  }
}

void onSubscribed(String topic) {
  print('$topic isimli basliga abone olundu');
}

void onDisconnected() {
  print('Disconnect talep edildi - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('Disconnect talebi gerceklestirildi');
  }
}

void onConnected() {
  print('Baglanti gerceklesti');
  connStatus = true;
  connStatusString = "Bağlı";
}

void pong() {
  print("Broker'a ping gonderildi");
}

class Spacecraft {
  final int id;
  String deviceIMEI;
  String deviceName, deviceLocation;

  Spacecraft({
    required this.id,
    required this.deviceIMEI,
    required this.deviceName,
    required this.deviceLocation,
  });
//TODO: Login sonrası gelecek id değişkeni ile istek oluşturarak sadece doğru cihaz listesini getir. PHP Backend kısmı yapıldı id ile istek göndermek gerekiyor.
  factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
    return Spacecraft(
      id: jsonData['DeviceId'],
      deviceIMEI: jsonData['DeviceIMEI'],
      deviceName: jsonData['DeviceName'],
      deviceLocation: jsonData['DeviceLocation'],
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
        title: const Text("Cihaz Listesi"),
        backgroundColor: Colors.blueGrey,
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
                padding: const EdgeInsets.all(7.0),
                child: ElevatedButton(
                    child: const Text('Cihaz Ekle'), onPressed: () {})),
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
            decoration: BoxDecoration(
                border: Border.all(color: const Color((0xFF81ECEC)))),
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                    child: Text(
                      spacecraft.deviceName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF2c3e50)),
                      textAlign: TextAlign.right,
                    ),
                    padding: const EdgeInsets.all(1.0)),
                Padding(
                    child: Text(
                      "IMEI: " + spacecraft.deviceIMEI.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(1.0)),
                Padding(
                    child: Text(
                      "Yer: " + spacecraft.deviceLocation,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(1.0)),
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
Future<List<Spacecraft>> downloadJSON(String userId) async {
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
    'UserId': userId,
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
  void initState() {
    connectToBroker();
    super.initState();
  }

  bool onPressedFlag = false;
  bool offPressedFlag = false;
  var ledStateString = "Kapalı";
  final builder = MqttClientPayloadBuilder();

  void changeLedStateToTrue() {
    setState(() {
      stateOfLed = true;
      if (stateOfLed == true) {
        ledStateString = "Açık";
      }
      if (onPressedFlag != true) {
        builder.clear();
        builder.addString('on');
        client.publishMessage(widget.value.deviceIMEI.toString(),
            MqttQos.exactlyOnce, builder.payload!);
        onPressedFlag = true;
        offPressedFlag = false;
      }
    });
  }

  void changeLedStateToFalse() {
    setState(() {
      stateOfLed = false;
      if (stateOfLed == false) {
        ledStateString = "Kapalı";
      }
      if (offPressedFlag != true) {
        builder.clear();
        builder.addString('off');
        client.publishMessage(widget.value.deviceIMEI.toString(),
            MqttQos.exactlyOnce, builder.payload!);
        offPressedFlag = true;
        onPressedFlag = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cihaz Detayları',
        ),
        backgroundColor: const Color(0xFF2c3e50),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF81ECEC),
                width: 0,
              ),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                child: Text(
                  'Cihaz Detayları',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(20.0),
              ),
              Padding(
                //`widget` is the current configuration. A State object's configuration
                //is the corresponding StatefulWidget instance.
                child: Text(
                  'Cihaz IMEI : ${widget.value.deviceIMEI}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                padding: const EdgeInsets.all(5.0),
              ),
              Padding(
                child: Text(
                  'Cihaz Adı : ${widget.value.deviceName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                padding: const EdgeInsets.all(5.0),
              ),
              Padding(
                child: Text(
                  'Cihaz Lokasyonu : ${widget.value.deviceLocation}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                padding: const EdgeInsets.all(5.0),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.all(20.0),
                    child: Padding(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Cihaz Durumu',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Text(
                                ledStateString,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.greenAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  minimumSize:
                                      const Size(200, 50), //////// HERE
                                ),
                                child: const Text('Aç'),
                                onPressed: () {
                                  changeLedStateToTrue();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.redAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  minimumSize:
                                      const Size(200, 50), //////// HERE
                                ),
                                child: const Text('Kapat'),
                                onPressed: () {
                                  changeLedStateToFalse();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(50.0),
                    ),
                  ),
                ),
              ),
            ],
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
        appBar: AppBar(
          title: const Text('Cihaz Listesi'),
          backgroundColor: const Color(0xFF2c3e50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyAddDevicePage(idData: userId),
            );
            Navigator.of(context).push(route);
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color(0xFF2c3e50),
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
