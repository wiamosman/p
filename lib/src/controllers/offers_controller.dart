
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/offer.dart';
import '../models/slide.dart';

import '../repository/offer_repository.dart';
import '../repository/slider_repository.dart';

class OffersController extends ControllerMVC {

  List<Offer> Offers = <Offer>[];
GlobalKey<ScaffoldState> scaffoldKey;

  OffersController() {
 this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOffers();
   
  }

  Future<void> listenForOffers() async {
    final Stream<Offer> stream = await getOffers();
    stream.listen((Offer _offer) {
      setState(() => Offers.add(_offer));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }
  }



 




