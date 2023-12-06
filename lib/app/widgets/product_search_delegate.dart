import 'dart:async';

import 'package:antier_flutter_task/app/data/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/api_constants.dart';
import '../data/network/api_request.dart';
import '../data/network/base_client.dart';
import '../routes/app_pages.dart';
import 'app_empty_widget.dart';
import 'app_error_widget.dart';
import 'loading_widget.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  List<ProductModel> data = [];
  Timer? _debounceTimer; // Timer to delay API calls while typing

  Future<List<ProductModel>> explorePosts({required String text}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.searchProductUrl(query: text),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);
    data.clear();
    for (var element in response['products']) {
      data.add(ProductModel.fromJson(element));
    }
    return data;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          // Clear the search query
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        // Close the search bar
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search results here

    // Start the timer to delay API calls while typing
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      explorePosts(text: query).then((_) {
        // Refresh the UI with the search results
        if (query.isNotEmpty) {
          showSuggestions(context);
        } else {
          // Clear the results when the query is empty
          data.clear();
          showSuggestions(context);
        }
      });
    });

    return FutureBuilder<List<ProductModel>>(
        future: explorePosts(text: query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> productList = snapshot.data ?? [];
            return productList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: productList[index].thumbnail ?? "",
                          height: 80,
                          width: 80,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(productList[index].title ?? ""),
                        subtitle: Text(productList[index].description ?? ""),
                        onTap: () {
                          Get.toNamed(Routes.PRODUCT_DETAILS,
                              arguments: productList[index]);
                        },
                      );
                    },
                  )
                : const AppEmptyWidget();
          }
          if (snapshot.hasError) {
            return const AppErrorWidget();
          }
          return const LoadingWidget();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement suggestions as the user types

    // Start the timer to delay API calls while typing
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      explorePosts(text: query).then((_) {
        // Refresh the UI with the search results
        if (query.isNotEmpty) {
          showSuggestions(context);
        } else {
          // Clear the results when the query is empty
          /*  data.clear();
          showSuggestions(context);*/
        }
      });
    });

    return FutureBuilder<List<ProductModel>>(
        future: explorePosts(text: query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> productList = snapshot.data ?? [];
            return productList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: productList[index].thumbnail ?? "",
                          height: 80,
                          width: 80,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(productList[index].title ?? ""),
                        subtitle: Text(productList[index].description ?? ""),
                        onTap: () {
                          Get.toNamed(Routes.PRODUCT_DETAILS,
                              arguments: productList[index]);
                        },
                      );
                    },
                  )
                : const AppEmptyWidget();
          }
          if (snapshot.hasError) {
            return const AppErrorWidget();
          }
          return const LoadingWidget();
        });
  }
}

/// https://we.tl/t-kSrbRyKnlH
///
/// https://drive.google.com/file/d/1M2V9O692YRGMNJPLWZMwQeNhU8AJHzGW/view?usp=sharing
///  https://github.com/alok2811/antier_flutter_task
