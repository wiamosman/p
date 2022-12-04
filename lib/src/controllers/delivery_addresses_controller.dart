import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC with ChangeNotifier {
  List<model.Address> addresses = <model.Address>[];
  


  GlobalKey<ScaffoldState> scaffoldKey;
  Cart cart;
bool isLoading=false;
  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
    listenForCart();
  }

  void listenForAddresses({String message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses. add(_address);
      });
    }, onError: (a) {
      print(a);
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(state.context).verify_your_internet_connection),
      //    duration: Duration(seconds: 3),
      // ));
    }, onDone: () {
      if (message != null) {
        showDialog(
          context: state.context,
          builder: (ctx) => AlertDialog(
            content: Text(
              message,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(state.context).ok,
                  style: TextStyle(color: Theme.of(state.context).accentColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                   Navigator.of(state.context).pop();
                },
              ),
            ],
          ),
        );
 //notifyListeners();
        //    ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(
        message: S.of(state.context).addresses_refreshed_successfuly);
 // notifyListeners();
  }

  Future<void> changeDeliveryAddress(model.Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
 // notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
    isLoading=true;
    model.Address _address = await settingRepo.setCurrentLocation();
    setState(() {
      settingRepo.deliveryAddress.value = _address;
      isLoading=false;
    });
    settingRepo.deliveryAddress.notifyListeners();
  //  notifyListeners();
  }

  Future<Function> addAddress(model.Address address) {
    print("executing-------------");
    isLoading=true;
    userRepo.addAddress(address).then((value) {
 setState(() {
    addresses.insert(0, value);
 
         isLoading=false;
         });

     //  settingRepo.deliveryAddress.notifyListeners();
 // notifyListeners();
  return
   showDialog(
        context: state.context,
        builder: (ctx) => AlertDialog(
          content: Text(
            S.of(state.context).new_address_added_successfully,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(state.context).ok,
                style: TextStyle(color: Theme.of(state.context).accentColor),
              ),
              onPressed: () {
                //Navigator.pop(ctx);
                    Navigator.of(ctx).pop();
                Navigator.of(state.context).pop(addresses);
              //  Navigator.of(state.context)
              //                     .pushNamed('/DeliveryAddresses');
              },
            ),
          ],
        ),
      );
 
    });
  }

  void chooseDeliveryAddress(model.Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
//  notifyListeners();
 }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      listenForAddresses(
          message: S.of(state.context).the_address_updated_successfully);
    });
 // notifyListeners();
  }

  void removeDeliveryAddress(model.Address address) async {
    isLoading=true;
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
        isLoading=false;
      });
     isLoading?Container(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ): showDialog(
        context: scaffoldKey?.currentContext,
        builder: (ctx) => AlertDialog(
          content: Text(
            S.of(state.context).delivery_address_removed_successfully,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(state.context).ok,
                style: TextStyle(color: Theme.of(state.context).accentColor),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(false);
                 
              },
            ),
          ],
        ),
      );
 //notifyListeners();
      //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //    content: Text(S.of(state.context).delivery_address_removed_successfully),
      //   ));
    });
  }
}
