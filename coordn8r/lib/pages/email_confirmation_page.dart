// import statements

import 'dart:async';

import 'package:coordn8r/pages/home_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EmailConfirmationPage extends StatefulWidget {
  static String tag = '/email_confirmation_page';

  @override
  State<StatefulWidget> createState() => EmailConfirmationState();
}

class EmailConfirmationState extends State<EmailConfirmationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You must verify your email. Tap to send email verification.'),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                height: 50.0,
                child: Text('Send'),
                onPressed: () => user
                    .sendEmailVerification()
                    .then((_) => Timer.periodic(Duration(seconds: 5), (timer) {
                          user.reload().then((_) => print(
                              'Is email verifired? ' +
                                  user.isEmailVerified.toString()));
                          print('Is email verified? ' +
                              user.isEmailVerified.toString());
                          if (user.isEmailVerified) {
                            timer.cancel();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HomePage.tag, ModalRoute.withName('/'));
                          }
                        })),
              ),
            ),
            Icon(Icons.email),
          ],
        ),
      ),
    );
  }
}
