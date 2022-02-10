// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginData _data;
  bool _isSignedIn = false;

  Future<String> _onLogin(LoginData data) async {
    try {
      final res = await Amplify.Auth.signIn(
          username: data.name, password: data.password);

      _data = data;

      _isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      Amplify.Auth.signOut();
      return '${e.message} - ${e.recoverySuggestion}';
    }

    return Future.value('');
  }

  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == "CONFIRM_RESET_PASSWORD_WITH_CODE") {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }

    return null;
  }

  Future<String> _onSignUp(LoginData data) async {
    try {
      await Amplify.Auth.signUp(
          username: data.name,
          password: data.password,
          options: CognitoSignUpOptions(
              userAttributes: {CognitoUserAttributeKey.email: data.name}));
      _data = data;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }

    return Future.value('');
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: 'images/mERP.png',
      title: 'By MyappSoftware',
      onLogin: _onLogin,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSignup: _onSignUp,
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
        titleStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? '/dashboard' : '/confirm',
            arguments: _data);
      },
    );
  }
}
