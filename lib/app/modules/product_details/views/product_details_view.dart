import 'package:antier_flutter_task/app/widgets/card_swipe_page.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/favorite_button.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${controller.product.price}",
                style: context.textTheme.displaySmall,
              ),
              ElevatedButton(onPressed: () {}, child: Text("Buy Now"))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardSwipePage(
              imagesList: controller.product.images ?? [],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.product.title ?? "",
                  style: context.textTheme.titleLarge,
                ),
                FavoriteButton(
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Description",
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.product.description ?? "",
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
