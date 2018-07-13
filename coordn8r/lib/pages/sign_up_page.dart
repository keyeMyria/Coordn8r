import 'package:coordn8r/pages/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static String tag = '/sign_up_page';

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: Center(
        child: ListView(
          primary: false, // does not try to scroll if page is not filled
          shrinkWrap: true,
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
                key: _signUpFormKey,
                child: Container(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                hintText: 'Jane',
                              ),
                              keyboardType: TextInputType.text,
                              autofocus: false,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            // must have this to not produce error
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Doe',
                              ),
                              keyboardType: TextInputType.text,
                              autofocus: false,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "jane.doe@example.com",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        validator: (value) =>
                            value.isEmpty || !value.contains('@')
                                ? 'Please enter valid email'
                                : null,
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autofocus: false,
                        validator: (value) => value.isEmpty
                            ? 'Please enter valid password'
                            : null,
                        onSaved: (val) {},
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        autofocus: false,
                        validator: (value) => value.length < 6
                            ? 'Password must be 6 characters'
                            : (value == _password
                                ? 'Passwords do not match'
                                : null),
                        onSaved: (val) {},
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          minWidth: 200.0,
                          height: 50.0,
                          onPressed: () {
                            // TODO: implement on pressed for sign up button
                          },
                          color: Theme.of(context).buttonColor,
                          child: Text(
                            "Create Account",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account?'),
                FlatButton(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  splashColor: Colors.grey,
                  child: Text("Log in"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
