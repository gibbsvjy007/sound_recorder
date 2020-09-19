import 'package:flutter/material.dart';

import 'modules/home/home.page.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recording Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePage(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
