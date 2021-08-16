// @dart=2.9

import 'package:fisheri/Screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../coordinator.dart';
import '../design_system.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _Logo('images/logo.png'),
                Expanded(
                    child: Column(
                      children: [
                    // _Button(
                    //   title: 'Log In With Google',
                    //   backgroundColor: Colors.red,
                    //   textColor: Colors.white,
                    // ),
                    // _Button(
                    //   title: 'Log In With Facebook',
                    //   backgroundColor: Colors.blue,
                    //   textColor: Colors.white,
                    // ),
                        DSComponents.primaryButton(
                            text: 'Sign in',
                            onPressed: () {
                              Coordinator.present(
                                  context,
                                  screenTitle: 'Sign in',
                                  screen: LoginScreen()
                              );
                            }
                        ),
                        DSComponents.sectionSpacer(),
                        DSComponents.secondaryButton(
                            text: 'Register',
                            onPressed: () {
                              Coordinator.present(
                                  context,
                                  screenTitle: 'Register',
                                  screen: RegisterScreen()
                              );
                            }
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}

class _Logo extends StatelessWidget {
  _Logo(this.imageURL);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Image.asset(
        imageURL,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
      ),
    );
  }
}