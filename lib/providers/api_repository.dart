import 'package:frontend/providers/dio_provider.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final DioProvider apiProvider;
  //  Future<User> getUser() async {
  //   try {
  //     final response =
  //         await apiProvider.get('/user/me') as Map<String, dynamic>;
  //     return User.fromJson(response);
  //   } on Exception {
  //     rethrow;
  //   }
  // }
}
