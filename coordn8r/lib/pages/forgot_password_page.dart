import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  static final String tag = '/forgot_password_page';

  @override
  State<StatefulWidget> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _forgotPasswordFormKey =
      new GlobalKey<FormState>();
  String _email;
  String _errorText;
  bool _sendingEmailInProgress = false;
  bool _sendingFinished = false;

  void _sendEmail() {
    final form = _forgotPasswordFormKey.currentState;
    if (form.validate()) {
      setState(() {
        _sendingEmailInProgress = true;
      });
      form.save();
      auth
          .sendPasswordResetEmail(email: _email)
          .then((_) => setState(() {
                _errorText = null;
                _sendingFinished = true;
              }))
          .catchError((error) => setState(() {
                _errorText = error.message;
                _errorText = _errorText.substring(0, _errorText.indexOf('.'));
                _sendingEmailInProgress = false;
              }));
    }
  }

  @override
  void initState() {
    _sendingEmailInProgress = false;
    _sendingFinished = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              primary: false,
              shrinkWrap: true, // this plus "Center" centers everything
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/logo/logo96.png"),
                    height: 96.0,
                    width: 96.0,
                  ),
                ),
                Form(
                  key: _forgotPasswordFormKey,
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Please enter your email and click \"Send\" to '
                              'reset your password.',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "jane.doe@example.com",
                              errorText: _errorText),
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          validator: (value) =>
                              value.isEmpty || !value.contains('@')
                                  ? 'Please enter valid email'
                                  : null,
                          onSaved: (val) => _email = val,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(30.0),
                          child: MaterialButton(
                            minWidth: 200.0,
                            height: 50.0,
                            onPressed:
                                _sendingEmailInProgress ? null : _sendEmail,
                            color: Theme.of(context).buttonColor,
                            child: _sendingEmailInProgress && _sendingFinished
                                ? Icon(
                                    Icons.check,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .button
                                        .color,
                                    size: 30.0,
                                  )
                                : (_sendingEmailInProgress
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Theme
                                                .of(context)
                                                .textTheme
                                                .button
                                                .color),
                                      )
                                    : Text(
                                        "Send",
                                        style:
                                            Theme.of(context).textTheme.button,
                                      )),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 25.0,
            left: 10.0,
            child: BackButton(
              color: Theme.of(context).buttonColor,
            ),
          ),
        ],
      ),
    );
  }
}
