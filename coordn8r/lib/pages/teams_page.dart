import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class TeamsPage extends StatelessWidget {
  final String _obj = 'Objectives';

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
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: const Text(
                'Loading...',
                textAlign: TextAlign.center,
              ),
            );
          return ListView.builder(
            itemCount: snapshot.data[_obj].length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data[_obj][index]),
          );
        });
  }

  Widget _buildListItem(BuildContext context, objective) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          leading: Icon(
            Icons.check,
            color: Colors.orange,
          ),
          title: Text(
            objective['Title'].toString(),
          ),
          subtitle: Text(
            objective['Description'].toString(),
          ),
        ),
      ),
    );
  }
}
