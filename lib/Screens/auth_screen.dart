import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Image.asset(
                'images/lake.jpg',
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Google',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Facebook',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Log In with Email',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ));
  }
}
