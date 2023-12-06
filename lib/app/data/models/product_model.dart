class ProductModel {
  final num? discountPercentage;
  final String? thumbnail;
  final List? images;
  final num? price;
  final num? rating;
  final String? description;
  final num? id;
  final String? title;
  final num? stock;
  final String? category;
  final String? brand;

  ProductModel({
    this.discountPercentage,
    this.thumbnail,
    this.images,
    this.price,
    this.rating,
    this.description,
    this.id,
    this.title,
    this.stock,
    this.category,
    this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      discountPercentage: json['discountPercentage'],
      thumbnail: json['thumbnail'],
      images: json['images'],
      price: json['price'],
      rating: json['rating'],
      description: json['description'],
      id: json['id'],
      title: json['title'],
      stock: json['stock'],
      category: json['category'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() => {
        'discountPercentage': discountPercentage,
        'thumbnail': thumbnail,
        'images': images,
        'price': price,
        'rating': rating,
        'description': description,
        'id': id,
        'title': title,
        'stock': stock,
        'category': category,
        'brand': brand,
      };
}
