import 'package:flutter/material.dart';
import 'package:bejaii_grocery/src/models/bankak_card.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';

// ignore: must_be_immutable
class PaymentSettingsDialog extends StatefulWidget {
 BankakId bankakId;
  VoidCallback onChanged;

  PaymentSettingsDialog({Key key, this.bankakId, this.onChanged}) : super(key: key);

  @override
  _PaymentSettingsDialogState createState() => _PaymentSettingsDialogState();
}

class _PaymentSettingsDialogState extends State<PaymentSettingsDialog> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).payment_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _paymentSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                       TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '4242 4242 424', labelText:"Trx ID"// S.of(context).number
                          ),
                       //   initialValue: "",//widget.bankakId.transactionId.isNotEmpty ? widget.bankakId.transactionId :"",
                          // ignore: missing_return
                          validator: (value) {
                                if (value.isEmpty) {
                                  return S.of(context).thisFieldIsMandatory;
                                }
                                if (double.tryParse(value) == null) {
                                  return S.of(context).pleaseEnterAvalidNumber;
                                }
                                 if (value.length!=11) {
                                  return S.of(context).pleaseEnterAvalidNumber;
                                }

                                },//(input) => input.trim().length != 11 ? S.of(context).not_a_valid_number : "",
                          onSaved: (input) => widget.bankakId.transactionId = input,
                        ),
                        // TextFormField(
                        //     style: TextStyle(color: Theme.of(context).hintColor),
                        //     keyboardType: TextInputType.text,
                        //     decoration: getInputDecoration(hintText: 'mm/yy', labelText: S.of(context).exp_date),
                        //     initialValue: widget.creditCard.expMonth.isNotEmpty ? widget.creditCard.expMonth + '/' + widget.creditCard.expYear : null,
                        //     // TODO validate date
                        //     validator: (input) => !input.contains('/') || input.length != 5 ? S.of(context).not_a_valid_date : null,
                        //     onSaved: (input) {
                        //       widget.creditCard.expMonth = input.split('/').elementAt(0);
                        //       widget.creditCard.expYear = input.split('/').elementAt(1);
                        //     }),
                        //  TextFormField(
                        //   style: TextStyle(color: Theme.of(context).hintColor),
                        //   keyboardType: TextInputType.number,
                        //   decoration: getInputDecoration(hintText: '253', labelText: S.of(context).cvc),
                        //   initialValue: widget.creditCard.cvc.isNotEmpty ? widget.creditCard.cvc : null,
                        //   validator: (input) => input.trim().length != 3 ? S.of(context).not_a_valid_cvc : null,
                        //   onSaved: (input) => widget.creditCard.cvc = input,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    // ignore: sort_child_properties_last
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle:Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
    );
  }

  void _submit() {
    if (_paymentSettingsFormKey.currentState.validate()) {
  
      _paymentSettingsFormKey.currentState.save();
       Navigator.pop(context);
      widget.onChanged();
       

     
    }
  }
}
