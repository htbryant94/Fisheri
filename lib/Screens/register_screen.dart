import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/Factories/alert_dialog_factory.dart';
import 'package:fisheri/Factories/snack_bar_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design_system.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _emailTextFieldValue;
  String _passwordTextFieldValue;
  String _emailErrorText;
  String _passwordErrorText;

  bool _emailAndPasswordHaveValues() {
    return (_emailTextFieldValue != null && _emailTextFieldValue.isNotEmpty) &&
        (_passwordTextFieldValue != null && _passwordTextFieldValue.isNotEmpty);
  }

  Function _createAccountAction() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: _emailTextFieldValue, password: _passwordTextFieldValue)
        .catchError((onError) {
      _emailErrorText = null;
      _passwordErrorText = null;

      final _error = onError as FirebaseAuthException;

      switch (_error.code) {
        case 'invalid-email':
          setState(() {
            _emailErrorText = _error.message;
          });
          break;
        case 'weak-password':
          setState(() {
            _passwordErrorText = _error.message;
          });
          break;
      }
    }).then((userCredential) {
      if (userCredential != null) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        SnackBarFactory.standard(
          title: 'Welcome!',
          message: 'account created with username ${userCredential.user.email}',
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
              DSComponents.paragraphSpacer(),
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
              DSComponents.sectionSpacer(),
              DSComponents.primaryButton(
                  text: 'Create Account',
                  onPressed: _emailAndPasswordHaveValues()
                      ? _createAccountAction
                      : null),
            ],
          ),
        ),
      ),
    );
  }
}