import 'dart:ffi';

import 'package:antier_flutter_task/app/data/models/product_model.dart';
import 'package:antier_flutter_task/app/routes/app_pages.dart';
import 'package:antier_flutter_task/app/widgets/product_search_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Obx(() => DropdownButton<String>(
                alignment: AlignmentDirectional.center,
                icon: const Icon(
                    Icons.keyboard_arrow_down_rounded), // Custom icon
                iconSize: 24.0, // Set the icon size
                hint: Text(
                  controller.selectedCategories.value,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium,
                ),
                underline: const SizedBox.shrink(),
                onChanged: (String? newValue) {
                  controller.selectedCategories.value = newValue ?? "All";
                  if (newValue == "All") {
                    controller.loading.value = true;
                    controller.products.clear();
                  }
                  controller.fetchProducts();
                },
                items: controller.productCategories.value
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              readOnly: true,
              enabled: true,
              onTap: () {
                showSearch(context: context, delegate: ProductSearchDelegate());
              },
              decoration: InputDecoration(
                  hintText: "Search Products",
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                        color: Colors.black), // Change the color here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                  )),
            ),
          ),
          Expanded(
              child: Obx(() => controller.loading.value
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : buildProductList())),
        ],
      ),
    );
  }

  Widget buildProductList() {
    // Group products by category
    Map<String, List<ProductModel>> groupedProducts = {};

    for (ProductModel product in controller.products) {
      if (!groupedProducts.containsKey(product.category)) {
        groupedProducts[product.category!] = [];
      }
      groupedProducts[product.category]!.add(product);
    }

    // Create a list of categories
    List<String> categories = groupedProducts.keys.toList();

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.separated(
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          String category = categories[index];
          List<ProductModel> categoryProducts = groupedProducts[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category header
              ListTile(
                title: Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Products in the category
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductModel product = categoryProducts[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: categoryProducts[index].thumbnail ?? "",
                      height: 80,
                      width: 80,
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(categoryProducts[index].title ?? ""),
                    subtitle: Text(categoryProducts[index].description ?? ""),
                    onTap: () {
                      Get.toNamed(Routes.PRODUCT_DETAILS,
                          arguments: categoryProducts[index]);
                    },
                  );
                },
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox.shrink(),
      ),
    );
  }
}
