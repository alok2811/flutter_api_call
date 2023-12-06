import 'package:antier_flutter_task/app/routes/app_pages.dart';
import 'package:antier_flutter_task/res/assets_res.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  String imagePath = AssetsRes.SPLASH_LOGO;

  @override
  void onInit() {
    // TODO: implement onInit
    Future.delayed(const Duration(seconds: 2), () => Get.offNamed(Routes.HOME));
    super.onInit();
  }
}
