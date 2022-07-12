class Variant {
  Variant({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final List<VariantData> data;
  Variant.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = List.from(json['data']).map((e)=>VariantData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }

}
class VariantData {
  VariantData({
    required this.id,
    required this.quantity,
    required this.colors,
    required this.sizes,
  });
  late final int id;

  bool isSelected = false;

  late final int quantity;
  late final ColorsData colors;
  late final Sizes sizes;

  VariantData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    quantity = json['quantity'];
    colors = ColorsData.fromJson(json['colors']);
    sizes = Sizes.fromJson(json['sizes']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['quantity'] = quantity;
    _data['colors'] = colors.toJson();
    _data['sizes'] = sizes.toJson();
    return _data;
  }
}

class ColorsData {
  ColorsData({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final List<ColorSizeData> data;

  ColorsData.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = List.from(json['data']).map((e)=>ColorSizeData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Sizes {
  Sizes({
    required this.error,
    required this.data,
  });
  late final bool error;
  late final List<ColorSizeData> data;

  Sizes.fromJson(Map<String, dynamic> json){
    error = json['error'];
    data = List.from(json['data']).map((e)=>ColorSizeData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ColorSizeData {
  ColorSizeData({
    required this.id,
    required this.name,
    required this.slug,
  });
  late final int id;
  late final String name;
  late final String slug;

  ColorSizeData.fromJson(Map<String, dynamic> json){
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