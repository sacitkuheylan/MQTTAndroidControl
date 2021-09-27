import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8888/mqttAndroid/login.php"),
        body: {
          'username': user.text,
          'password': pass.text,
        });

    print(response.body);

    var datauser = json.decode(response.body);
    if (datauser == "Success") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
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
        appBar: AppBar(title: Text("Kayıt Ol")),
        body: Column(
            children: <Widget>[
              Image.asset("assets/images/logo-2x.png"),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Ad',
                ),
              ),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Soyad',
                ),
              ),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Telefon Numarası',
                ),
              ),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'E-Posta Adresi',
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
                controller: user,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  hintText: 'Cihaz Üstünde Bulunan Kod',
                ),
              ),
              ElevatedButton(
                  child: const Text('Kayıt Ol'),
                  onPressed: () {
                    login();
                  }
              ),
            ]
        )
    );
  }
}