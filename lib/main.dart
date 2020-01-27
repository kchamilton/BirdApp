import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc.dart';
import 'Bird.dart';
import 'birdList.dart';

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

  NumberPicker searchRadiusPicker;
  NumberPicker daysPicker;

  int searchRadius = 30;
  int searchDays = 30;

  var latitude;
  var longitude;

  @override
  void initState() {
    bloc.refreshWithLocation(searchRadius, searchDays);
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
        maxValue: 30,
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
        maxValue: 50,
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
                child: birdListBuilder(bloc),
              ),
            ],
          )
      ),
    );
  }
}
