import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bejaii_grocery/src/models/bankak_card.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart' as userModel;
import '../pages/mobile_verification_2.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  BankakId bankakId=BankakId();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> verifyPhone(userModel.User user) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      repository.currentUser.value.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      repository.currentUser.value.verificationId = verId;
      Navigator.push(
        scaffoldKey.currentContext,
        MaterialPageRoute(
            builder: (context) => MobileVerification2(
                  onVerified: (v) {
                    Navigator.of(scaffoldKey.currentContext).pushNamed('/Settings');
                  },
                )),
      );
    };
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted _verifiedSuccess = (AuthCredential auth) {
      Navigator.of(scaffoldKey.currentContext).pushNamed('/Settings');
    };
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
e.message,
                    
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
      //  content: Text(e.message),
      //));
      print(e.toString());
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phone,
      timeout: const Duration(seconds:120),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  void update(userModel.User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
S.of(state.context).profile_settings_updated_successfully,
                    
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
    //    content: Text(S.of(state.context).profile_settings_updated_successfully),
      //));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
S.of(state.context).payment_settings_updated_successfully,
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
     //   content: Text(S.of(state.context).payment_settings_updated_successfully),
      //));
      
    });
  }
//   void updatebankakId(BankakId bankakId) {
//     repository.setBankakId(bankakId).then((value) {
//       setState(() {});
//       showDialog(
//                     context: scaffoldKey?.currentContext,
//                     builder: (ctx) => AlertDialog(
//                         content: Text(
// S.of(state.context).payment_settings_updated_successfully,
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                           child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
//                           onPressed: () {
//                             Navigator.of(ctx).pop(false);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//    //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
//      //   content: Text(S.of(state.context).payment_settings_updated_successfully),
//       //));
//     });
//   }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    // bankakId=await repository.getBankakId();
    setState(() {});
  }
}
