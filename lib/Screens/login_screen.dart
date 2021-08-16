// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/Factories/alert_dialog_factory.dart';
import 'package:fisheri/Factories/snack_bar_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../design_system.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _emailTextFieldValue;
  String _passwordTextFieldValue;
  String _emailErrorText;
  String _passwordErrorText;

  bool _emailAndPasswordHaveValues() {
    return (_emailTextFieldValue != null && _emailTextFieldValue.isNotEmpty) &&
        (_passwordTextFieldValue != null && _passwordTextFieldValue.isNotEmpty);
  }

  void _loginAction() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _emailTextFieldValue, password: _passwordTextFieldValue)
        .catchError((onError) async {
      print('error signing in: $onError');
      final error = onError as FirebaseAuthException;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogFactory.generic(context: context, message: error.message);
        },
      );
    }).then((userCredential) {
      if (userCredential != null) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        SnackBarFactory.standard(
            title: 'Welcome Back',
            message: 'signed in as ${userCredential.user.email}',
            position: SnackPosition.TOP
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DSComponents.header(text: 'Email'),
              DSComponents.singleSpacer(),
              CupertinoTextField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (input) {
                  setState(() {
                    _emailTextFieldValue = input;
                  });
                },
              ),
              Container(
                height: 20,
                child: Visibility(
                  visible:
                  _emailErrorText != null && _emailErrorText.isNotEmpty,
                  child: DSComponents.body(
                      text: _emailErrorText ?? '', color: Colors.red),
                ),
              ),
              DSComponents.doubleSpacer(),
              DSComponents.header(text: 'Password'),
              DSComponents.singleSpacer(),
              CupertinoTextField(
                autocorrect: false,
                obscureText: true,
                onChanged: (input) {
                  setState(() {
                    _passwordTextFieldValue = input;
                  });
                },
              ),
              Container(
                height: 20,
                child: Visibility(
                  visible: _passwordErrorText != null &&
                      _passwordErrorText.isNotEmpty,
                  child: DSComponents.body(
                      text: _passwordErrorText ?? '', color: Colors.red),
                ),
              ),
              DSComponents.doubleSpacer(),
              DSComponents.primaryButton(
                  text: 'Sign in',
                  onPressed: _emailAndPasswordHaveValues()
                      ? _loginAction
                      : null),
              DSComponents.sectionSpacer(),
              DSComponents.subheaderSmall(
                text: 'Additional methods of authentication will be available in a future release',
                color: Colors.red,
              ),
              DSComponents.doubleSpacer(),
              CupertinoButton(
                color: DSColors.black,
                child: Text('Sign in with Apple'),
                disabledColor: DSColors.black.withOpacity(0.20),
              ),
              DSComponents.doubleSpacer(),
              CupertinoButton(
                color: DSColors.black,
                child: Text('Sign in with Google'),
                disabledColor: DSColors.black.withOpacity(0.20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}