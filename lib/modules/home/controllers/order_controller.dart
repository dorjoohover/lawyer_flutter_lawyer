import 'package:dio/dio.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final ApiRepository _apiRepository = Get.find();
  final selectedDate = DateTime.now().obs;
  final selectedTime = "".obs;
  @override
  void onInit() async {
    super.onInit();
  }

  createOrder(String lawyerId, String type) async {
    try {
      final res = await _apiRepository.createOrder(
          selectedDate.value.millisecondsSinceEpoch, lawyerId, "60", type);
      Get.to(() => AlertView(
          status: 'success',
          text:
              'Таны сонгосон хуульчтайгаа 2020/07/13-ны өдрийн 14:00 дуудлагаа хийнэ үү '));
      print(res);
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  onReady() {
    super.onReady();
  }
}
