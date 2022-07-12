import 'package:vstextile/models/home/Categories.dart';

import 'carousel.dart';
import 'collections.dart';

class HomeData {
  HomeData({
    required this.carousel,
    required this.collections,
  });

  late final Carousel carousel;
  late final Collections collections;
  late final Categories categories;

  HomeData.fromJson(Map<String, dynamic> json) {
    carousel = Carousel.fromJson(json['carousel']);
    collections = Collections.fromJson(json['collections']);
    categories = Categories.fromJson(json['categories']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['carousel'] = carousel.toJson();
    _data['collections'] = collections.toJson();
    _data['categories'] = categories.toJson();
    return _data;
  }
}
