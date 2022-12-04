import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:map_location_picker/map_location_picker.dart';
import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class DeliveryAddressesWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryAddressesWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryAddressesWidgetState createState() =>
      _DeliveryAddressesWidgetState();
}

class _DeliveryAddressesWidgetState extends StateMVC<DeliveryAddressesWidget> {
  DeliveryAddressesController _con;
  PaymentMethodList list;

  _DeliveryAddressesWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    list = PaymentMethodList(context);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_addresses,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButton:
          // _con.cart != null && _con.cart.product.market.availableForDelivery
          // ?

          FloatingActionButton(
              onPressed: () {
                                  showDialog(
                      context:  _con.scaffoldKey.currentContext,
                      builder: (ctx) => AlertDialog(
                        content: Text(
                          "Do you want to add new delivery address ? ",
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              S.of(context).cancel,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              S.of(context).yes,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            Navigator.of(context)
                                  .pushNamed('/DeliveryAddress').then((value) {
                                    print(value);
                                    setState((){
                                      _con.addresses=value;
                                    });
                                } );
                            },
                          ),
                        ],
                      ),
                    );
                // showDialog(
                //   context: _con.scaffoldKey?.currentContext,
                //   builder: (ctx) => AlertDialog(
                //     content: Text(
                //       "Do you want to add new delivery address ? ",
                //     ),
                //     actions: <Widget>[
                //       TextButton(
                //         child: Text(
                //           S.of(context).cancel,
                //           style:
                //               TextStyle(color: Theme.of(context).accentColor),
                //         ),
                //         onPressed: () {
                //           Navigator.of(ctx).pop(false);
                //         },
                //       ),
                //       TextButton(
                //         child: Text(
                //           S.of(context).yes,
                //           style:
                //               TextStyle(color: Theme.of(context).accentColor),
                //         ),
                //         onPressed: () async {
                //           String address = "null";
                //           String autocompletePlace = "null";
                //           var result2 = MapLocationPicker(
                //             apiKey: setting.value.googleMapsKey,
                //             canPopOnNextButtonTaped: true,
                //             currentLatLng: LatLng(
                //                 deliveryAddress.value?.latitude ?? 0,
                //                 deliveryAddress.value?.longitude ?? 0),
                //             onNext: (GeocodingResult result) {
                //               if (result != null) {
                //                 setState(() {
                //                   address = result.formattedAddress ?? "";
                //                 });
                //               }
                //             },
                //             onSuggestionSelected:
                //                 (PlacesDetailsResponse result) {
                //               if (result != null) {
                //                 setState(() {
                //                   autocompletePlace =
                //                       result.result.formattedAddress ?? "";
                //                 });
                //               }
                //             },
                //           );

                //           /*LocationResult result = await showLocationPicker(
                //                     context,
                //                    setting.value.googleMapsKey,
                //                    initialCenter: LatLng(
                //                        deliveryAddress.value?.latitude ?? 0,
                //                   deliveryAddress.value?.longitude ?? 0),
                //                     //automaticallyAnimateToCurrentLocation: true,
                //                        //mapStylePath: 'assets/mapStyle.json',
                //                           myLocationButtonEnabled: true,
                //                          //resultCardAlignment: Alignment.bottomCenter,
                //                        );*/
                //           result2.origin;
                //           List placemarks = await placemarkFromCoordinates(
                //               result2.currentLatLng.latitude,
                //               result2.currentLatLng.longitude);

                //           //  print(placemarks);

                //           Placemark place = placemarks[1];
                //           print(place);
                //           address =
                //               '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
                //           print("address is $address");
                //           var addressList = place; // placemarks[1];
                //           //  address = addressList.toString();
                //           print("before if");
                //           if (_con.addresses.isEmpty) {
                //             print("is empty");
                //             _con.addAddress(Address.fromJSON({
                //               'address': address,
                //               'latitude': result2.currentLatLng.latitude,
                //               'longitude': result2.currentLatLng.longitude,
                //             }));
                //             Navigator.of(_con.scaffoldKey.currentContext).pop();
                //           } else if (!_con.addresses.isEmpty) {
                //             print("is not empty");
                //             _con.addresses.forEach((address1) {
                //               if ((address1.latitude ==
                //                       result2.currentLatLng.latitude) &&
                //                   (address1.longitude ==
                //                       result2.currentLatLng.longitude)) {
                //                 print("its heeeerrrrreeee");
                //                 Navigator.of(ctx).pop(false);
                //                 showDialog(
                //                   context: _con.scaffoldKey?.currentContext,
                //                   builder: (ctx) => AlertDialog(
                //                     content: Text(
                //                       "This address is already exists",
                //                     ),
                //                     actions: <Widget>[
                //                       TextButton(
                //                         child: Text(
                //                           S.of(context).ok,
                //                           style: TextStyle(
                //                               color: Theme.of(context)
                //                                   .accentColor),
                //                         ),
                //                         onPressed: () {
                //                           Navigator.of(ctx).pop();
                //                         },
                //                       ),
                //                     ],
                //                   ),
                //                 );
                //               }
                //             });
                //           } else {
                //             print('ELSE IS EXECUTING');

                //             // print("result = $result2");
                //             // Navigator.of(ctx).pop(false);
                //             _con.addAddress(Address.fromJSON({
                //               'address': address,
                //               'latitude': result2.currentLatLng.latitude,
                //               'longitude': result2.currentLatLng.longitude,
                //             }));
                //             Navigator.of(_con.scaffoldKey.currentContext).pop();
                //           }
                //         },
                //       )
                //     ],
                //   ),
                // );

                //setState(() => _pickedLocation = result);
              },
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              )),
      // : SizedBox(height: 0),
      body: RefreshIndicator(
        onRefresh: _con.refreshAddresses,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.map_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).delivery_addresses,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S
                        .of(context)
                        .long_press_to_edit_item_swipe_item_to_delete_it,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              _con.addresses.isEmpty
                  ? Container() //CircularLoadingWidget(height: 250)
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.addresses.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                           for (int i = 0; i <_con.addresses.length; i++) {
                                print(
                                    "--------tekrar-----------------${_con.addresses}");
                              }
                        return Dismissible(
                          key: ValueKey(_con.addresses.elementAt(index).id),
                          background: Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 40,
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                  'Do you want to remove this address ?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('No',style:
                              TextStyle(color: Theme.of(context).accentColor),),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes',style:
                              TextStyle(color: Theme.of(context).accentColor),),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            _con.removeDeliveryAddress(
                                _con.addresses.elementAt(index));
                          },
                          child: DeliveryAddressesItemWidget(
                            address: _con.addresses.elementAt(index),
                            onPressed: (Address _address) {
                              DeliveryAddressDialog(
                                context: context,
                                address: _address,
                                onChanged: (Address _address) {
                                  _con.updateAddress(_address);
                                },
                              );
                            },
                            onLongPress: (Address _address) {
                              DeliveryAddressDialog(
                                context: context,
                                address: _address,
                                onChanged: (Address _address) {
                                  _con.updateAddress(_address);
                                },
                              );
                            },
                            // onDismissed: (Address _address) {
                            //   _con.removeDeliveryAddress(_address);
                            // },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
