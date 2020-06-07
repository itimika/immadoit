import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/home.dart';
import 'components/detail_page.dart';
import 'model/data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (_) => Data(),
      child: MaterialApp(
        title: 'Immadoit',
        initialRoute: '/',
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => HomePage(),
          '/detail': (BuildContext context) => DetailPage(),
        },
      ),
    );
  }
}