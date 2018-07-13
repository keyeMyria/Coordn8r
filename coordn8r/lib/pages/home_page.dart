import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'dart:async';
import 'dart:io';

class HomePage extends StatelessWidget {
  static String tag = '/home_page';

  Future<void> _logoutDialog(context) {
    final bool canPop = Navigator.canPop(context);

    final String dialogText =
        canPop ? 'Going back will log you out.' : 'This will close the app.';

    showDialog(
      context: context,
//          barrierDismissible: false, // must press button
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text(dialogText),
          actions: <Widget>[
            FlatButton(
              onPressed: () => canPop
                  ? Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.tag, ModalRoute.withName('/'))
                  : exit(0),
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            )
          ],
        );
      },
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => _logoutDialog(context),
      child: new DefaultTabController(
        length: 4,
        child: new Scaffold(
          drawer: Drawer(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: Text('email'),
                  accountName: Text('name'),
                  currentAccountPicture: CircleAvatar(),
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
          ),
          appBar: new AppBar(
            title: new Text('COORDN8R'),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.settings_applications),
                  iconSize: 40.0,
                  color: Colors.white,
                  //TODO set onPressed to open up a menu that lets you log out
                  onPressed: () => //Navigator.of(context).pop(true))
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginPage.tag, ModalRoute.withName('/')))
            ],
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
      ),
    );
  }
}
