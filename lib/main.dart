import 'package:flutter/material.dart';
import 'package:ishop/views/home.dart';
import 'package:ishop/views/login.dart';
import 'package:ishop/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(Root());
  initFirebase();
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Gate(),
        '/home': (context) => HomePage(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp()
      },
    );
  }
}

class Gate extends StatefulWidget {
  @override
  _GateState createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  void initState() {
    super.initState();
    reRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage('images/logo.png'),
            height: 200,
          ),
        ),
      ),
    );
  }

  void reRoute() async {
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic loggedIn = pref.getBool('loggedIn');

    if (loggedIn == true) {
      Navigator.popAndPushNamed(context, '/home');
    } else {
      Navigator.popAndPushNamed(context, '/login');
    }
  }
}

void initFirebase() async {
  await Firebase.initializeApp();
}
