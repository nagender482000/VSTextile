

class Collections {
  Collections({
    required this.data,
    required this.error,
  });
  late final List<Data> data;
  late final bool error;

  Collections.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.description,
    required this.slug,
    required this.products,
  });
  late final int id;
  late final String name;
  late final String description;
  late final String slug;
  late final Products products;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    slug = json['slug'];
    products = Products.fromJson(json['products']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['slug'] = slug;
    _data['products'] = products.toJson();
    return _data;
  }
}

class   Products {
  Products({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final List<ProductData> data;

  Products.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = List.from(json['data']).map((e)=>ProductData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ProductData {
  ProductData({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.slug,
    required this.productId,
    this.label,
    required this.finalPrice,
    required this.image,
    required this.thumbnail,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String price;
  late final String slug;
  late final String productId;
  late final String? label;
  late final String finalPrice;
  late final Imagedata image;
  late final Thumbnail thumbnail;

  ProductData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    slug = json['slug'];
    productId = json['product_id'];
    label = null;
    finalPrice = json['final_price'];
    image = Imagedata.fromJson(json['image']);
    thumbnail = Thumbnail.fromJson(json['thumbnail']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['price'] = price;
    _data['slug'] = slug;
    _data['product_id'] = productId;
    _data['label'] = label;
    _data['final_price'] = finalPrice;
    _data['image'] = image.toJson();
    _data['thumbnail'] = thumbnail.toJson();
    return _data;
  }


  String getDiscount(){
    return "₹ "+(double.parse(price) - double.parse(finalPrice)).toString();
  }

}

class Imagedata {
  Imagedata({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final UrlData data;

  Imagedata.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = UrlData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.toJson();
    return _data;
  }
}
class Thumbnail {
  Thumbnail({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final UrlData data;

  Thumbnail.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = UrlData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.toJson();
    return _data;
  }
}

class UrlData {
  UrlData({
    required this.name,
    required this.url,
  });
  late final String name;
  late final String url;

  UrlData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['url'] = url;
    return _data;
  }
}