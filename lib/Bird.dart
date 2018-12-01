import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';

import 'package:url_launcher/url_launcher.dart';

class Bird{
  String speciesCode;//	"grbher3"
  String comName;//	"Great Blue Heron"
  String sciName;//	"Ardea herodias"
  String locId;//	"L6439105"
  String locName;//	"Ole Colony GC"
  String obsDt;//	"2018-11-30 16:44"
  int howMany;//	2
  double lat;//	33.2566041
  double lng;//	-87.5382442
  bool obsValid;//	true
  bool obsReviewed;//	false
  bool locationPrivate;//	true

  Bird(String speciesCode, String commonName, String scientificName,
      String locationID, String locationName, String observationDate, int howMany,
      double lat, double long, bool valid, bool reviewed, bool locationPrivate
      ){
    this.speciesCode = speciesCode;
    this.comName = commonName;
    this.sciName = scientificName;
    this.locId = locationID;
    this.locName = locationName;
    this.obsDt = observationDate;
    this.howMany = howMany;
    this.lat = lat;
    this.lng = long;
    this.obsValid = valid;
    this.obsReviewed = reviewed;
    this.locationPrivate = locationPrivate;
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
      timeAndDistance += distance.toString() + " away";
    }

    print(latitude);
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
                  onPressed: () {
                    String latString = bird.lat.toString();
                    String lngString = bird.lng.toString();
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