// ignore_for_file: file_names


class Cart {
  Cart({
    bool? error,
    List<CartData>? cartData,
    double? totalPrice,
  }) {
    _error = error;
    _cartData = cartData;
    _totalPrice = totalPrice;
  }

  void setTotalAmount(value) {
    _totalPrice = value;
  }

  Cart.fromJson(dynamic json) {
    _error = json['error'];
    if (json['cart_data'] != null) {
      _cartData = [];
      json['cart_data'].forEach((v) {
        _cartData?.add(CartData.fromJson(v));
      });
    }
    _totalPrice = double.parse(json['total_price'].toString());
  }

  bool? _error;
  List<CartData>? _cartData;
  double? _totalPrice;

  Cart copyWith({
    bool? error,
    List<CartData>? cartData,
    double? totalPrice,
  }) =>
      Cart(
        error: error ?? _error,
        cartData: cartData ?? _cartData,
        totalPrice: totalPrice ?? _totalPrice,
      );

  bool? get error => _error;

  List<CartData>? get cartData => _cartData;

  double? get totalPrice => _totalPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_cartData != null) {
      map['cart_data'] = _cartData?.map((v) => v.toJson()).toList();
    }
    map['total_price'] = _totalPrice;
    return map;
  }
}

class CartData {
  CartData({
    dynamic cartItemId,
    required int itemQuantity,
    int? productId,
    String? title,
    String? slug,
    String? price,
    String? finalPrice,
    int? quantity,
    String? sizeName,
    String? sizeSlug,
    Thumbnail? thumbnail,
  }) {
    _cartItemId = cartItemId;
    _itemQuantity = itemQuantity;
    _productId = productId;
    _title = title;
    _slug = slug;
    _price = price;
    _finalPrice = finalPrice;
    _quantity = quantity;
    _sizeName = sizeName;
    _sizeSlug = sizeSlug;
    _thumbnail = thumbnail;
  }

  CartData.fromJson(dynamic json) {
    _cartItemId = json['cart_item_id'];
    _itemQuantity = json['item_quantity'];
    _productId = json['product_id'];
    _title = json['title'];
    _slug = json['slug'];
    _price = json['price'];
    _finalPrice = json['final_price'];
    _quantity = json['quantity'];
    _sizeName = json['size_name'];
    _sizeSlug = json['size_slug'];
    _thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
  }

  int? _cartItemId;
  int _itemQuantity = 0;
  int? _productId;
  String? _title;
  String? _slug;
  String? _price;
  String? _finalPrice;
  int? _quantity;
  String? _sizeName;
  String? _sizeSlug;
  Thumbnail? _thumbnail;

  CartData copyWith({
    String? cartItemId,
    required int itemQuantity,
    int? productId,
    String? title,
    String? slug,
    String? price,
    String? finalPrice,
    int? quantity,
    String? sizeName,
    String? sizeSlug,
    Thumbnail? thumbnail,
  }) =>
      CartData(
        cartItemId: cartItemId ?? _cartItemId,
        itemQuantity: itemQuantity,
        productId: productId ?? _productId,
        title: title ?? _title,
        slug: slug ?? _slug,
        price: price ?? _price,
        finalPrice: finalPrice ?? _finalPrice,
        quantity: quantity ?? _quantity,
        sizeName: sizeName ?? _sizeName,
        sizeSlug: sizeSlug ?? _sizeSlug,
        thumbnail: thumbnail ?? _thumbnail,
      );

  int? get cartItemId => _cartItemId;

  int get itemQuantity => _itemQuantity;

  int? get productId => _productId;

  String? get title => _title;

  String? get slug => _slug;

  String? get price => _price;

  String? get finalPrice => _finalPrice;

  int? get quantity => _quantity;

  String? get sizeName => _sizeName;

  String? get sizeSlug => _sizeSlug;

  Thumbnail? get thumbnail => _thumbnail;

  set itemQuantityValue(int value) {
    _itemQuantity = value;
  }

  void addQuantity() {
    _itemQuantity = _itemQuantity + 1;
  }

  void removeQuantity() {
    _itemQuantity = _itemQuantity - 1;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cart_item_id'] = _cartItemId;
    map['item_quantity'] = _itemQuantity;
    map['product_id'] = _productId;
    map['title'] = _title;
    map['slug'] = _slug;
    map['price'] = _price;
    map['final_price'] = _finalPrice;
    map['quantity'] = _quantity;
    map['size_name'] = _sizeName;
    map['size_slug'] = _sizeSlug;
    if (_thumbnail != null) {
      map['thumbnail'] = _thumbnail?.toJson();
    }
    return map;
  }
}

class Thumbnail {
  Thumbnail({
    bool? error,
    List<Data>? data,
  }) {
    _error = error;
    _data = data;
  }

  Thumbnail.fromJson(dynamic json) {
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  bool? _error;
  List<Data>? _data;

  Thumbnail copyWith({
    bool? error,
    List<Data>? data,
  }) =>
      Thumbnail(
        error: error ?? _error,
        data: data ?? _data,
      );

  bool? get error => _error;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    String? name,
    String? url,
  }) {
    _name = name;
    _url = url;
  }

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _url = json['url'];
  }

  String? _name;
  String? _url;

  Data copyWith({
    String? name,
    String? url,
  }) =>
      Data(
        name: name ?? _name,
        url: url ?? _url,
      );

  String? get name => _name;

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['url'] = _url;
    return map;
  }
}
