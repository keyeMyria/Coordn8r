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

  Widget _buildListItem(BuildContext context, DocumentSnapshot objective) {
    return Card(
      key: Key(objective.documentID),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          trailing: objective['Status'] == 0 // not started
              ? Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).primaryColor,
                )
              : (objective['Status'] == 1 // in progress
                  ? Icon(
                      Icons.remove_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(
                      // finished
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )),
          title: Text('${objective['Team']}'),
          subtitle: ExpansionTile(
            title: Text('${objective['Title']}'),
            trailing: Text('Date goes here'),
            children: <Widget>[
              Text(
                objective['Description'].toString(),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
