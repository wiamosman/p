
import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';


import '../src/repository/map_address_repository.dart';
import 'map_state.dart';



class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void emitPlaceSuggestions(String place, String sessionToken) {
    mapsRepository.fetchSuggestions(place, sessionToken).then((suggestions) {
      emit(PlacesLoaded(suggestions));
    });
  }

   void emitPlaceLocation(String placeId, String sessionToken) {
    mapsRepository.getPlaceLocation(placeId, sessionToken).then((place) {
      emit(PlaceLocationLoaded(place));
    });
  }

  //    void emitPlaceDirections(LatLng origin, LatLng destination) {
  //   mapsRepository.getDirections(origin, destination).then((directions) {
  //     emit(DirectionsLoaded(directions));
  //   });
  // }
}

