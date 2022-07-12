// ignore_for_file: file_names

class AddToCartResponse {
  AddToCartResponse({
    bool? error,
    String? cartCount,
  }) {
    _error = error;
    _cartCount = cartCount;
  }

  AddToCartResponse.fromJson(dynamic json) {
    _error = json['error'];
    _cartCount = json['cart_count'];
  }

  bool? _error;
  String? _cartCount;

  AddToCartResponse copyWith({
    bool? error,
    String? cartCount,
  }) =>
      AddToCartResponse(
        error: error ?? _error,
        cartCount: cartCount ?? _cartCount,
      );

  bool? get error => _error;

  String? get cartCount => _cartCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['cart_count'] = _cartCount;
    return map;
  }
}
