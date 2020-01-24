import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';


import 'Bird.dart';
import 'bloc.dart';

Widget magicTest(Bloc bloc){
  return StreamBuilder(
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
        String timeAndDistance = "${bird.distance} km away";
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
                      },//
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}