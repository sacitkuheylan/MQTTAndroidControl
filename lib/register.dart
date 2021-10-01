import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/login.dart';
import 'main.dart';

void main() {
  runApp(const MyRegisterPage());
}

class MyRegisterPage extends StatelessWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
var errorText = "";

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController imei = TextEditingController();

  Future register() async {
    var url = "http://10.0.2.2:80/mqttAndroid/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "Name": name.text,
      "Surname": surname.text,
      "PhoneNumber": phone.text,
      "Username": user.text,
      "Password": pass.text,
      "Email": email.text,
      "DeviceIMEI": imei.text
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint("Kullanıcı zaten var debug");
    } else {
      debugPrint("Kayıt oldu");
      Navigator.push(context,MaterialPageRoute(builder: (context) => MyLoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kayıt Ol")),
        body: Column(
            children: <Widget>[
              Image.asset("assets/images/logo-2x.png"),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Ad',
                ),
              ),
              TextField(
                controller: surname,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Soyad',
                ),
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Telefon Numarası',
                ),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'E-Posta Adresi',
                ),
              ),
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
              TextField(
                controller: imei,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Cihaz Üstünde Bulunan Kod',
                ),
              ),
              ElevatedButton(
                  child: const Text('Kayıt Ol'),
                  onPressed: () {
                    register();
                  }
              ),
            ]
        )
    );
  }
}