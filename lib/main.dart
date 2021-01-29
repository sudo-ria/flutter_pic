import 'package:flutter/material.dart';
import 'package:flutter_pic/widget_input_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
          Column(
            children: [
            Container(
              height: 100,
            width: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 10)),
            ),
            InputImage()
        ],
      )
    );
  }
}
