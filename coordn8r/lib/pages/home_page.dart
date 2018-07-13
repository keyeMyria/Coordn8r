import 'package:coordn8r/pages/login_page.dart';
import 'package:coordn8r/pages/teams_page.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'dart:async';

class HomePage extends StatelessWidget {
  static String tag = 'home_page';

  Future<void> _logoutDialog(context) {
    showDialog(
      context: context,
//          barrierDismissible: false, // must press button
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Going back will log you out.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pushNamed(LoginPage.tag),
              // also Navigator.of(context).pop(true)
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
          appBar: new AppBar(
            leading: new Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                child: Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage("assets/logo/logo48.png"),
                  ),
                ),
                //TODO make this trigger dialog asking whether or not we are sure
                onTap: () => _logoutDialog(context),
              ),
            ),
            title: new Text('COORDN8R'),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.settings_applications),
                  iconSize: 40.0,
                  color: Colors.white,
                  //TODO set onPressed to open up a menu that lets you log out
                  onPressed: () =>
                      Navigator.of(context).pushNamed(LoginPage.tag))
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
