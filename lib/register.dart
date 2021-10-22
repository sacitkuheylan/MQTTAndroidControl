import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/login.dart';

void main() {
  runApp(const MyRegisterPage());
}

class MyRegisterPage extends StatelessWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

var errorText = "";

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  Future register() async {
    var url = "http://10.0.2.2:80/mqttAndroid/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "NameSurname": name.text,
      "PhoneNumber": phone.text,
      "Username": user.text,
      "Password": pass.text,
      "Email": email.text,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint("Kullanıcı zaten var debug");
    } else {
      debugPrint("Kayıt oldu");
      //Navigator.push(context,
      //MaterialPageRoute(builder: (context) => const MyLoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Kayıt Ol")),
        body: Column(children: <Widget>[
          Image.asset("assets/images/logo-2x.png"),
          TextField(
            autocorrect: false,
            controller: name,
            decoration: const InputDecoration(
              icon: Icon(Icons.perm_identity_outlined),
              hintText: 'Ad Soyad',
            ),
          ),
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.phone,
            controller: phone,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone_android),
              hintText: 'Telefon Numarası',
            ),
          ),
          TextField(
            autocorrect: false,
            controller: email,
            decoration: const InputDecoration(
              icon: Icon(Icons.mail_outline),
              hintText: 'E-Posta Adresi',
            ),
          ),
          TextField(
            autocorrect: false,
            controller: user,
            decoration: const InputDecoration(
              icon: Icon(Icons.supervised_user_circle_outlined),
              hintText: 'Kullanıcı Adı',
            ),
          ),
          TextField(
            autocorrect: false,
            controller: pass,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.vpn_key),
              hintText: 'Şifre',
            ),
          ),
          ElevatedButton(
              child: const Text('Kayıt Ol'),
              onPressed: () {
                register();
              }),
        ]));
  }
}
