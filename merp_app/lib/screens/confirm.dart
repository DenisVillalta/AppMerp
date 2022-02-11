// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class ConfirmScreen extends StatefulWidget {
  final LoginData data;

  const ConfirmScreen({Key? key, required this.data}) : super(key: key);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final _controller = TextEditingController();
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verifyCode(BuildContext context, LoginData data, String code) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: data.name, confirmationCode: code);

      print(res);
      if (res.isSignUpComplete) {
        final user = await Amplify.Auth.signIn(
            username: data.name, password: data.password);

        if (user.isSignedIn) {
          Navigator.pushReplacementNamed(context, '/homePage');
        }
      }
    } on AuthException catch (e) {
      Amplify.Auth.signOut();
      _showError(context, e.message);
    }
  }

  void _resendCode(BuildContext context, LoginData data) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: data.name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text(
              'Confirmation code resent. Check your email',
              style: TextStyle(fontSize: 15),
            )),
      );
    } on AuthException catch (e) {
      _showError(context, e.message);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            message,
            style: TextStyle(fontSize: 15),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Column(
              children: [
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.all(30),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Código de confirmación',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                          onPressed: _isEnabled
                              ? () {
                                  _verifyCode(
                                      context, widget.data, _controller.text);
                                }
                              : null,
                          elevation: 4,
                          color: Theme.of(context).primaryColor,
                          disabledColor: Colors.amber.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Verificar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _resendCode(context, widget.data);
                          },
                          child: Text(
                            'Reenviar código',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
