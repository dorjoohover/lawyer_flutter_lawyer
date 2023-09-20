import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

class Routes {
  static String home = '/home';
  static String auth = '/auth';
  static String prime = '/prime';
  static String splash = '/';
  // static String LOGIN = _Paths.AUTH + _Paths.LOGIN;
  // static String AUDIO = _Paths.HOME + _Paths.AUDIO;
  // static String VIDEO = _Paths.HOME + _Paths.VIDEO;

  static final pages = [
    GetPage(
        name: splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: home, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: auth, page: () => const AuthView(), binding: AuthBinding()),
    GetPage(
        name: prime, page: () => const PrimeView(), binding: PrimeBinding()),
  ];
}
