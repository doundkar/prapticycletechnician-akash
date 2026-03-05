class ComponentItemsModel {
  int? id;
  static int? currentPage;
  static int? lastPage;
  String? categoryId;
  int? subcategoryId;
  String? title;
  String? brand;
  String? size;
  String? price;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? replacePrice;
  String? productId;
  String? materialsId;
  String? isFeatured;
  String? gst;
  int qty = 0;

  ComponentItemsModel(
      {this.id,
      this.categoryId,
      this.subcategoryId,
      this.title,
      this.brand,
      this.size,
      this.price,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.replacePrice,
      this.productId,
      this.materialsId,
      this.isFeatured,
      this.gst,
      this.qty = 0});

  ComponentItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    title = json['title'];
    brand = json['brand'] ?? "";
    size = json['size'] ?? "";
    price = json['price'];
    image = json['image'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    replacePrice = json['replace_price'] ?? "";
    productId = json['product_id'];
    materialsId = json['materials_id'] ?? "";
    isFeatured = json['is_featured'];
    gst = json['gst'];
    qty = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['title'] = this.title;
    data['brand'] = this.brand;
    data['size'] = this.size;
    data['price'] = this.price;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['replace_price'] = this.replacePrice;
    data['product_id'] = this.productId;
    data['materials_id'] = this.materialsId;
    data['is_featured'] = this.isFeatured;
    data['gst'] = this.gst;
    return data;
  }
}
