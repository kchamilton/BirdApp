import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'bloc.dart';
import 'package:flutter/services.dart';
import 'Bird.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MyApp());


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

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  BirdData birdData = new BirdData();
  Future<List<Bird>> birdFuture = null;

  NumberPicker searchRadiusPicker;
  NumberPicker daysPicker;

  int searchRadius = 50;
  int searchDays = 30;

  var latitude;
  var longitude;

  @override
  void initState() {
    super.initState();
  }

  Bloc bloc = new Bloc();

  String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contains more then 5 character";
    }
    return null;
  }

  _daysPicker(){
    showDialog<int>(context: context, builder: (context){
      print(searchDays.toString());
      return new NumberPickerDialog.integer(
        minValue: 1,
        maxValue: 55,
        title: new Text("Number of Days to Search"),
        initialIntegerValue: searchDays,
      );
    }).then((value){
      setState((){
        if(value != null)
          searchDays = value;
        bloc.refreshNoLocation(searchRadius, searchDays);
        print(searchDays.toString());
      });
    });
  }
  _distancePicker(){
    showDialog<int>(context: context, builder: (context){
      print(searchDays.toString());
      return new NumberPickerDialog.integer(
        minValue: 1,
        maxValue: 55,
        title: new Text("Distance to Search"),
        initialIntegerValue: searchRadius,
      );
    }).then((value){
      setState(() {
      if(value != null)
        searchRadius = value;
      bloc.refreshNoLocation(searchRadius, searchDays);
      print(searchRadius.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: bloc.fetchLocation(), builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done)
        bloc.refreshNoLocation(searchRadius, searchDays);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                        child: RaisedButton(
                            onPressed: (){
                              _daysPicker();
                            },
                            color: Theme
                                .of(context)
                                .accentColor,
                            child: Text("${searchDays.toString()} days", textAlign: TextAlign.center,)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                        child: RaisedButton(
                            onPressed: (){
                              _distancePicker();
                            },
                            color: Theme
                                .of(context)
                                .accentColor,
                            child: Text("${searchRadius.toString()} km", textAlign: TextAlign.center,)
                        ),
                      ),
                    ],),
                  Expanded(
                    child: StreamBuilder(
                      stream: bloc.birdListObservable,
                      builder: (context, list){
                        print(list.connectionState.toString());
                        if(list.connectionState == ConnectionState.waiting){
                          return Card(child: new Center(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Loading"),
                                  new Image.asset("icon/icon.png"),
                                ],
                              )));
                        }
                        debugPrint("Got Here and printed this");
                        if(list.data == null || list.data.isEmpty)
                          return Card(child: new Center(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("No results found"),
                                  new Image.asset("icon/icon.png"),
                                ],
                              )));
                        debugPrint("There are " + list.data.length.toString() + " Items in the list");
                        return ListView.builder(itemCount: list.data.length, itemBuilder: (context, index){
                          var bird = list.data[index];
                          String titleName = bird.comName ?? "Missing Name";
                          String timeAndDistance = ""; // "${bird.distance} km away";
                          String latString = bird.lat.toString();
                          String lngString = bird.lng.toString();
                          return new Card(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(titleName),
                                  subtitle: Text(timeAndDistance),
                                ),
                                ButtonTheme.bar( // make buttons use the appropriate styles for cards
                                  child: ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('Map Location'),
                                        onPressed: (){
                                          launch("https://www.google.com/maps/search/?api=1&query=" + latString + "," +
                                              lngString);
                                          //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              )
          ),
        );
      return Text("Loading");
    },);
  }
}
