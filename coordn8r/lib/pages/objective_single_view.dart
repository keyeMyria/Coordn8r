import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ObjectiveSingleView extends StatelessWidget {
  static String tag = '/objective_single_view';

  const ObjectiveSingleView({
    Key key,
    @required this.objective,
  }) : super(key: key);

  final DocumentSnapshot objective;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Objective'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                Hero(
                  tag: 'team' + objective.documentID,
                  child: Text(
                    '${objective['Team']}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16.0),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Hero(
                  tag: 'title' + objective.documentID,
                  child: Text(
                    '${objective['Title']}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(objective['Description']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
