import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/register.dart';
import 'login.dart';
import 'main.dart';

void main() {
  runApp(const MyWelcomePage());
}

class MyWelcomePage extends StatelessWidget {
  const MyWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
        routes: <String,WidgetBuilder> {
          'main': (BuildContext context) => const MyWelcomePage(),
        }
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}
var errorText = "";

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Otkosis")),
        body: Column(
          children: <Widget>[
            Image.asset("assets/images/logo-2x.png"),
            ElevatedButton(
                child: const Text('Giriş Yap'),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MyLoginPage()));
                }
            ),
            ElevatedButton(
                child: const Text('Kayıt Ol'),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MyRegisterPage()));
                }
            ),
            Center(
              child: Text(
                errorText,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        )
    );
  }}