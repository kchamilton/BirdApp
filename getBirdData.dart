import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class getBirdData {
  double latitude;
  double longitude;

  getBirdData() {}

  Future<void> setLocation() async{
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      latitude = currentLocation["latitude"];
      longitude = currentLocation["longitude"];
    } on PlatformException {
      currentLocation = null;
    }
  }

  Future<http.Response> fetchPost() {
    String httpAddress = 'https://ebird.org/ws2.0/data/obs/geo/recent?lat=' + latitude.toString() + '&lng=' + longitude.toString() + '&key=rdq6kt3tn5fv';
    return http.get(httpAddress);
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}