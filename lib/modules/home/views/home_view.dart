import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

import '../../../config/agora.config.dart' as config;

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final controller = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => controller.obx(
          onLoading: const SplashWidget(),
          onError: (error) => Stack(
                children: [
                  const SplashWidget(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        borderOnForeground: true,
                        child: AnimatedContainer(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 400,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    "Check your internet connection and try again",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Obx(
                                  () => ElevatedButton(
                                    onPressed:
                                        controller.isLoading.value == true
                                            ? null
                                            : () => controller.setupApp(),
                                    child: const Text("Try again"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ), (user) {
        return Scaffold(
            body: Obx(() => controller.getView(controller.currentIndex.value)),
            bottomNavigationBar: const MainNavigationBar());
      }),
    );
  }
}

class InvalidConfigWidget extends StatelessWidget {
  /// Construct the [InvalidConfigWidget]
  const InvalidConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(
          'Make sure you set the correct appId, ${config.appId}, channelId, etc.. in the lib/config/agora.config.dart file.'),
    );
  }
}
