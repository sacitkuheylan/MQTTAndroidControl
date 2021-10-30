import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_project_arduino/login.dart';

void main() {
  runApp(const MyForgotPage());
}

class MyForgotPage extends StatelessWidget {
  const MyForgotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPage(),
    );
  }
}

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

var errorText = "";

class _ForgotPageState extends State<ForgotPage> {
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
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      debugPrint("Kullanıcı zaten var debug");
    } else {
      debugPrint("Kayıt oldu");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyHomePageWidget()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF81ECEC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF81ECEC),
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePageWidget()));
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: const Text(
            'Şifremi Unuttum',
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 50, 50, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/images/logo-2x.png',
                  width: 250,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: const Color(0xFF2c3e50), //Color(0xFF0984E3),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                      alignment: const AlignmentDirectional(0, 0.2),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 15, 30, 10),
                              child: TextFormField(
                                controller: phone,
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Telefon Numarası',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.phone_android,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 0, 30, 10),
                              child: TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'E-Posta Adresi',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 0, 30, 10),
                              child: TextFormField(
                                controller: imei,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Cihaz IMEI Numarası',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.confirmation_number,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 15, 30, 10),
                              child: ElevatedButton(
                                  child: const Text('Şifre Oluştur'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.greenAccent,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    minimumSize:
                                        const Size(350, 40), //////// HERE
                                  ),
                                  onPressed: () {
                                    register();
                                  }),
                            ),
                          ]))))
        ])));
  }
}
