import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Bird.dart';

Future<List<Bird>> fetchPost({double latitude = 33.217816, double longitude = -87.54453, distance = 5, days = 4}) async {
  List<Bird> birdList = new List();
  int tries = 0;
    while(tries < 5){
      tries ++;
    final response =
        await http.get('https://ebird.org/ws2.0/data/obs/geo/recent'
        + '?lat=' + latitude.toString()
        + '&lng=' + longitude.toString()
        + '&dist=' + distance.toString()
        + '&back=' + days.toString()
        + '&key=rdq6kt3tn5fv');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var test =  json.decode(response.body);
      debugPrint("TestOutput"+test.toString());
      for (var other in test){
        birdList.add(Bird.fromJson(other));
      }
      break;
    } else {
      // If that call was not successful, throw an error.
      //throw Exception('Failed to load post');
      continue;
    }
  }
  return birdList;
}