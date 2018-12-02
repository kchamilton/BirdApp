import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'Bird.dart';
import 'getBirdData.dart';

void main() => runApp(MyApp());

BirdData birdData;

class MyApp extends StatelessWidget {
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bird's Eye View",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Bird's Eye View"),
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
  Future<List<Bird>> birdFuture;

  BirdData birdData = new BirdData();

  NumberPicker searchRadiusPicker;
  NumberPicker daysPicker;

  int searchRadius = 5;
  int searchDays = 4;

  var latitude;
  var longitude;


  Future<void> getLocation() async{
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      latitude = currentLocation["latitude"];
      longitude = currentLocation["longitude"];

      print("Lat/long Found -=-=-=-=-=-=-=-=-=-=-=-=-=" + latitude.toString());

    } on PlatformException {
      currentLocation = null;
    }
  }

  _handleSearchChanged(num value){
    if(value != null){
      setState(() {
        searchRadius = value;
        birdFuture = null;
        birdFuture = fetchPost(
          latitude: latitude,
          longitude: longitude,
          distance: searchRadius,
          days: searchDays,
        );
      });
    }
  }
  _handleDaysChanged(num value){
    if(value != null){
      setState(() {
        searchDays = value;
        birdFuture = null;
        birdFuture = fetchPost(
          latitude: latitude,
          longitude: longitude,
          distance: searchRadius,
          days: searchDays,
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    birdData = new BirdData();
    var test = getLocation();
    test.then((onValue){
      birdFuture = fetchPost(
        latitude: latitude,
        longitude: longitude,
        distance: searchRadius,
        days: searchDays,
      );
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    searchRadiusPicker = new NumberPicker.integer(
      initialValue: searchRadius,
      minValue: 1,
      maxValue: 50,
      onChanged:_handleSearchChanged,
    );
    daysPicker = new NumberPicker.integer(
      initialValue: searchDays,
      minValue: 1,
      maxValue: 30,
      onChanged:_handleDaysChanged,
    );
    //birdFuture = fetchPost();

    return Scaffold(
      appBar: AppBar(
       title: Text(widget.title),
      ),
      body: Center(
       child: FutureBuilder<List<Bird>>(
         future: birdFuture,
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             return birdData.scrollingBirdList(snapshot.data);
           } else if (snapshot.hasError) {
             return Text("${snapshot.error}");
           }
           // By default, show a loading spinner
           return CircularProgressIndicator();
         },
         ),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: new Image.asset("icon/icon.png"),
            ),
            Card (
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Title(
                        color: Colors.black,
                        child: new Text("Search Distance"),
                    ),
                    searchRadiusPicker,
                  ],
              ),
            ),
            Card(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Title(
                    color: Colors.black,
                    child: new Text("Days to Search"),
                  ),
                  daysPicker,
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}