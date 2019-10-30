import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart'; // for debugprint only, maybe I don't need this
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'Bird.dart';

class Bloc {
  BehaviorSubject<List<Bird>> _subjectBirdList;

  Observable<List<Bird>> get birdListObservable => _subjectBirdList.stream;

  Position position;

  Bloc() {
    _subjectBirdList = new BehaviorSubject<List<Bird>>();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void refreshWithLocation(int searchRadius, int searchTime) async {
    debugPrint("RefreshWithLocation Called");
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Bird> birdList = await getData(
        latitude: position.latitude, longitude: position.longitude, distance: searchRadius, days: searchTime);
    if (birdList == null) {
      //TODO Make this return something that will show a graceful failure message to the user...
      return;
    }
    _subjectBirdList.sink.add(birdList);
  }

  void refreshNoLocation(int searchRadius, int searchTime) async {
    debugPrint("RefreshNoLocation Called");
    List<Bird> birdList = await getData(
        latitude: position.latitude, longitude: position.longitude, distance: searchRadius, days: searchTime);
    if (birdList == null) {
      //TODO Make this return something that will show a graceful failure message to the user...
      return;
    }
    _subjectBirdList.sink.add(birdList);
  }

  Future<List<Bird>> getData(
      {double latitude = 33.217816, double longitude = -87.54453, distance = 50, days = 14}) async {
    debugPrint("Getting the Bird Stuff");
    String request = 'https://ebird.org/ws2.0/data/obs/geo/recent' +
        '?lat=' +
        latitude.toString() +
        '&lng=' +
        longitude.toString() +
        '&dist=' +
        distance.toString() +
        '&back=' +
        days.toString() +
        '&key=rdq6kt3tn5fv';
//    print(request);
    List birdList = new List<Bird>();
    int tries = 0;
    while (tries < 5) {
      tries++;
      final httpResponse = await http.get(request);
      print("Request Returned # ${tries.toString()}");
      if (httpResponse.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        var responseJSON = json.decode(httpResponse.body);
        debugPrint("TestOutput" + responseJSON.toString());
        for (var record in responseJSON) {
          double distanceInMeters =
              await Geolocator().distanceBetween(latitude, longitude, record["lat"], record["lng"]);
          birdList.add(Bird.fromJson(record, distanceInMeters));
        }
        return birdList;
      }
    }
    return null;
  }

  void dispose() {
    _subjectBirdList.close();
  }
}
