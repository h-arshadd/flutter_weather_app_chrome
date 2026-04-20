import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/translations/strings_enum.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_shimmer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (_) => MyWidgetsAnimator(
            apiCallStatus: controller.apiCallStatus,
            // While loading: full-screen centered indicator
            loadingWidget: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.primaryColor,
                    strokeWidth: 3,
                  ),
                  24.verticalSpace,
                  Text(
                    'Getting your location...',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // On error: retry button
            errorWidget: () => ApiErrorWidget(
              retryAction: () => controller.getUserLocation(),
            ),
            // On success: nothing — HomeController already called Get.offNamed(WEATHER)
            successWidget: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}