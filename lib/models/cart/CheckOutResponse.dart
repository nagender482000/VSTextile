// ignore_for_file: file_names

class CheckOutResponse {
  CheckOutResponse({
      bool? error,
    List<String>? message,
    String? orderId,
      int? amount,}){
    _error = error;
    _orderId = orderId;
    _message = message;
    _amount = amount;
}

  CheckOutResponse.fromJson(dynamic json) {

    _message = json['message'] != null ? json['message'].cast<String>() : [];
    _error = json['error'];
    _orderId = json['order_id'];
    _amount = json['amount'];
  }
  bool? _error;
  List<String>? _message;
  String? _orderId;
  int? _amount;
CheckOutResponse copyWith({  bool? error,
  String? orderId,
  int? amount,
}) => CheckOutResponse(  error: error ?? _error,
  orderId: orderId ?? _orderId,
  amount: amount ?? _amount,
);
  bool? get error => _error;
  String? get orderId => _orderId;
  int? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    map['order_id'] = _orderId;
    map['amount'] = _amount;
    return map;
  }

}