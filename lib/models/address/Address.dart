// ignore_for_file: prefer_void_to_null, file_names

class Address {
  Address({
    bool? error,
    List<String>? message,
    List<AddressData>? data,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  Address.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'] != null ? json['message'].cast<String>() : [];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AddressData.fromJson(v));
      });
    }
  }

  bool? _error;
  List<AddressData>? _data;
  List<String>? _message;

  Address copyWith({
    bool? error,
    List<AddressData>? data,
    List<String>? message,
  }) =>
      Address(

        error: error ?? _error,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get error => _error;

  List<AddressData>? get data => _data;
  List<String>? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
class AddressData {
  AddressData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.pincode,
    required this.city,
    required this.state,
    required this.locality,
    required this.flatNo,
    this.landmark,
    required this.addressType,
    required this.defaultAddress,
  });
  late final int id;
  late final String name;
  late final String phoneNumber;
  late final String pincode;
  late final String city;
  late final String state;
  late final String locality;
  late final String flatNo;
  late final Null landmark;
  late final int addressType;
  late final bool defaultAddress;

  String getFullAddress(){
    return flatNo+", "+locality+", "+city+", "+state+" - "+pincode;
  }

  AddressData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    locality = json['locality'];
    flatNo = json['flat_no'];
    landmark = null;
    addressType = json['address_type'];
    defaultAddress = json['default_address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone_number'] = phoneNumber;
    _data['pincode'] = pincode;
    _data['city'] = city;
    _data['state'] = state;
    _data['locality'] = locality;
    _data['flat_no'] = flatNo;
    _data['landmark'] = landmark;
    _data['address_type'] = addressType;
    _data['default_address'] = defaultAddress;
    return _data;
  }
}
