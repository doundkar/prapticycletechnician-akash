class ServiceItemModel {
  int? productId;
  String? title;
  int? price;
  int? quantity;
  String? image;

  ServiceItemModel(
      {this.productId, this.title, this.price, this.quantity, this.image});

  ServiceItemModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    return data;
  }
}
