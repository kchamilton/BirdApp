import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Bird.dart';

Future<List<Bird>> fetchPost() async {
  List<Bird> birdList = new List();
  final response =
  await http.get('https://ebird.org/ws2.0/data/obs/geo/recent?lat=33.217816&lng=-87.54453&key=rdq6kt3tn5fv');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var test =  json.decode(response.body);
    debugPrint("TestOutput"+test.toString());
    for (var other in test){
      birdList.add(Bird.fromJson(other));
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
  return birdList;
}


void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<List<Bird>> post;

  MyApp({Key key, this.post}) : super(key: key);

  BirdData data = new BirdData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Bird>>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return data.scrollingBirdList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() {
  GetBirdData birdData = new GetBirdData();
  birdData.getData();
}

class GetBirdData {
  double latitude;
  double longitude;
  String httpAddress;

  void getData({Key key, Post post}) {
    setLocation();
    final Future<Post> post = fetchPost(httpAddress);
    FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.speciesCode);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

        });
    print(post.toString());
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

void main() {
  MyAppState myAppState = new MyAppState();
  myAppState.FetchJSON();
  myAppState.printData();
}

class MyAppState {
  String speciesCode, comName, sciName, locId, locName, obsDt;
  int howMany;
  double lat, lng;
  bool obsValid, obsReviewed, locationPrivate;
  String httpAddress;

  FetchJSON() async {
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      lat = currentLocation["latitude"];
      lng = currentLocation["longitude"];
      httpAddress = 'https://ebird.org/ws2.0/data/obs/geo/recent?lat=' + lat.toString() + '&lng=' + lng.toString() + '&key=rdq6kt3tn5fv';
    } on PlatformException {
      currentLocation = null;
    }
    var Response = await http.get(httpAddress);

    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      speciesCode= responseJSON['speciesCode'];
      comName = responseJSON['comName'];
      sciName = responseJSON['sciName'];
      locId = responseJSON['locId'];
      locName = responseJSON['locName'];
      obsDt = responseJSON['obsDt'];
      howMany = responseJSON['howMany'];
      lat = responseJSON['lat'];
      lng = responseJSON['lng'];
      obsValid = responseJSON['obsValid'];
      obsReviewed = responseJSON['obsReviewed'];
      locationPrivate = responseJSON['locationPrivate'];
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  void printData() {
    if(speciesCode == null) {
      speciesCode = "bird";
    }
    if(comName == null){
      comName = "bird";
    }
    print("Species: " + speciesCode);
    print("Species: " + comName);
  }

  @override
  void initState() {
    FetchJSON();
  }
}
*/