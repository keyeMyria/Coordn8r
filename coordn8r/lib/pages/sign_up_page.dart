import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static String tag = '/sign_up_page';

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = new GlobalKey<FormState>();
  String _email;
  String _password1;
  String _password2;
  String _errorTextEmail;
  String _errorTextPassword;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();
  }

  void _validateSignUp() async {
    final form = _signUpFormKey.currentState;
    if (form.validate()) {
      form.save();
      _finishSignUp();
    }
  }

  void _finishSignUp() {
    setState(() {
      _errorTextEmail = null;
      _errorTextPassword =
          _password1 != _password2 ? 'Passwords do not match' : null;
    });

    auth
        .createUserWithEmailAndPassword(email: _email, password: _password1)
        .catchError((err) {
      var errorCode = err.toString();
      print("ERROR CODE: " + errorCode);
      setState(() {
        switch (errorCode) {
          case 'auth/email-already-in-use':
            _errorTextEmail =
                'An account is already associated with this email';
            break;
          case 'auth/invalid-email':
            _errorTextEmail = 'Email is invalid';
            break;
          case 'auth/operation-not-allowed':
            _errorTextEmail = 'Unknown Error';
            break;
          case 'auth/weak-password':
            _errorTextPassword = 'Weak Password';
            break;
          default:
            print(errorCode);
            break;
        }
      });
      return;
    });
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
                              validator: (value) => value.isEmpty
                                  ? 'Please enter your first name'
                                  : null,
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
                              validator: (value) => value.isEmpty
                                  ? 'Please enter your last name'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "jane.doe@example.com",
                          errorText: _errorTextEmail,
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
                          errorText: _errorTextPassword,
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.remove_red_eye,
                              color: _obscureText1
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            onTap: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText1,
                        autofocus: false,
                        validator: (value) => value.length < 6
                            ? 'Password must be 6 characters'
                            : null,
                        onSaved: (val) => _password1 = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          errorText: _errorTextPassword,
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.remove_red_eye,
                              color: _obscureText2
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            onTap: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText2,
                        autofocus: false,
                        validator: (value) => value.length < 6
                            ? 'Password must be 6 characters'
                            : null,
                        onSaved: (val) => _password2 = val,
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
                            _validateSignUp();
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
