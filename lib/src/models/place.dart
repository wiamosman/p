class Place {
  Result result;

  Place.fromJson(dynamic json) {
    result = Result.fromJson(json['result'])!= null ?  Result.fromJson(json['result']):   Result.fromJson({});
  }
}

class Result {
   Geometry geometry;

  Result.fromJson(dynamic json) {
    geometry = Geometry.fromJson(json['geometry'])!= null ? Geometry.fromJson(json['geometry']):   Geometry.fromJson({});
  }
}

class Geometry {
  Location location;

  Geometry.fromJson(dynamic json) {
    location = Location.fromJson(json['location'])!= null ? Location.fromJson(json['location']):  Location.fromJson({});
  }
}

class Location {
  double lat;
   double lng;

  Location.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}
