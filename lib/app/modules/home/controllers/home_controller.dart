import 'package:antier_flutter_task/app/data/helpers/db_helper.dart';
import 'package:antier_flutter_task/app/data/network/api_constants.dart';
import 'package:antier_flutter_task/app/data/network/api_request.dart';
import 'package:antier_flutter_task/app/data/network/base_client.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RxList<ProductModel> products = <ProductModel>[].obs;

  RxList productCategories = ["All"].obs;
  RxInt limit = 20.obs;
  RxInt page = 0.obs;

  RxBool loading = false.obs;

  RxString selectedCategories = "All".obs;

  @override
  void onInit() {
    // Load data from storage
    getCategories();
    List<dynamic>? storedData = DbHelper.readData(DbKeys.products);
    page.value = DbHelper.readData(DbKeys.pageNo) ?? 0;

    if (storedData != null && storedData.isNotEmpty) {
      products.value =
          storedData.map((data) => ProductModel.fromJson(data)).toList();
    } else {
      loading.value = true;

      fetchProducts();
    }
    super.onInit();
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    selectedCategories.value = "All";
    page.value = 0;
    products.clear();
    await fetchProducts();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  Future<void> onLoading() async {
    // monitor network fetch
    ++page.value;
    await fetchProducts();
    refreshController.loadComplete();
  }

  void saveProducts({required List<dynamic> data}) {
    // Save data to storage
    DbHelper.writeData(DbKeys.products, data);
    DbHelper.writeData(DbKeys.pageNo, page.value);
  }

  Future<void> fetchProducts() async {
    if (selectedCategories.value != "All") {
      loading.value = true;
      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.categoryListUrl(category: selectedCategories.value),
          requestType: RequestType.GET);

      var response = await BaseClient.handleRequest(apiRequest);
      products.clear();
      for (var element in response['products']) {
        products.add(ProductModel.fromJson(element));
      }
      loading.value = false;
      return;
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.productListUrl(limit: limit.value, page: page.value),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    for (var element in response['products']) {
      products.add(ProductModel.fromJson(element));
    }
    saveProducts(data: products.toList());
    loading.value = false;
  }

  Future<void> getCategories() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.productCategoriesUrl, requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    for (var element in response) {
      productCategories.add(element);
    }
  }
}
