import 'package:flutter/material.dart';

import 'package:imdoit/common/to_duration.dart';
import 'package:imdoit/common/circularChart.dart';

class DetailPage extends StatelessWidget {
  DetailPage({this.title, this.totalTime});

  final String title;
  final String totalTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 50),
          child: SizedBox(
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 128,
                  color: Color.fromRGBO(100, 100, 100, 1),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: const Color.fromRGBO(52, 52, 52, 0.9),
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.white.withOpacity(0.01),
          ),
          extendBodyBehindAppBar: false,
          body: ListView(
            children: <Widget>[
              _buildPanel(
                title:  'Total',
                child: circularChart(
                  size: const Size(300, 300),
                  colorProportion: toDuration(totalTime).inHours.toDouble(),
                ),
              ),
              _buildPanel(
                title:  'Data',
                child: Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey,
                  child: const Center(
                    child: Text('in preparation'),
                  ),
                ),
              ),
              _buildPanel(
                title:  'Todo',
                child: _buildTodo(),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, left: 40),
                child: TextField(
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      iconSize: 36,
                      color: const Color.fromRGBO(112, 112, 112, 1),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide:  BorderSide(
                          color: Color.fromRGBO(112, 112, 112, 1),
                        )
                    ),
                  ),
                ),
              ),
              _buildPanel(
                title:  'Past tasks',
                child: Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey,
                ),
              ),

            ],
          ),
        )
      ],
    );


  }

  Widget _buildPanel({String title, Widget child}) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'roboto',
            ),
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildTodo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_box_outline_blank,
                    size: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      'logo',
                      style: TextStyle(fontSize: 28, fontFamily: 'Roboto'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_box_outline_blank,
                    size: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text('Bloc', style: TextStyle(fontSize: 28)),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
