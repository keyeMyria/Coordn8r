import 'package:flutter/material.dart';

import 'package:community_material_icon/community_material_icon.dart';

class TeamsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        iconSize: 30.0,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('TEAMS'),
              icon: Icon(CommunityMaterialIcons.group, color: Colors.orange,)
          ),
          BottomNavigationBarItem(
            title: Text('TO-DO'),
              icon: Icon(Icons.calendar_today, color: Colors.orange,)
          ),
          BottomNavigationBarItem(
            title: Text('FEED'),
              icon: Icon(Icons.fiber_new, color: Colors.orange,)
          ),
          BottomNavigationBarItem(
            title: Text('USER'),
              icon: Icon(Icons.account_box, color: Colors.orange,)
          ),
        ],
      ),
    );
  }
}