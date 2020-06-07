import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';
import 'package:imdoit/model/data.dart';
import 'package:imdoit/common/to_duration.dart';
import 'package:imdoit/common/circularChart.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/background.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          scale: 0.5,
        ),
        Scaffold(
          backgroundColor: const Color.fromRGBO(52, 52, 52, 1),
          appBar: AppBar(
            title: Text(
              'Immadoit',
              // style: GoogleFonts.getFont('Roboto'),
            ),
            backgroundColor: const Color.fromRGBO(85, 85, 85, 0.2),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed:() => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('add new theme.'),
                    content: TextField(
                      controller: Provider
                          .of<Data>(context, listen: false)
                          .controller,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Provider.of<Data>(context, listen: false).clear();
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.grey,
                        onPressed: () {
                          _addNewTheme(
                              Provider
                                  .of<Data>(context, listen: false)
                                  .controller.text
                          );
                          Provider.of<Data>(context, listen: false).clear();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Themes').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data.documents.map<Widget>(
                        (DocumentSnapshot document) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: '/detail'),
                              builder: (BuildContext context) => DetailPage(
                                title: document['title'],
                                totalTime: document['totalTime'],
                              ),
                            ),
                          ),
                          child:  _themePanel(document),
                        ),
                      );
                    },
                  ).toList(),
                );
              } else {
                return const Text('Sorry...');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _themePanel(DocumentSnapshot document) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: document['frag']
            ? Color.fromRGBO(112, 112, 112, 1)
            : Color.fromRGBO(0, 255, 17, 0.3),
        height: 100,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    document['title'],
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, right: 10),
                  child:  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      document['totalTime'].toString().split('.')[0],
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          width: 10,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),

                  circularChart(
                    size: Size(100, 100),
                    colorProportion: toDuration(
                        document['totalTime']).inHours.toDouble(),
                  ),
                  SizedBox(
                    height: 85,
                    width: 85,
                    child: IconButton(
                      icon: Icon(
                        document['frag']
                            ? Icons.play_arrow
                            : Icons.stop,
                        size: 85,
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                      ),
                      onPressed: () {
                        if (document['frag']){
                          _startTimer(document.documentID);
                        } else {
                          _stopTimer(document.documentID);
                        }
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  }

  Future<void> _addNewTheme(String val) async {
    await Firestore.instance.collection('Themes').add({
      'title': val,
      'tmpTime': '',
      'totalTime': '',
      'frag': true,
    });
  }

  Future<void> _startTimer(String id) async {
    await Firestore
        .instance
        .collection('Themes')
        .document(id)
        .updateData({'tmpTime': DateTime.now().toIso8601String()});
    await Firestore
        .instance
        .collection('Themes')
        .document(id)
        .updateData({'frag': false});
  }

  Future<void> _stopTimer(String id) async {
    final docSnapshot = await Firestore
                                .instance
                                .collection('Themes')
                                .document(id)
                                .get();
    final diff = DateTime.now().difference(
      DateTime.parse(docSnapshot['tmpTime'])
    );

    if (docSnapshot['totalTime'] == '') {
      await Firestore
          .instance
          .collection('Themes')
          .document(id)
          .updateData({'totalTime': diff.toString()});
    } else {
      await Firestore
          .instance
          .collection('Themes')
          .document(id)
          .updateData(
          {'totalTime': (toDuration(docSnapshot['totalTime'])+diff).toString()}
          );

    }

    await Firestore
        .instance
        .collection('Themes')
        .document(id)
        .updateData({'tmpTime': ''});

    await Firestore
        .instance
        .collection('Themes')
        .document(id)
        .updateData({'frag': true});
}
