import 'package:flutter/material.dart';

import 'Bird.dart';

void main() => runApp(MyApp());

BirdData birdData;

class MyApp extends StatelessWidget {
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() =>
    _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List<Bird> birdList = [
    Bird("grbher3", "Great Blue Herron",
      "Ardea herodias", "L6439105", "Ole Colony GC", "2018-11-30 16:44",
      2, 33.2566041, -87.5382442, true, false, true),
    Bird("grbher3", "Great Red Herron",
        "Ardea herodias", "L6439105", "Ole Colony GC", "2018-11-26 16:44",
        2, 33.2566041, -87.5382442, true, false, true),
    Bird("grbher3", "Great Green Herron",
        "Ardea herodias", "L6439105", "Ole Colony GC", "2018-11-28 16:44",
        2, 33.2566041, -87.5382442, true, false, true),];
  @override
  void initState() {
    // TODO: implement initState
    birdData = new BirdData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: birdData.scrollingBirdList(birdList),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}