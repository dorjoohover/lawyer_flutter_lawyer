import 'package:frontend/modules/agora/views/audio.dart';
import 'package:frontend/modules/agora/views/video.dart';
import 'package:frontend/modules/home/bindings/home_bindings.dart';
import 'package:frontend/modules/home/views/home_view.dart';
import 'package:get/get.dart';

// ignore_for_file: constant_identifier_names

part './routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        children: [
          GetPage(
            name: Routes.AUDIO,
            page: () => AudioView(),
          ),
          GetPage(
            name: Routes.VIDEO,
            page: () => VideoView(),
          ),
        ]),
    // GetPage(
    //     name: Routes.FIND_MATCH,
    //     page: () => const FindMatchView(),
    //     binding: FindMatchBinding()),
  ];
}
