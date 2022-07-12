import 'package:vstextile/models/categories/pagination.dart';

class CategoriesData {
  CategoriesData({
    required this.categories,
    required this.pagination,
  });

  late final List<Categories> categories;
  late final Pagination pagination;

  CategoriesData.fromJson(Map<String, dynamic> json) {
    categories = List.from(json['categories'])
        .map((e) => Categories.fromJson(e))
        .toList();
    pagination = Pagination.fromJson(json['pagination']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e) => e.toJson()).toList();
    _data['pagination'] = pagination.toJson();
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
    required this.slug,
    required this.images,
  });

  late final int id;
  late final String name;
  late final String slug;
  late final Images images;

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    images = Images.fromJson(json['images']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['images'] = images.toJson();
    return _data;
  }
}

class Images {
  Images({
    required this.error,
    required this.data,
  });

  late final bool error;
  late final List<ImageArrayData> data;

  Images.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = List.from(json['data']).map((e) => ImageArrayData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ImageArrayData {
  ImageArrayData({
    required this.id,
    required this.name,
    required this.url,
  });

  late final int id;
  late final String name;
  late final String url;

  ImageArrayData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['url'] = url;
    return _data;
  }
}
