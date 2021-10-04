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
  TextEditingController phone = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController imei = TextEditingController();

  Future register() async {
    var url = "http://10.0.2.2:80/mqttAndroid/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "NameSurname": name.text,
      "PhoneNumber": phone.text,
      "Username": user.text,
      "Password": pass.text,
      "Email": email.text,
      "DeviceIMEI": imei.text,
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
                  hintText: 'Ad Soyad',
                ),
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone_android),
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
                  icon: Icon(Icons.supervised_user_circle_outlined),
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
                maxLength: 15,
                decoration: const InputDecoration(
                  icon: Icon(Icons.confirmation_number),
                  hintText: 'Cihaz Üzerinde Bulunan IMEI Numarası',
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