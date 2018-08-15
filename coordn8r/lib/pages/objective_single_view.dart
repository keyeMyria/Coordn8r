import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ObjectiveSingleView extends StatelessWidget {
  static String tag = '/objective_single_view';

  const ObjectiveSingleView({
    Key key,
    @required this.objective,
  }) : super(key: key);

  final DocumentSnapshot objective;

  @override
  Widget build(BuildContext context) {
    const List<String> _statusString = [
      'Not Started',
      'In Progress',
      'Finished',
    ];

    DateTime _deadline =
        DateTime.fromMillisecondsSinceEpoch(objective['Deadline']);

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Objective'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            primary: false,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                )),
                child: Hero(
                  tag: 'team' + objective.documentID,
                  child: Text(
                    '${objective['Team']}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 24.0),
                  ),
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
                      .copyWith(fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${DateFormat('h:mm a').format(
                      _deadline).toLowerCase()} ${_deadline.timeZoneName}\n${DateFormat(
                      'M/d/yy').format(_deadline)}',
                    style: TextStyle(
                      color: DateTime.now().isBefore(_deadline)
                          ? Theme.of(context).textTheme.body1.color
                          : Colors.red,
                      fontWeight: DateTime.now().isBefore(_deadline)
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_statusString[objective['Status'].clamp(
                        0, 2)]}',
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                objective['Description'],
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
