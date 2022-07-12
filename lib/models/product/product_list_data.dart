import 'package:vstextile/models/product/variant.dart';

import '../categories/categories_data.dart';
import '../categories/pagination.dart';

class ProductListData {
  ProductListData({
    required this.category,
    required this.products,
    required this.pagination,
  });
  late final Category category;
  late final List<Products> products;
  late final Pagination pagination;

  ProductListData.fromJson(Map<String, dynamic> json){
    category = Category.fromJson(json['category']);
    products = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
    pagination = Pagination.fromJson(json['pagination']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category.toJson();
    _data['products'] = products.map((e)=>e.toJson()).toList();
    _data['pagination'] = pagination.toJson();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
  });
  late final int id;
  late final String name;
  late final String slug;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    return _data;
  }
}

class Products {
  Products({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.final_price,
    required this.slug,
    required this.productId,
    required this.label,
    required this.images,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String price;
  late final String final_price;
  late final String slug;
  late final String productId;
  late final String label;
  late final Images images;
  late final Variant? variant;
   VariantData? selectedVariant;


  Products.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    final_price = json['final_price'] == null ?"":json["final_price"];
    slug = json['slug'];
    productId = json['product_id'];
    label = json['label'] == null?"":json['label'] ;
    images = Images.fromJson(json['images']);
    variant = json['variant'] !=null ? Variant.fromJson(json['variant']) : null;

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['price'] = price;
    _data['final_price'] = final_price;
    _data['slug'] = slug;
    _data['product_id'] = productId;
    _data['label'] = label;
    _data['images'] = images.toJson();
    return _data;
  }
}

