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

  Widget _buildListItem(BuildContext context, objective) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0)),
      child: ListTile(
        leading: objective['Status'] == 0 // not started
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
        title: Text(
          objective['Title'].toString(),
        ),
        subtitle: Text(
          objective['Description'].toString(),
        ),
      ),
    );
  }
}
