// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:merp_app/helpers/configure_amplify.dart';
import 'package:merp_app/screens/confirm.dart';
import 'package:merp_app/screens/confirm_reset.dart';
import 'package:merp_app/screens/entry.dart';
import 'package:merp_app/screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mERP App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ConfirmScreen(data: settings.arguments as LoginData),
              transitionsBuilder: (_, __, ___, child) => child);
        }
        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ConfirmResetScreen(data: settings.arguments as LoginData),
              transitionsBuilder: (_, __, ___, child) => child);
        }
        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionsBuilder: (_, __, ___, child) => child);
        }

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}
