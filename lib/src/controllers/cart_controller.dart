import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          coupon = _cart.product.applyCoupon(coupon);
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
        duration: Duration(seconds: 3),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        showDialog(
          context: scaffoldKey?.currentContext,
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
                },
              ),
            ],
          ),
        );
        //    ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        //  content: Text(message),
        //    ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
        duration: Duration(seconds: 3),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(state.context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();

      showDialog(
        context: scaffoldKey?.currentContext,
        builder: (ctx) => AlertDialog(
          content: Text(
            S
                .of(state.context)
                .the_product_was_removed_from_your_cart(_cart.product.name),
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
      //  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //     content: Text(S.of(state.context).the_product_was_removed_from_your_cart(_cart.product.name)),
      //  ));
    });
  }

  void calculateSubtotal() async {
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = cart.product.price;
      cart.options.forEach((element) {
        cartPrice += element.price;
      });
      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    });
    if (Helper.canDelivery(carts[0].product.market, carts: carts)) {
      deliveryFee = carts[0].product.market.deliveryFee;
    }
    taxAmount =
        (subTotal + deliveryFee) * carts[0].product.market.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
        duration: Duration(seconds: 3),
      ));
    }, onDone: () {
      listenForCarts();
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      showDialog(
        context: scaffoldKey?.currentContext,
        builder: (ctx) => AlertDialog(
          content: Text(
            S.of(state.context).completeYourProfileDetailsToContinue,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(state.context).settings,
                style: TextStyle(color: Theme.of(state.context).accentColor),
              ),
              onPressed: () {
                Navigator.of(state.context).pushNamed('/Settings');
              },
            ),
          ],
        ),
      );
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(state.context).completeYourProfileDetailsToContinue),
      //   action: SnackBarAction(
      //     label: S.of(state.context).settings,
      //     textColor: Theme.of(state.context).accentColor,
      //     onPressed: () {
      //       Navigator.of(state.context).pushNamed('/Settings');
      //     },
      //   ),
      // ));
    } else {
      if (carts[0].product.market.closed) {
        showDialog(
          context: scaffoldKey?.currentContext,
          builder: (ctx) => AlertDialog(
            content: Text(S.of(state.context).this_market_is_closed_),
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
        // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        //   content: Text(S.of(state.context).this_market_is_closed_),
        // ));
      } else {
        Navigator.of(state.context).pushNamed('/DeliveryPickup');
      }
    }
  }

  Color getCouponIconColor() {
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(state.context).focusColor.withOpacity(0.7);
  }
}
