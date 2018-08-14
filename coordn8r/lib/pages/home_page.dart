import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/sign_up_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  static final String tag = '/home_page';
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageStorageKey _teamsPageKey = PageStorageKey('teamsPage');
  int _index;
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _pages = [
      TeamsPage(
        key: _teamsPageKey,
      ),
      Center(
        child: Icon(
          Icons.calendar_today,
          color: Colors.blueAccent,
        ),
      ),
      Center(
        child: Icon(
          Icons.fiber_new,
          color: Colors.blueAccent,
        ),
      ),
      Center(
        child: Icon(
          Icons.account_box,
          color: Colors.blueAccent,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                  accountName: Text(user.displayName ??
                      SignUpPageState.firstNameSignUp +
                          ' ' +
                          SignUpPageState.lastNameSignUp),
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
                        top: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: ListTile(
                      title: Text('Log Out'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Platform.isIOS
                              ? CupertinoAlertDialog(
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
                              : AlertDialog(
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
                                      textColor: Theme.of(context).buttonColor,
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      textColor: Theme.of(context).buttonColor,
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
      appBar: AppBar(
        title: Text('COORDN8R'),
      ),
      body: SafeArea(
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (newIndex) => setState(() {
              _index = newIndex;
            }),
        fixedColor: Theme.of(context).iconTheme.color,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Text('New'),
            icon: Icon(
              CommunityMaterialIcons.group,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Calendar'),
            icon: Icon(
              Icons.calendar_today,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Teams'),
            icon: Icon(
              Icons.fiber_new,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Account'),
            icon: Icon(
              Icons.account_box,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
