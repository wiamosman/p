import '../helpers/custom_trace.dart';

class BankakId{
  String transactionId;
 



BankakId();

  BankakId.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      transactionId = jsonMap["trx_id"].toString();
    } catch (e) {
       transactionId = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["trx_id"] = transactionId;
    return map;
  }

  bool validated() {
    return  transactionId  != null &&  transactionId  != '' ;
  }
}
