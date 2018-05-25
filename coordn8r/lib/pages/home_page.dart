import 'package:flutter/material.dart';

import 'package:community_material_icon/community_material_icon.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Coordn8r'),
          ),
          body: new TabBarView(
            children: [
              new Icon(CommunityMaterialIcons.group, color: Colors.orange,),
              new Icon(Icons.calendar_today, color: Colors.orange,),
              new Icon(Icons.fiber_new, color: Colors.orange,),
              new Icon(Icons.account_box, color: Colors.orange,),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              new Tab(icon: new Icon(CommunityMaterialIcons.group, color: Colors.orange,)),
              new Tab(icon: new Icon(Icons.calendar_today, color: Colors.orange,)),
              new Tab(icon: new Icon(Icons.fiber_new, color: Colors.orange,)),
              new Tab(icon: new Icon(Icons.account_box, color: Colors.orange,)),
            ],
          ),
        ),
      ),
    );
  }
}