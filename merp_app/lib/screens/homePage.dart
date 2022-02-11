// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, unused_field, file_names

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthUser _user;

  @override
  void initState() {
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
    }).catchError((error) {
      print((error as AuthException).message);
    });
  }

  void cerrarSesion() => Navigator.of(context).pushReplacementNamed('/login');

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Flexible(
      child: Text(
        'Inicio',
        style: optionStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Text(
      'Pedidos',
      style: optionStyle,
    ),
    Text(
      'Facturación',
      style: optionStyle,
    ),
    Text(
      'Cobros',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 44,
            minHeight: 50,
            maxWidth: 64,
            maxHeight: 64,
          ),
          child: Image.asset(
            'images/mERP.png',
            alignment: (Alignment.center),
          ),
        ),
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Amplify.Auth.signOut()
                  .then((_) => {Navigator.pushReplacementNamed(context, '/')});
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      // body: Column(
      //   children: <Widget>[
      //     SizedBox(
      //       height: 70,
      //     ),
      //     Flexible(
      //       child: Image.asset(
      //         'images/MyappSoftware Logo.PNG',
      //         height: 500,
      //         width: 800,
      //       ),
      //     )
      //   ],
      // ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.black54,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Pedidos',
            backgroundColor: Colors.black54,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_rounded),
            label: 'Facturación',
            backgroundColor: Colors.black54,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_rounded),
            label: 'Cobros',
            backgroundColor: Colors.black54,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
