class Constants {
  static const String BASE_URL = 'http://65.0.73.128:3000';

  static String getProfile() {
    return BASE_URL + "/user/profile";
  }
  static String editProfile(String token) {
    return BASE_URL + "/user/updateuserdata";
  }
  static String addProfile(String token) {
    return BASE_URL + "/user/adduserdata";
    //return "https://mocki.io/v1/509a1b50-5c50-4489-9f29-c45abda9e80a";
  }

  static String getCategories(){
    return BASE_URL + "/shop/categories";
  }

  static String getProductListing(int categoryID){
    return BASE_URL + "/shop/products/$categoryID";
  }


  static String getProductDetails(int productID){
    return BASE_URL + "/shop/product/$productID";
  }

  static String getHomeFeed(){
    return BASE_URL + "/shop/homepage";
  }
  static String addToCart(){
    return BASE_URL + "/user/cart";
  }
  static String productCheckout(){
    return BASE_URL + "/user/checkoutproduct";
  }
  static String checkoutcart(){
    return BASE_URL + "/user/checkoutcart";
  }
  static String getCart(){
    return BASE_URL + "/user/cart";
  }
  static String removeCart(int cartID){
    return BASE_URL + "/user/cart/$cartID";
  }
  static String removeAddress(int addressId){
    return BASE_URL + "/user/address/$addressId";
  }
  static String updateCart(int cartItemD,int quantity){
    return BASE_URL + "/user/cart/$cartItemD/$quantity";
  }

  static String getAddress(){
    return BASE_URL + "/user/address";
  }
  static String getOrders(){
    return BASE_URL + "/user/orders";
  }
  static String addAddress(){
    return BASE_URL + "/user/address";
  }
  static String updateAddress(){
    return BASE_URL + "/user/address";
  }

}