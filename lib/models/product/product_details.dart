

import 'package:vstextile/models/product/product_list_data.dart';

class ProductDetails {
  late final Products product;
  ProductDetails({
    required this.product,
  });

  ProductDetails.fromJson(Map<String, dynamic> json){
    product = Products.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['products'] = product.toJson();
    return _data;
  }
}



