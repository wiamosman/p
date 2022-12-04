import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_machine/time_machine.dart' as cal;
import '../../generated/l10n.dart';
import '../controllers/offers_controller.dart';
import '../elements/HomeSliderLoaderWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../models/slide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Offers extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final List<Slide> slides;

  @override
  _OffersState createState() => _OffersState();

  Offers({Key key, this.slides, this.parentScaffoldKey}) : super(key: key);
}

class _OffersState extends StateMVC<Offers> {
  OffersController _con;

  _OffersState() : super(OffersController()) {
    _con = controller;
  }

  int _current = 0;
  AlignmentDirectional _alignmentDirectional;

  @override
  Widget build(BuildContext context) {
  
   
   
 daysBetween(DateTime expiryDate) {
DateTime now=DateTime.now();
DateTime expiry=expiryDate;
  cal.LocalDate a = cal.LocalDate.dateTime(now);
  cal.LocalDate b = cal.LocalDate.dateTime(expiry);
  
  cal.Period diff = b.periodSince(a);
   if(diff.years>0){
    return "${diff.years} years left";
  }else
  if(diff.months>0&&diff.days==0){
    return "${diff.months} months left";
  }
  else
  if(diff.months>0&&diff.days>0){
    return "${diff.months} months & ${diff.days} days left";
  }
  else{  return "${diff.days} days left";}

}

    return _con.Offers == null ||_con.Offers.isEmpty
        ? Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).accentColor.withOpacity(1),
                      ),
                    ),
                  )
        : Scaffold(
            key: _con.scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () =>
                    widget.parentScaffoldKey.currentState.openDrawer(),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Offers', // S.of(context).my_orders,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(const TextStyle(letterSpacing: 1.3)),
              ),
              actions: <Widget>[
                ShoppingCartButtonWidget(
                    iconColor: Theme.of(context).hintColor,
                    labelColor: Theme.of(context).accentColor),
              ],
            ),
            body: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15).w,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount:_con.Offers.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5.h);
                },
                itemBuilder: (context, index) {
                   String days='';
            _con.Offers[index].expiryDate.isAfter(DateTime.now())?
 days = daysBetween(_con.Offers[index].expiryDate):"";
            
                   
                  return _con.Offers[index].expiryDate.isAfter(DateTime.now())?InkWell(
                     splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
                  onTap: (){
                if (_con.Offers[index]
                                                          .product.id !=
                                                      'null') {
                                                    Navigator.of(context).pushNamed(
                                                        '/Product',
                                                        arguments: RouteArgument(
                                                            id:_con.Offers[index]
                                                                .product.id,
                                                            heroTag:
                                                                'home_slide'));
                                                  }else     if (_con.Offers[index].market
                                                          .id !=
                                                      'null') {
                                                    Navigator.of(context).pushNamed(
                                                        '/Details',
                                                        arguments: RouteArgument(
                                                            id: '0',
                                                            param: _con.Offers[index]
                                                                .market
                                                                .id,
                                                            heroTag:
                                                                'home_slide'));
                                                  }
               
                  },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                      margin: EdgeInsets.all(15).r,
                      child: Column(
                        children: [
                          Stack(
                            alignment: _alignmentDirectional ??
                                Helper.getAlignmentDirectional(
                                    _con.Offers.elementAt(index).textPosition),
                            fit: StackFit.passthrough,
                            children: <Widget>[
                              Container(
                                // margin: const EdgeInsets.symmetric(
                                //     vertical: 20, horizontal: 20),
                                height: 140.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.15),
                                        blurRadius: 15,
                                        offset: Offset(0, 2)
                                        ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      // ignore: prefer_const_constructors
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10),
                                        topRight: const Radius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        height: 140.h,
                                        width: double.infinity,
                                        fit: Helper.getBoxFit(
                                            _con.Offers[index].imageFit),
                                        imageUrl:_con.Offers[index].image.url,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 140.h,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error_outline),
                                      ),
                                    ),
                                    Container(
                                      alignment: Helper.getAlignmentDirectional(
                                          _con.Offers[index].textPosition),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20).w,
                                      child: Container(
                                        width: config.App(context).appWidth(40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // if (_con.Offers[index].text != null &&
                                            //    _con.Offers[index].text != '')
                                            //   Text(
                                            //    _con.Offers[index].text,
                                            //     style: Theme.of(context)
                                            //         .textTheme
                                            //         .headline6
                                            //         .merge(
                                            //           TextStyle(
                                            //             fontSize: 14,
                                            //             height: 1,
                                            //             color: Helper.of(context)
                                            //                 .getColorFromHex(_con.Offers[index]
                                            //                     .textColor),
                                            //           ),
                                            //         ),
                                            //     textAlign: TextAlign.center,
                                            //     overflow: TextOverflow.fade,
                                            //     maxLines: 3,
                                            //   ),
                                            if (_con.Offers[index].button !=
                                                    null &&
                                               _con.Offers[index].button != '')
                                              MaterialButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  if (_con.Offers[index].market
                                                          .id !=
                                                      'null') {
                                                    Navigator.of(context).pushNamed(
                                                        '/Details',
                                                        arguments: RouteArgument(
                                                            id: '0',
                                                            param: _con.Offers[index]
                                                                .market
                                                                .id,
                                                            heroTag:
                                                                'home_slide'));
                                                  } else if (_con.Offers[index]
                                                          .product.id !=
                                                      'null') {
                                                    Navigator.of(context).pushNamed(
                                                        '/Product',
                                                        arguments: RouteArgument(
                                                            id:_con.Offers[index]
                                                                .product.id,
                                                            heroTag:
                                                                'home_slide'));
                                                  }
                                                },
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5).w,
                                                color: Helper.of(context)
                                                    .getColorFromHex(_con.Offers[index]
                                                        .buttonColor),
                                                shape: StadiumBorder(),
                                                child: Text(
                                                _con.Offers[index].button,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(14.r),
                            child: Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Text("Exclusive offer"),
                                  ],
                                ),SizedBox(height: 6.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                          if (_con.Offers[index].text != null &&
                                               _con.Offers[index].text != '')
                                        Icon(Icons.discount,color: Theme.of(context).accentColor,),
                                        const SizedBox(width: 6,),
                                         if (_con.Offers[index].text != null &&
                                               _con.Offers[index].text != '')
                                              Container(
                                              width: 120.w,
                                        //  color: Colors.amber,
                                          alignment: Alignment.centerLeft,
                                        //  color: Colors.amber,
                                                child: Text(
                                                 _con.Offers[index].text,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .merge(
                                                        TextStyle(
                                                          fontSize: 12,
                                                          height: 1.h,
                                                          color: Helper.of(context)
                                                              .getColorFromHex(_con.Offers[index]
                                                                  .textColor),
                                                        ),
                                                      ),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),


                                                
                                              ),
                                      ],
                                    ),
                                    Spacer(),
                                    
                                        Row(
                                      children: [
                                          if (_con.Offers[index].expiryDate != null &&
                                              _con.Offers[index].expiryDate != ''&&_con.Offers[index].expiryDate.isAfter(DateTime.now())&& days!='')
                                        Icon(Icons.schedule,color: Theme.of(context).accentColor,),
                                         SizedBox(width: 6,),
                                           if (_con.Offers[index].expiryDate != null &&
                                             _con.Offers[index].expiryDate != ''&&_con.Offers[index].expiryDate.isAfter(DateTime.now())&& days!='')
                                        Container(
                                         height: 25.h,
                                         width: 110.w,
                                          //color: Colors.amber,
                                          alignment: Alignment.centerLeft,
                                          child: Text(days, style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .merge(
                                                        TextStyle(
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 11,
                                                          height: 1.h,
                                                          color: Helper.of(context)
                                                              .getColorFromHex(_con.Offers[index]
                                                                  .textColor),
                                                        ),
                                                      ),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,),


                                                  
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):Container();
                }),
          );
  }
}
