import 'package:flutter/material.dart';
import 'package:service_background/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();      // important
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

