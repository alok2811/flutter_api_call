import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSwipePage extends StatefulWidget {
  final double? height;
  final List? imagesList;
  const CardSwipePage({super.key, this.height, this.imagesList});

  @override
  State<CardSwipePage> createState() => _CardSwipePageState();
}

class _CardSwipePageState extends State<CardSwipePage> {
  List bannerImages = [];

  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    bannerImages = widget.imagesList ?? [];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 400,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    bannerImages[index],
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
          _buildDots(),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bannerImages.map((image) {
          int index = bannerImages.indexOf(image);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? context.theme.primaryColor
                  : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }
}
