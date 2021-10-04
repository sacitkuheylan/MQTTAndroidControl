import 'package:flutter/material.dart';
import 'package:mqtt_project_arduino/register.dart';
import 'login.dart';

void main() {
  runApp(const MyWelcomePage());
}

class MyWelcomePage extends StatelessWidget {
  const MyWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WelcomePage(),
        routes: <String, WidgetBuilder>{
          'main': (BuildContext context) => const MyWelcomePage(),
        });
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

var errorText = "";

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Otkosis")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/logo-2x.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  child: const Text('Giriş Yap'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyLoginPage()));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  child: const Text('Kayıt Ol'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyRegisterPage()));
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
