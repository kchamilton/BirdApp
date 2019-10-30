

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
  final double distance;

  Bird(
      {this.speciesCode,
        this.comName,
        this.sciName,
        this.locId,
        this.locName,
        this.obsDt,
        this.howMany,
        this.lat,
        this.lng,
        this.obsValid,
        this.obsReviewed,
        this.locationPrivate,
        this.distance});

  factory Bird.fromJson(Map<String, dynamic> json, double distance) {
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
        distance: distance);
  }
}
