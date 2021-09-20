import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('broker.mqttdashboard.com', '');
bool connStatus = false;

void main() {
  runApp(const MyApp());
}

Future<int> connectToBroker() async {
  if(connStatus == false) {
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
    print('EXAMPLE::Mosquitto client connecting....');
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
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      print('Topic: ${c[0].topic}, payload: $pt');
      print('');
      parseArduinoResponse(pt);
    });

    client.published!.listen((MqttPublishMessage message) {

    });

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
  if(payload == '0') {
    debugPrint("Arduino sent success message");
  }
  else {
    debugPrint("Success message failed!");
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
}

void pong() {
  print("Broker'a ping gonderildi");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MQTT Led Switcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool stateOfLed = false;
  bool onPressedFlag = false;
  bool offPressedFlag = false;
  var ledStateString = "Off";
  final pubTopic = 'GsmCit/led';
  final builder = MqttClientPayloadBuilder();

  void changeLedStateToTrue() {
    setState(() {
      stateOfLed = true;
      if(stateOfLed == true) {
        ledStateString = "On";
      }
      if(onPressedFlag != true) {
        builder.clear();
        builder.addString('on');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        onPressedFlag = true;
        offPressedFlag = false;
      }
    });
  }

  void changeLedStateToFalse() {
    setState(() {
      stateOfLed = false;
      if(stateOfLed == false) {
        ledStateString = "Off";
      }
      if(offPressedFlag != true) {
        builder.clear();
        builder.addString('off');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        offPressedFlag = true;
        onPressedFlag = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'State of led:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              ledStateString,
              style: Theme.of(context).textTheme.headline4,
            ),
            const Padding(
                padding: EdgeInsets.all(7.0),
                child: ElevatedButton(
                  child: Text('Connect'),
                  onPressed: connectToBroker,
                )),
            Padding(
                padding: EdgeInsets.all(7.0),
                child: ElevatedButton(
                  child: const Text('Start'),
                  onPressed: changeLedStateToTrue,
                )),
            Padding(
                padding: EdgeInsets.all(7.0),
                child: ElevatedButton(
                  child: const Text('Stop'),
                  onPressed: changeLedStateToFalse,
                )),
            ],
        ),
      ),
    );
  }
}
