import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';
import '../repository/settings_repository.dart';
import '';

class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressBottomSheetWidget({Key key, this.scaffoldKey})
      : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() =>
      _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState
    extends StateMVC<DeliveryAddressBottomSheetWidget> {
  DeliveryAddressesController _con;
  _DeliveryAddressBottomSheetWidgetState()
      : super(DeliveryAddressesController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
  // _con.listenForAddresses();
    // _con.addListener(() => mounted ? setState(() {}) : null);
  }

  @override
  void dispose() {
    // _con.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build---------------------");
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius:const BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset:const Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showDialog(
                      context: widget.scaffoldKey.currentContext,
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
                                    if(value!=null){
                                          print(value);
                                    setState((){
                                      _con.addresses=value;
                                    });
                                    }
                                
                                } );
                            
                            },
                          )
                        ],
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).focusColor),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).add_new_delivery_address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    _con.changeDeliveryAddressToCurrentLocation().then((value) {
                     Navigator.of(context).pushReplacementNamed('/Pages', arguments:1);
                      //widget.scaffoldKey.currentContext
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).accentColor),
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).current_location,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            _con.isLoading==true?Center(child:CircularProgressIndicator(
                        color: Colors.grey,
                      ),): Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount:_con.addresses.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 25);
                        },
                        itemBuilder: (context, index) {
                             for (int i = 0; i <_con.addresses.length; i++) {
                                print(
                                    "--------tekrar-----------------${_con.addresses}");
                              }
                          //                return DeliveryAddressesItemWidget(
                          //                  address: _con.addresses.elementAt(index),
                          //                  onPressed: (Address _address) {
                          //                    _con.chooseDeliveryAddress(_address);
                          //                  },
                          //                  onLongPress: (Address _address) {
                          //                    DeliveryAddressDialog(
                          //                      context: context,
                          //                      address: _address,
                          //                      onChanged: (Address _address) {
                          //                        _con.updateAddress(_address);
                          //                      },
                          //                    );
                          //                  },
                          //                  onDismissed: (Address _address) {
                          //                    _con.removeDeliveryAddress(_address);
                          //                  },
                          //                );
                          return InkWell(
                            onTap: () {
                           
                            _con
                                  .changeDeliveryAddress(
                                 _con.addresses.elementAt(index))
                                  .then((value) {
                                Navigator.of(widget.scaffoldKey.currentContext)
                                    .pop();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Theme.of(context).focusColor),
                                  child: Icon(
                                    Icons.place_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Flexible(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                            _con.addresses
                                                  .elementAt(index)
                                                  .description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Theme.of(context).focusColor,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                
               
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }
}
