
 import 'package:dio/dio.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesWebServices {
  Dio dio;
final placeLocationBaseUrl =
    'https://maps.googleapis.com/maps/api/place/details/json';
final suggestionsBaseUrl =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final googleAPIKey = "AIzaSyDHqmgco-jpiulcJ5rBN-Nt7aRot4VESig";
  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 60 * 1000,
      receiveTimeout: 60 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestions(
      String place, String sessionToken) async {
    try {
      Response response = await dio.get(
        suggestionsBaseUrl,
        queryParameters: {
          'input': place,
          'types': 'address',
          'components': 'country:sd',
          'key': googleAPIKey,
          'sessiontoken': sessionToken
        },
      );
     
      //  if (response.statusCode == 200) {
      //   var jsonData = response.data['predictions'];
      
      //   if (jsonData == null) {
      //             return;
      //   }}
      print(response.statusCode);
      return response.data['predictions'];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }


  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': googleAPIKey,
          'sessiontoken': sessionToken
        },
      );
      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }


}
