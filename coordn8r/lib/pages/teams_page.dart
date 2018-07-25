import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:coordn8r/my_expansion_tile.dart';
import 'package:intl/intl.dart';

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

  Widget _buildListItem(BuildContext context, DocumentSnapshot objective) {
    return Card(
      key: Key(objective.documentID),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Container(
          padding: const EdgeInsets.only(
            top: 12.0,
            right: 12.0,
            bottom: 12.0,
          ),
          child: new Objective(
            objective: objective,
          )),
    );
  }
}

class Objective extends StatefulWidget {
  const Objective({
    Key key,
    this.objective,
  }) : super(key: key);

  final DocumentSnapshot objective;

  @override
  State<Objective> createState() => ObjectiveState();
}

class ObjectiveState extends State<Objective> {
  bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = true;
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildStatusIcon(
              Theme.of(context).primaryColor, widget.objective['Status'], 26.0),
          flex: 1,
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${widget.objective['Team']}',
                        softWrap: !_hidden,
                        overflow: _hidden ? TextOverflow.ellipsis : null,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat('h:mm a')
                                .format(DateTime.now())
                                .toLowerCase() +
                            '\n' +
                            DateFormat('M/d/yy').format(DateTime.now()),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
              MyExpansionTile(
                key: PageStorageKey(widget.objective.documentID),
                // keep expanded when scrolled out of view
                title: Text(
                  '${widget.objective['Title']}',
                  maxLines: _hidden ? 2 : null,
                  overflow: _hidden ? TextOverflow.ellipsis : null,
                ),
                expansionPadding: const EdgeInsets.only(left: 0.0),
                bottomBorder: true,
                titleColor: Theme.of(context).textTheme.subhead.color,
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _hidden = false;
                    } else {
                      _hidden = true;
                    }
                  });
                },
                children: <Widget>[
                  Text(
                    '${widget.objective['Description']}',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
