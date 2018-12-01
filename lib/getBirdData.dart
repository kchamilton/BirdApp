import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class getBirdData {
  double latitude;
  double longitude;
  String httpAddress;

  getBirdData() {
    setLocation();


  }

  Future<void> setLocation() async{
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      latitude = currentLocation["latitude"];
      longitude = currentLocation["longitude"];
      httpAddress = 'https://ebird.org/ws2.0/data/obs/geo/recent?lat=' + latitude.toString() + '&lng=' + longitude.toString() + '&key=rdq6kt3tn5fv';
    } on PlatformException {
      currentLocation = null;
    }
  }
}

Future<Post> fetchPost(String httpAddress) async {
  final response = await http.get(httpAddress);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
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

  Post({this.speciesCode, this.comName, this.sciName, this.locId, this.locName, this.obsDt, this.howMany, this.lat, this.lng, this.obsValid, this.obsReviewed, this.locationPrivate});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
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