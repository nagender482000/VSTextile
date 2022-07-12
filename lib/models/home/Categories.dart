// ignore_for_file: file_names

import 'package:vstextile/models/home/collections.dart';

class Categories {
  Categories({
    required this.data,
    required this.error,
  });

  late final List<CategoriesItem> data;
  late final bool error;

  Categories.fromJson(Map<String, dynamic> json) {
    data =
        List.from(json['data']).map((e) => CategoriesItem.fromJson(e)).toList();
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['error'] = error;
    return _data;
  }
}

class CategoriesItem {
  CategoriesItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.images,
    required this.products,
  });

  late final int id;
  late final String name;
  late final String slug;
  late final ImageData images;
  late final Products products;

  CategoriesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    images = ImageData.fromJson(json['images']);
    products = Products.fromJson(json['products']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['images'] = images.toJson();
    _data['products'] = products.toJson();
    return _data;
  }
}
class ImageData {
  ImageData({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final List<UrlData> data;

  ImageData.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data =  List.from(json['data']).map((e) => UrlData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}