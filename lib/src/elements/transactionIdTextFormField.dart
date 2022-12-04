// import 'package:flutter/material.dart';
// import 'package:bejaii_grocery/src/models/bankak_card.dart';

// import '../../generated/l10n.dart';
// import '../models/credit_card.dart';

// // ignore: must_be_immutable
// class TransactiionIdTextFormField extends StatefulWidget {
//  BankakId bankakId;
//   VoidCallback onChanged;

//  TransactiionIdTextFormField({Key key, this.bankakId, this.onChanged}) : super(key: key);

//   @override
//   _TransactiionIdTextFormFieldState  createState() => _TransactiionIdTextFormFieldState ();
// }

// class _TransactiionIdTextFormFieldState extends State<TransactiionIdTextFormField> {
//   GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//               return 
//                 //contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//                 // titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Form(
//                     key: _paymentSettingsFormKey,
//                     child: Container(
//                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                       child: TextFormField(
//                          style: TextStyle(color: Theme.of(context).hintColor),
//                          keyboardType: TextInputType.number,
//                          decoration: getInputDecoration(hintText: '4242 4242 424', labelText:"Trx ID"// S.of(context).number
//                          ),
//                          // ignore: missing_return
//                          validator: (value) {
//                                if (value.isEmpty) {
//                                  return S.of(context).thisFieldIsMandatory;
//                                }
//                                if (double.tryParse(value) == null) {
//                                S.of(context).pleaseEnterAvalidNumber;
//                                }
//                                 if (value.length!=11) {
//                                  return "Should be 11 digits";//S.of(context).pleaseEnterAvalidNumber;
//                                }

//                                },
//                          onSaved: (input) => widget.bankakId.transactionId = input,
//                        ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Row(
//                     // ignore: sort_child_properties_last
//                     children: <Widget>[
//                       MaterialButton(
//                         onPressed: _submit,
//                         child: Text(
//                           S.of(context).save,
//                           style: TextStyle(color: Theme.of(context).accentColor),
//                         ),
//                       ),
//                     ],
//                     mainAxisAlignment: MainAxisAlignment.end,
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               );
            
//   }

//   InputDecoration getInputDecoration({String hintText, String labelText}) {
//     return InputDecoration(
//       hintText: hintText,
//       labelText: labelText,
//       hintStyle: Theme.of(context).textTheme.bodyText2.merge(
//             TextStyle(color: Theme.of(context).focusColor),
//           ),
//       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
//       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
//       floatingLabelBehavior: FloatingLabelBehavior.auto,
//       labelStyle:Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
//     );
//   }

//   void _submit() {
//     if (_paymentSettingsFormKey.currentState.validate()) {
  
//       _paymentSettingsFormKey.currentState.save();
//        Navigator.pop(context);
//       widget.onChanged();
       

     
//     }
//   }
// }
