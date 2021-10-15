import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'devicelist.dart';
import 'main.dart';

void main() {
  runApp(const MyLoginPage());
}

class User {
  late int _userId;

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }
}

//TODO: Bir şekilde user login sonrası id numarasını global şekilde pasla.
class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        routes: <String, WidgetBuilder>{
          'main': (BuildContext context) => const MyApp(),
          'loginPage': (BuildContext context) => const LoginPage(),
        });
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

var errorText = "";

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:80/mqttAndroid/login.php"), body: {
      'username': user.text,
      'password': pass.text,
    });

    print(response.body);

    var datauser = json.decode(response.body);
    if (datauser != "Error") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyDeviceList(userId: datauser.toString())));
      setState(() {
        errorText = "";
        print(datauser.toString());
      });
    } else {
      setState(() {
        errorText = "Giriş Başarısız Kullanıcı Adı/Şifre Hatalı";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Giriş Yap")),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/logo-2x.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Kullanıcı Adı',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: pass,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  hintText: 'Şifre',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: const Text('Giriş'),
                  onPressed: () {
                    login();
                  }),
            ),
            Center(
              child: Text(
                errorText,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ));
  }
}
