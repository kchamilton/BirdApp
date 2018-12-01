import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';

import 'package:url_launcher/url_launcher.dart';

class Bird {
  final String speciesCode;
  final String comName;
  final String sciName;
  final String locId;
  final String locName;
  final String obsDt;
  final int howMany;
  final double lat;
  final double lng;
  final bool obsValid;
  final bool obsReviewed;
  final bool locationPrivate;

  Bird.normal(this.speciesCode, this.comName, this.sciName, this.locId,
    this.locName, this.obsDt, this.howMany, this.lat, this.lng,
    this.obsValid, this.obsReviewed, this.locationPrivate);

  Bird({this.speciesCode, this.comName, this.sciName, this.locId,
    this.locName, this.obsDt, this.howMany, this.lat, this.lng,
    this.obsValid, this.obsReviewed, this.locationPrivate});

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      speciesCode: json['speciesCode'],
      comName: json['comName'],
      sciName: json['sciName'],
      locId: json['locId'],
      locName: json['locName'],
      obsDt: json['obsDt'],
      howMany: json['howMany'],
      lat: json['lat'],
      lng: json['lng'],
      obsValid: json['obsValid'],
      obsReviewed: json['obsReviewed'],
      locationPrivate: json['locationPrivate'],
    );
  }
}

class BirdData{

  Future<void> getLocation() async{
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      latitude = currentLocation["latitude"];
      longitude = currentLocation["longitude"];

      print("Lat/long Found -=-=-=-=-=-=-=-=-=-=-=-=-" + latitude.toString());

    } on PlatformException {
      currentLocation = null;
    }
  }

  BirdData(){
    getLocation();
  }
  double latitude;
  double longitude;

  Widget scrollingBirdList(List<Bird> birdDataList){
    Stream<Bird> birdDataStream = Stream.fromIterable(birdDataList);


    return new StreamBuilder(
        stream: birdDataStream,
        builder: (BuildContext context, AsyncSnapshot<Bird> snapshot){
          return new ListView(
            children: generateAllTiles(birdDataList),
          );
        }
    );
  }

  List<Widget> generateAllTiles(List<Bird> birdList){
    List<Widget> tileList = new List();
    for (var bird in birdList){
      tileList.add(generateTile(bird));
    }
    return tileList;
  }

  Widget generateTile(Bird bird){
    String titleName = bird.comName ?? "Missing Name";
    String timeAndDistance = "";
    if(bird.obsDt.isNotEmpty){
      timeAndDistance = "Seen ";
      var now = DateTime.now();
      var then = DateTime.parse(bird.obsDt);
      Duration difference = now.difference(then);
      timeAndDistance += (difference.inDays + 1 ).toString();
      timeAndDistance += " day(s) ago ";
    }
    if(bird.lat != null && bird.lng != null
      && latitude != null && longitude != null){
      Haversine distance = new Haversine.fromDegrees(
          latitude1: bird.lat,
          longitude1: bird.lng,
          latitude2: latitude,
          longitude2: longitude
      );
      timeAndDistance += distance.distance().toInt().toString() + "km away";
    }

    print(latitude);

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
          new Text("Latitude = "+ latString + "Longitude = " + lngString),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Map Location'),
                  onPressed: () {
                    launch("https://www.google.com/maps/search/?api=1&query=" + latString + "," + lngString);
                    //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
                  },
                ),
              ],
            ),
          ),
        ],
    ),);
  }
}