class UserData {
  bool? error;
  //List<String>? message;
  UserProfile? user;

  UserData({this.error, this.user});

  UserData.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    //message = json['message'];
    if(json["data"] == null)
      user = json['user'] != null ? new UserProfile.fromJson(json['user']) : null;
    else
    user = json['data'] != null ? new UserProfile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['error'] = this.error;
    //data['message'] = this.message;
    if (this.user != null) {
      data['data'] = this.user!.toJson();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  String? username= "";
  String? mobileNumber;
  String? shopName= "";
  String? gstNumber= "";
  String? address= "";
  String? referenceName;
  String? email = "";

  UserProfile(
      {this.id,
        required this.username,
        this.mobileNumber,
        required this.shopName,
        required this.gstNumber,
        required this.address,
        required this.referenceName,
        required this.email});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    mobileNumber = json['mobile_number'];
    shopName = json['shop_name'];
    gstNumber = json['gst_number'];
    address = json['address'];
    referenceName = json['reference_name'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['mobile_number'] = this.mobileNumber;
    data['shop_name'] = this.shopName;
    data['gst_number'] = this.gstNumber;
    data['address'] = this.address;
    data['reference_name'] = this.referenceName;
    data['email'] = this.email;
    data['id'] = this.id;
    return data;
  }
}