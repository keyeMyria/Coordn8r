import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:coordn8r/my_expansion_tile.dart';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  Widget _buildStatusIcon(color, status, [iconSize]) {
    switch (status) {
      case 0:
        return Icon(
          Icons.remove_circle_outline,
          color: color,
          size: iconSize,
        );
      case 1:
        return Icon(
          Icons.radio_button_checked,
          color: color,
          size: iconSize,
        );
      case 2:
        return Icon(
          Icons.check_circle,
          color: color,
          size: iconSize,
        );
      default:
        return Icon(
          Icons.error,
          color: color,
          size: iconSize,
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
              child: _buildStatusIcon(
                  Theme.of(context).primaryColor, objective['Status'], 26.0),
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '${objective['Team']}',
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text('Date goes here'),
                        ),
                      ),
                    ],
                  ),
                  MyExpansionTile(
                    title: Text(
                      '${objective['Title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expansionPadding: const EdgeInsets.only(left: 0.0),
                    topBorder: true,
                    titleColor: Theme.of(context).textTheme.subhead.color,
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
