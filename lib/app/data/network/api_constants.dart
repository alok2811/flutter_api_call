class ApiConstants {
  static const String _baseUrl = "https://dummyjson.com/products";

  static String productCategoriesUrl = "$_baseUrl/categories";
  static String productListUrl({required int limit, required int page}) =>
      "$_baseUrl?limit=$limit&skip=$page";
  static String categoryListUrl({required String category}) =>
      "$_baseUrl/category/$category";

  static String searchProductUrl({required String query}) =>
      "$_baseUrl/search?q=$query";
}
