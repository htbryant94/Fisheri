import 'package:flutter/material.dart';
import 'package:fisheri/house_colors.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            _Logo('images/logo.png'),
            Expanded(
                child: Column(
              children: [
                _Button(title: 'Log In With Google', backgroundColor: Colors.red, textColor: Colors.white),
                _Button(title: 'Log In With Facebook', backgroundColor: Colors.blue, textColor: Colors.white),
                _Button(title: 'Log In With Email', backgroundColor: HouseColors.accentGreen, textColor: HouseColors.primaryGreen),
                _Button(title: 'Sign Up', backgroundColor: HouseColors.primaryGreen, textColor: HouseColors.accentGreen),
              ],
            )),
          ],
        ));
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

class _Button extends StatelessWidget {
  _Button({
    Key key,
    this.title,
    this.backgroundColor,
    this.textColor}) : super(key: key);

  final String title;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: 250,
        height: 48,
        child: RaisedButton(
          color: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {},
          child: Text(title, style: TextStyle(fontSize: 18, color: textColor)),
        ),
      ),
    );
  }
}
