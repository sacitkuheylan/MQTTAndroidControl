import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/register.dart';
import 'main.dart';

void main() {
  runApp(const MyLoginPage());
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String,WidgetBuilder> {
        'main': (BuildContext context) => const MyApp(),
        'loginPage': (BuildContext context) => LoginPage(),
      }
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
var errorText = "";

class _LoginPageState extends State<LoginPage> {

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    final response = await http.post(Uri.parse("http://10.0.2.2:8888/mqttAndroid/login.php"),
        body: {
      'username': user.text,
      'password': pass.text,
        });

    print(response.body);

    var datauser = json.decode(response.body);
    if(datauser == "Success") {
      Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp()));
      setState(() {
        errorText = "";
      });
    }
    else {
      setState(() {
        errorText = "Giriş Başarısız Kullanıcı Adı/Şifre Hatalı";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Column(
        children: <Widget>[
          Image.asset("assets/images/logo-2x.png"),
          TextField(
            controller: user,
            decoration: const InputDecoration(
              icon: Icon(Icons.mail_outline),
              hintText: 'Kullanıcı Adı',
            ),
          ),
          TextField(
            controller: pass,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.vpn_key),
              hintText: 'Şifre',
            ),
          ),
          ElevatedButton(
            child: const Text('Giriş'),
            onPressed: () {
              login();
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