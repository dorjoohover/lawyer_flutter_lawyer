import 'package:frontend/data/data.dart';
import 'package:frontend/providers/dio_provider.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final DioProvider apiProvider;

  Future<LoginResponse> login(String phone, String password) async {
    final data = {"phone": phone, "password": password};
    final res = await apiProvider.post('/auth/login', data: data);
    return LoginResponse.fromJson(res);
  }

  Future<User> getUser() async {
    try {
      print('asdfs');
      final response =
          await apiProvider.get('/user/me') as Map<String, dynamic>;
      print(response);
      return User.fromJson(response);
    } on Exception {
      rethrow;
    }
  }
}
