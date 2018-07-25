import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return ListView(
//      padding: EdgeInsets.all(20.0),
//      shrinkWrap: true, // CHECK this ???
//      children: getTeams(),
//    );
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('objectives')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: const Text(
                'Loading...',
                textAlign: TextAlign.center,
              ),
            );
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
          );
        });
  }

  Widget _buildStatusIcon(context, status) {
    switch (status) {
      case 0:
        return Icon(
          Icons.remove_circle_outline,
          color: Theme.of(context).primaryColor,
        );
      case 1:
        return Icon(
          Icons.radio_button_checked,
          color: Theme.of(context).primaryColor,
        );
      case 2:
        return Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        );
      default:
        return Icon(
          Icons.check_circle_outline,
          color: Theme.of(context).primaryColor,
        );
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot objective) {
    return Card(
      key: Key(objective.documentID),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildStatusIcon(context, objective['Status']),
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  Text('${objective['Team']}'),
                  ExpansionTile(
                    title: Text('${objective['Title']}'),
                    trailing: Text('Date goes here'),
                    children: <Widget>[
                      Text(
                        objective['Description'].toString(),
//                maxLines: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
