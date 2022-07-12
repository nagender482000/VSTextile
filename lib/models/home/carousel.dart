class Carousel {
  Carousel({
    required this.data,
    required this.error,
  });
  late final List<CarouselData> data;
  late final bool error;

  Carousel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>CarouselData.fromJson(e)).toList();
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    return _data;
  }
}
class CarouselData {
  CarouselData({
    required this.id,
    required this.name,
    required this.slug,
    required this.carouselItems,
  });
  late final int id;
  late final String name;
  late final String slug;
  late final CarouselItems carouselItems;

  CarouselData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    carouselItems = CarouselItems.fromJson(json['carousel_items']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['carousel_items'] = carouselItems.toJson();
    return _data;
  }
}

class CarouselItems {
  CarouselItems({
    required this.data,
    required this.error,
  });
  late final List<CarouselItemData> data;
  late final bool error;

  CarouselItems.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>CarouselItemData.fromJson(e)).toList();
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    return _data;
  }
}

class CarouselItemData {
  CarouselItemData({
    required this.id,
    required this.name,
    required this.url,
    required this.images,
  });
  late final int id;
  late final String name;
  late final String url;
  late final Images images;

  CarouselItemData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    url = json['url'];
    images = Images.fromJson(json['images']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['url'] = url;
    _data['images'] = images.toJson();
    return _data;
  }
}

class Images {
  Images({
    required this.error,
    required this.url,
  });
  late final bool error;
  late final String url;

  Images.fromJson(Map<String, dynamic> json){
    error = json['error'];
    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['url'] = url;
    return _data;
  }
}
