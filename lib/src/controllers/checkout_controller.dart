import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/bankak_card.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
   BankakId bankakId=BankakId();
  CreditCard creditCard = new CreditCard();
  bool loading = true;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
     listenForbankakId();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }
     void listenForbankakId() {
   bankakId = userRepo.getBankakId();
   print(bankakId.transactionId);
  // bankakId=userRepo.setBankakId;
  bankakId;
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.productOrders = <ProductOrder>[];//list will be fill t7t
    _order.tax = carts[0].product.market.defaultTax;
    _order.deliveryFee = payment.method == 'Pay on Pickup' ? 0 : carts[0].product.market.deliveryFee;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    _order.hint = ' ';
    carts.forEach((_cart) {
      ProductOrder _productOrder = new ProductOrder();
      _productOrder.quantity = _cart.quantity;
      _productOrder.price = _cart.product.price;
      _productOrder.product = _cart.product;
      _productOrder.options = _cart.options;
      _order.productOrders.add(_productOrder);
    });
  
    orderRepo.addOrder(_order, this.payment).then((value) async {
      settingRepo.coupon = Coupon.fromJSON({});
      return value;
    }).then((value) {
      if (value is Order) {
        print(value);
         print(value.payment.method);
        setState(() {
          loading = false;
        });
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
                 S.of(state.context).payment_card_updated_successfully,
                    
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
   //     content: Text(S.of(state.context).payment_card_updated_successfully),
   //   ));
    });
  }

  void updateBankakId(BankakId bankakId) {
    userRepo.setBankakId( bankakId);//.then((value) {
      setState(() {});
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content:const Text(
              //   S.of(state.context).payment_card_updated_successfully,
                "Transaction ID updated successfully"    
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
   //     content: Text(S.of(state.context).payment_card_updated_successfully),
   //   ));
    // });
  }

}
