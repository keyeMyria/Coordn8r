import 'dart:async';

import 'package:coordn8r/pages/objective_single_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:coordn8r/my_expansion_tile.dart';
import 'package:intl/intl.dart';

class ObjectivesPage extends StatefulWidget {
  const ObjectivesPage({Key key}) : super(key: key);

  @override
  ObjectivesPageState createState() => ObjectivesPageState();
}

class ObjectivesPageState extends State<ObjectivesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('objectives')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
              constraints: BoxConstraints.expand(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: const Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          return ListView.builder(
            primary: false,
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot objective) {
    List<IconData> _iconList = [
      Icons.remove_circle_outline,
      Icons.radio_button_checked,
      Icons.check_circle,
      Icons.error,
    ];

    final Objective _obj = Objective(
      objective: objective,
      iconList: _iconList,
    );

    List<IconSlideAction> _actions = [];
    List<IconSlideAction> _secondaryActions = [];

    objective['Status'] < 2
        ? _actions.add(IconSlideAction(
            color: Theme.of(context).primaryColor,
            icon: _iconList[2],
            caption: 'Finished',
          ))
        : null;

    objective['Status'] < 1
        ? _actions.add(IconSlideAction(
            color: Theme.of(context).buttonColor,
            icon: _iconList[1],
            caption: 'In Progress',
          ))
        : null;

    objective['Status'] == 2
        ? _secondaryActions.add(IconSlideAction(
            color: Theme.of(context).errorColor,
            icon: Icons.delete,
            caption: 'Delete',
          ))
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
//        onTap: () {},
//        onDoubleTap: () {},
        onLongPress: () {
          Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ObjectiveSingleView(
                        objective: objective,
                      ),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                            opacity: Tween(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(CurvedAnimation(
                                parent: animation, curve: Curves.easeOut)),
                            child: child,
                          ),
                ),
              );
        },
        child: Slidable(
          key: Key(objective.documentID + 'slide'),
          closeOnScroll: false,
          slideToDismissDelegate: SlideToDismissDrawerDelegate(
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.primary: 1.0,
            },
            onWillDismiss: (a) {
              return false;
            },
          ),
          actionExtentRatio: 0.25,
          showAllActionsThreshold: 0.75,
          delegate: SlidableDrawerDelegate(),
          child: Container(
            padding: const EdgeInsets.only(
              top: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: _obj,
          ),
          actions: _actions,
          secondaryActions: _secondaryActions,
        ),
      ),
    );
  }
}

class Objective extends StatefulWidget {
  const Objective({
    Key key,
    this.objective,
    this.iconList,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final DocumentSnapshot objective;
  final List<IconData> iconList;
  final Duration duration;

  @override
  State<Objective> createState() => ObjectiveState();
}

class ObjectiveState extends State<Objective> {
  bool _passedDeadline;

  @override
  void initState() {
    super.initState();
  }

  void checkDeadline(time) {
    if (time.isAfter(DateTime.now()))
      Timer(time.difference(DateTime.now()), () => checkDeadline(time));
    else
      setState(() {
        _passedDeadline = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _objectiveTime =
        DateTime.fromMillisecondsSinceEpoch(widget.objective['Deadline']);
    _passedDeadline = _objectiveTime.isBefore(DateTime.now());
    if (!_passedDeadline) checkDeadline(_objectiveTime);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Icon(
            widget.iconList[widget.objective['Status'] >= 0 &&
                    widget.objective['Status'] < 4
                ? widget.objective['Status']
                : 3],
            color: Theme.of(context).primaryColor,
            size: 26.0,
          ),
          flex: 1,
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Hero(
                      tag: 'team' + widget.objective.documentID,
                      child: Text(
                        '${widget.objective['Team']}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('h:mm a ')
                              .format(_objectiveTime)
                              .toLowerCase() +
                          '\n' +
                          DateFormat('M/d/yy').format(_objectiveTime),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: _passedDeadline
                          ? Theme.of(context).textTheme.subhead.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )
                          : Theme
                              .of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              MyExpansionTile(
                key: PageStorageKey(widget.objective.documentID),
                // keep expanded when scrolled out of view
                title: Hero(
                  tag: 'title' + widget.objective.documentID,
                  child: Text(
                    '${widget.objective['Title']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 14.0),
                  ),
                ),
                expansionPadding: const EdgeInsets.only(left: 8.0),
                titlePadding: const EdgeInsets.only(left: 8.0),
                bottomBorder: true,
                titleColor: Theme.of(context).textTheme.subhead.color,
                children: <Widget>[
                  Text(
                    '${widget.objective['Description']}',
                    textAlign: TextAlign.justify,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 12.0),
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
