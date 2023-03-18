import 'package:frontend/modules/prime/prime.dart';
import 'package:get/get.dart';

class PrimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrimeController>(() => PrimeController(), fenix: true);
  }
}
