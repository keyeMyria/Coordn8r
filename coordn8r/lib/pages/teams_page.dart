import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:coordn8r/my_expansion_tile.dart';
import 'package:intl/intl.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key key}) : super(key: key);

  @override
  TeamsPageState createState() => TeamsPageState();
}

class TeamsPageState extends State<TeamsPage> {
  Widget _streamContent;
  Widget _objectiveContent;
  bool _stream;
  BuildContext
      _teamsPageContext; // Need this for the page storage -- not sure why but it works

  @override
  void initState() {
    super.initState();
    _teamsPageContext = context;
    DocumentSnapshot oldObjective = PageStorage
        .of(_teamsPageContext)
        .readState(_teamsPageContext, identifier: ValueKey('open'));
    _objectiveContent = oldObjective != null
        ? Stack(
            children: <Widget>[
              ObjectiveFullPage(
                objective: oldObjective,
              ),
              FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _stream = true;
                      _objectiveContent = null;
                      PageStorage.of(_teamsPageContext).writeState(
                          _teamsPageContext, null,
                          identifier: ValueKey('open'));
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'))
            ],
          )
        : null;
    _stream = true;
  }

  @override
  void dispose() {
    super.dispose();
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
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: const Text(
                'Loading...',
                textAlign: TextAlign.center,
              ),
            );
          return _objectiveContent ??
              ListView.builder(
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

    // final key = Key(objective.documentID);
    return Card(
      key: Key(objective.documentID),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
//        onTap: () {},
//        onDoubleTap: () {},
        onLongPress: () {
          setState(() {
            _objectiveContent = Stack(
              children: <Widget>[
                ObjectiveFullPage(
                  objective: objective,
                ),
                FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        _stream = true;
                        _objectiveContent = null;
                        PageStorage.of(_teamsPageContext).writeState(
                            _teamsPageContext, null,
                            identifier: ValueKey('open'));
                      });
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back'))
              ],
            );
            _stream = false;
            PageStorage.of(_teamsPageContext).writeState(
                _teamsPageContext, objective,
                identifier: ValueKey('open'));
          });
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat('h:mm a')
                                .format(DateTime.now())
                                .toLowerCase() +
                            '\n' +
                            DateFormat('M/d/yy').format(DateTime.now()),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 12.0),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontSize: 14.0),
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

class ObjectiveFullPage extends StatelessWidget {
  const ObjectiveFullPage({
    Key key,
    @required this.objective,
  }) : super(key: key);

  final DocumentSnapshot objective;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(objective['Title']),
            SizedBox(
              height: 20.0,
            ),
            Text(objective['Team']),
            SizedBox(
              height: 20.0,
            ),
            Text(objective['Description']),
          ],
        ),
      ),
    );
  }
}
