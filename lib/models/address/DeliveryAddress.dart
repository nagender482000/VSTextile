// ignore_for_file: file_names

import 'Address.dart';

class DeliveryAddress {
  DeliveryAddress({
    required this.deliveryAddresses,
  });
  late final Address deliveryAddresses;

  DeliveryAddress.fromJson(Map<String, dynamic> json){
    deliveryAddresses = Address.fromJson(json['delivery_addresses']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['delivery_addresses'] = deliveryAddresses.toJson();
    return _data;
  }
}