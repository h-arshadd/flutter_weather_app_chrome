import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  @override
  void onInit() async {
    await Future.delayed(const Duration(milliseconds: 800));
    Get.offNamed(Routes.WELCOME);
    super.onInit();
  }

}