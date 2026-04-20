import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../routes/app_pages.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.of(context).size;

    // Constrain to mobile width on wide screens (Chrome/desktop)
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(Constants.welcome, fit: BoxFit.cover),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.30),
                        Colors.black.withOpacity(0.75),
                      ],
                      stops: const [0.30, 0.60, 1.0],
                    ),
                  ),
                ),
              ),

              // Bottom card — height-adaptive, never overflows
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.50,
                  ),
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Weather icon badge
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.wb_sunny_outlined,
                            color: theme.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Your Weather, Always Ready',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 20,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fade().slideY(
                              duration: 300.ms,
                              begin: -0.3,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 12),

                        Text(
                          'Get accurate forecasts, real-time updates and hourly details for any location around the world.',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(height: 1.55, fontSize: 14),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ).animate(delay: 150.ms).fade().slideY(
                              duration: 300.ms,
                              begin: -0.3,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 28),

                        // Get Started button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(Routes.HOME),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ).animate(delay: 250.ms).fade().slideY(
                              duration: 300.ms,
                              begin: 0.3,
                              curve: Curves.easeOut,
                            ),
                      ],
                    ),
                  ),
                ).animate().fade(duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}