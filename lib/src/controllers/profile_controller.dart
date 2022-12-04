import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class ProfileController extends ControllerMVC {
  List<Order> recentOrders = [];
  GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForRecentOrders();
  }

  void listenForRecentOrders({String message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
         duration: Duration(seconds: 3),
      ));
    }, onDone: () {
      if (message != null) {
          showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
message,
                    
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  );
    //    ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
    //      content: Text(message),
   //     ));
      }
    });
  }

  Future<void> refreshProfile() async {
    recentOrders.clear();
    listenForRecentOrders(message: S.of(state.context).orders_refreshed_successfuly);
  }
}
