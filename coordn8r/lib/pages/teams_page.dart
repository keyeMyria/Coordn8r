import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordn8r/pages/pre_login_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:coordn8r/my_expansion_tile.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key key}) : super(key: key);

  @override
  TeamsPageState createState() => TeamsPageState();
}

class TeamsPageState extends State<TeamsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animationSize;
  Animation<double> _animationPos;
  final Duration _duration = const Duration(milliseconds: 500);

//  final Duration _duration1 = const Duration(seconds: 1);
//  final Duration _duration2 = const Duration(seconds: 2);

  double _x = 0.0, _y = 0.0, _h = 0.0, _w = 0.0, _w0 = 0.0;

  List<Widget> _stack;
  bool _showFullPage;

  Widget _backButton;
  BuildContext
      _teamsPageContext; // Need this for the page storage -- not sure why but it works

  @override
  void initState() {
    super.initState();
    _showFullPage = false;

    // Widgets & Stack
    // ============================================
    _backButton = FlatButton.icon(
      onPressed: () {
        setState(() {
//          _showFullPage = false;
          _controller.reverse();
          PageStorage.of(_teamsPageContext).writeState(_teamsPageContext, null,
              identifier: ValueKey('open'));
        });
      },
      color: Colors.white,
      shape: StadiumBorder(
          side: BorderSide(
        color: Colors.black12,
      )),
      icon: Icon(Icons.arrow_back),
      label: Text('Back'),
    );

    _teamsPageContext = context;
    DocumentSnapshot oldObjective = PageStorage
        .of(_teamsPageContext)
        .readState(_teamsPageContext, identifier: ValueKey('open'));

    _stack = [
      oldObjective != null
          ? ObjectiveFullPage(
              objective: oldObjective,
            )
          : null,
      _backButton
    ];

    print(_stack);

    // Animation
    // ================================================
    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        print(status);
        if (status == AnimationStatus.forward)
          setState(() {
            _showFullPage = true;
          });
        else if (status == AnimationStatus.dismissed)
          setState(() {
            _showFullPage = false;
          });
      });
    _animationSize = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _animationPos = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
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
          return Stack(
            children: <Widget>[
              ListView.builder(
                primary: false,
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              ),
              Positioned(
                top: _animationPos.value * (_y - 90.0 + 12.0),
                left: _animationPos.value * (_x + 12.0),
                height: _animationSize.value * _h,
                width: _w0 + _animationSize.value * (_w - _w0),
                child: _showFullPage
                    ? Stack(
                        children: _stack,
                      )
                    : Container(
                        color: Colors.white,
                      ),
              ),
            ],
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

    final GlobalKey<TeamsPageState> key = GlobalKey<TeamsPageState>();
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: GestureDetector(
//        onTap: () {},
//        onDoubleTap: () {},
        onLongPress: () {
          final RenderBox box = key.currentContext?.findRenderObject();
          double x = box.localToGlobal(Offset.zero).dx;
          double y = box.localToGlobal(Offset.zero).dy;
          double w0 = box.size.width;
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;

          print('Position: ${box.localToGlobal(Offset.zero)}');
          print('Size: ${box.size}');
          setState(() {
            _x = x;
            _y = y;
            _h = h;
            _w = w;
            _w0 = w0;
            _stack[0] = ObjectiveFullPage(objective: objective);
            _controller.forward();
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
    return Container(
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
      ),
    );
  }
}
