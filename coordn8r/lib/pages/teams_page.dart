import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            .where("ID", isEqualTo: 'quintonhoffman')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
          );
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: new Text(document['Teams'].toString()),
            ),
            Text("Filler"),
          ],
        ),
      ),
    );
  }
}
