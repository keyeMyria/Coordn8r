import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'dart:async';
import 'dart:io';

class HomePage extends StatefulWidget {
  static String tag = '/home_page';

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _name;

  @override
  void initState() {
    super.initState();
    _name = user.displayName;
    Firestore.instance.collection('users').document(user.uid).get().then((doc) {
      setState(() {
        _name = doc.data['First Name'] + ' ' + doc.data['Last Name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        drawer: Drawer(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(user.email),
                    accountName: Text(_name ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo/logo72.png'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onDetailsPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo/logo48.png'),
                      backgroundColor: Colors.white,
                    ),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Probably Something Here'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Log Out'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Platform.isIOS
                                ? new CupertinoAlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text('You will be logged out.'),
                                    actions: <Widget>[
                                      CupertinoButton(
                                        child: Text('Yes'),
                                        onPressed: () => Navigator
                                            .of(context)
                                            .pushNamedAndRemoveUntil(
                                                LoginPage.tag,
                                                ModalRoute.withName('/')),
                                      ),
                                      CupertinoButton(
                                        child: Text('No'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  )
                                : new AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text('You will be logged out.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Yes'),
                                        onPressed: () => Navigator
                                            .of(context)
                                            .pushNamedAndRemoveUntil(
                                                LoginPage.tag,
                                                ModalRoute.withName('/')),
                                        textColor:
                                            Theme.of(context).buttonColor,
                                      ),
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        textColor:
                                            Theme.of(context).buttonColor,
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text('COORDN8R'),
        ),
        body: new SafeArea(
          child: new TabBarView(
            children: [
              new TeamsPage(),
              new Icon(
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
              ),
              new Icon(
                Icons.fiber_new,
                color: Theme.of(context).primaryColor,
              ),
              new Icon(
                Icons.account_box,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        bottomNavigationBar: new TabBar(
          labelColor: Theme.of(context).indicatorColor,
          unselectedLabelColor: Color(0xFF74542A),
          tabs: [
            new Tab(
                icon: new Icon(
              CommunityMaterialIcons.group,
            )),
            new Tab(
                icon: new Icon(
              Icons.calendar_today,
            )),
            new Tab(
                icon: new Icon(
              Icons.fiber_new,
            )),
            new Tab(
                icon: new Icon(
              Icons.account_box,
            )),
          ],
        ),
      ),
    );
  }
}
