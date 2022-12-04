import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../../map_cubit.dart/map_cubit.dart';
import '../../map_cubit.dart/map_state.dart';
import '../elements/map_place_item.dart';
import '../helpers/current_location_helper.dart';
import '../models/place.dart';
import '../models/places_suggestion.dart';
import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/DeliveryAddressDialog.dart';
import 'package:uuid/uuid.dart' as session;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:math' show cos, sqrt, asin;

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({Key key}) : super(key: key);

  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends StateMVC<DeliveryMapScreen> {
  DeliveryAddressesController _con;

  _DeliveryMapScreenState() : super(DeliveryAddressesController()) {
    _con = controller;
  }
  List<PlaceSuggestion> places = [];
  FloatingSearchBarController searchController = FloatingSearchBarController();
  static Position position;
  Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position.latitude, position.longitude) != null
        ? LatLng(position.latitude, position.longitude)
        : "",
    tilt: 0.0,
    zoom: 17,
  );

  // // these variables for getPlaceLocation
  Set<Marker> markers = Set();
  Set<Circle> circles;

  Set<Circle> mycircles;
  PlaceSuggestion placeSuggestion;
  Place selectedPlace;
  Marker searchedPlaceMarker;
  //late Marker currentLocationMarker;
  CameraPosition goToSearchedForPlace;
  LatLng destLocation;
  String _address;
  void buildCameraNewPosition() {
    goToSearchedForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  var progressIndicator = false;

  @override
  initState() {
    super.initState();
    getMyCurrentLocation();
    

  }

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      // circles: circles,
      onCameraMove: (newLocation) {
        print('moving');

        setState(() {
          destLocation = newLocation.target;
          print('new DestLocation = ${destLocation}');
        });
      },
      onCameraIdle: () {
        print('camera idle');
        getAddressFromLatLng();
      },
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  getAddressFromLatLng() async {
    print("destLocation = ${destLocation?.latitude}${destLocation?.longitude}");
    if (destLocation != null) {
      try {
        GeoData data = await Geocoder2.getDataFromCoordinates(
            latitude:
                destLocation.latitude != null ? destLocation.latitude : 0.0,
            longitude:
                destLocation.longitude != null ? destLocation.longitude : 0.0,
            googleMapApiKey: setting.value.googleMapsKey);
        if (mounted) {
          setState(() {
            _address = data.address;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    //searchController .close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: searchController,
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18.sp),
      queryStyle: TextStyle(fontSize: 18.sp),
      hint: 'Find a place..',
      border: BorderSide(
        style: BorderStyle.none,
      ),
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0).r,
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: Theme.of(context).accentColor.withOpacity(1),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56).r,
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600.w : 500.w,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) async {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {},
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
              onPressed: () {}),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8).w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
              buildSelectedPlaceLocationBloc(),
            ],
          ),
        );
      },
    );
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = session.Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestions(query, sessionToken);
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;

          goToMySearchedForLocation();
          //  getDirections();
        }
      },
      child: Container(),
    );
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchedForPlace.target,
      markerId: MarkerId('1'),
      onTap: () {},
      infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    addMarkerToMarkersAndUpdateUI(searchedPlaceMarker);
  }

  void addMarkerToMarkersAndUpdateUI(Marker marker) {
    if (mounted) {
      setState(() {
        markers.add(marker);
      });
    }
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          places = (state).places;
          if (places.length != 0) {
            return buildPlacesList();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPlacesList() {
    return ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () {
              searchController.close();
            },
            child: InkWell(
              onTap: () async {
                placeSuggestion = places[index];
                searchController.close();
                getSelectedPlaceLocation();
                removeAllMarkersAndUpdateUI();
              },
              child: PlaceItem(
                suggestion: places[index],
              ),
            ),
          );
        },
        itemCount: places.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics());
  }

  void removeAllMarkersAndUpdateUI() {
    if (mounted) {
      setState(() {
        markers.clear();
      });
    }
  }

  void getSelectedPlaceLocation() {
    final sessionToken = session.Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceLocation(placeSuggestion.placeId, sessionToken);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1000 * 12742 * asin(sqrt(a));

    ///12742 * asin(sqrt(a)); km
// 1000 * 12742 * asin(sqrt(a)) //meters[]
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        //   drawer: MyDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            position != null
                ? buildMap()
                : Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).accentColor.withOpacity(1),
                      ),
                    ),
                  ),
            buildFloatingSearchBar(),
            (isKeyboardVisible || !places.isEmpty)
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 35.0).w,
                      child: Image.asset(
                        'assets/img/pick.png',
                        height: 45.h,
                        width: 45.w,
                      ),
                    ),
                  ),
            (isKeyboardVisible || !places.isEmpty)
                ? Container()
                : Positioned(
                    top: 130.r,
                    right: 20.r,
                    left: 20.r,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(20.r),
                      child: Text(_address ?? 'Pick your destination address',
                          overflow: TextOverflow.visible, softWrap: true),
                    ),
                  ),
            (isKeyboardVisible || !places.isEmpty)
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: _address == null
                              ? null
                              : () {
                                  print("before if");
                                  if (_con.addresses.isEmpty) {
                                    return DeliveryAddressDialog(
                                      context: context,
                                      address: Address.fromJSON(
                                        {
                                          "address": _address,
                                          'latitude':
                                              destLocation.latitude ?? '',
                                          'longitude':
                                              destLocation.longitude ?? '',
                                        },
                                      ),
                                      onChanged: (Address address) {
                                        _con.addAddress(address);
                                      },
                                    );
                                    //    Navigator.of(context).pop();
                                  } else if (_con.addresses.isNotEmpty) {
                                    var result = false;
                                    result = _con.addresses.any((item) {
                                      double distanceInMeters =
                                          calculateDistance(
                                              item.latitude,
                                              item.longitude,
                                              destLocation.latitude,
                                              destLocation.longitude);

                                      if (distanceInMeters <= 100.0) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    });

                                    if (result) {
                                      return showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          // ignore: prefer_const_constructors
                                          content: Text(
                                            "This address is already exists",
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                S.of(context).ok,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                //  Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return DeliveryAddressDialog(
                                        context: context,
                                        address: Address.fromJSON(
                                          {
                                            "address": _address,
                                            'latitude':
                                                destLocation.latitude ?? '',
                                            'longitude':
                                                destLocation.longitude ?? '',
                                          },
                                        ),
                                        onChanged: (Address address) {
                                          _con.addAddress(address);
                                        },
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).accentColor.withOpacity(1),
                            onPrimary: Colors.white,
                            minimumSize: Size(300.w, 50.h),
                          ),
                          child: _con.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Add this address'),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 100).r,
          child: isKeyboardVisible
              ? Container()
              : FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _goToMyCurrentLocation,
                  child: Icon(Icons.my_location, color: Colors.grey),
                ),
        ),
      );
    });
  }
}
