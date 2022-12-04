import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOrders();
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
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
     //     content: Text(message),
     //   ));
      }
    });
  }

  void doCancelOrder(Order order) {
    cancelOrder(order).then((value) {
      setState(() {
        order.active = false;
      });
    }).catchError((e) {
     showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
      e,
                    
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
   //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
    //    content: Text(e),
      //));
    }).whenComplete(() {
      //refreshOrders();
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
    S.of(state.context).orderThisorderidHasBeenCanceled(order.randomNumber),
                    
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
    //  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
    //    content: Text(S.of(state.context).orderThisorderidHasBeenCanceled(order.id)),
    //  ));
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(state.context).order_refreshed_successfuly);
  }
}
