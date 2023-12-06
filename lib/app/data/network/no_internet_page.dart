import 'package:antier_flutter_task/res/assets_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_request.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage(
      {Key? key, required this.callBack, required this.apiRequest})
      : super(key: key);
  final ApiRequest apiRequest;
  final Function(ApiRequest apiRequest) callBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsRes.NO_WIFI),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Oops!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'No internet connection found.Please check your connection or try again.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await callBack(apiRequest);
                },
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
