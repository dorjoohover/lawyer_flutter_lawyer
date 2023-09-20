import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

class PrimeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrimeController>(() => PrimeController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController(), permanent: true);
  }
}

class OrderBinding extends Bindings {
  @override
  void dependencies() {}
}
