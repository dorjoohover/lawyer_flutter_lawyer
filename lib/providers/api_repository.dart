import 'package:dio/dio.dart';
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

  Future<LoginResponse> register(
      String phone, String password, String firstname, String lastname) async {
    final data = {
      "phone": phone,
      "password": password,
      "firstname": firstname,
      "lastname": lastname,
      "userType": "user"
    };
    final res = await apiProvider.post('/auth/register', data: data);
    return LoginResponse.fromJson(res);
  }

  Future<User> getUser() async {
    try {
      final response =
          await apiProvider.get('/user/me') as Map<String, dynamic>;
      return User.fromJson(response);
    } on Exception {
      rethrow;
    }
  }

  Future<List<Service>> servicesList() async {
    try {
      final response = await apiProvider.get('/service');
      final services =
          (response as List).map((e) => Service.fromJson(e)).toList();
      return services;
    } on Exception {
      rethrow;
    }
  }

  Future<List<SubService>> subServiceList(String id) async {
    try {
      final response = await apiProvider.get('/service/$id');
      final services =
          (response as List).map((e) => SubService.fromJson(e)).toList();
      return services;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Lawyer>> suggestedLawyers() async {
    try {
      final response = await apiProvider.get('/user/suggest/lawyer');
      final lawyers =
          (response as List).map((e) => Lawyer.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Lawyer>> suggestedLawyersByCategory(String id) async {
    try {
      final response = await apiProvider.get('/user/suggest/lawyer/$id');
      final lawyers =
          (response as List).map((e) => Lawyer.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }

  Future<Agora> getAgoraToken(String channelName, String uid) async {
    try {
      final response = await Dio().get(
          "https://agora-token-service-production-3c76.up.railway.app/rtc/$channelName/publisher/uid/$uid?expiry=9000");

      return Agora.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  Future<bool> createOrder(
      int date, String lawyerId, String expiredTime, String serviceType) async {
    try {
      final data = {
        "date": date,
        "clientId": "string",
        "lawyerId": lawyerId,
        "location": "string",
        "expiredTime": expiredTime,
        "serviceType": serviceType,
        "serviceStatus": "pending",
        "channelName": "string",
        "channelToken": "string"
      };
      final response = await apiProvider.post('/order/true', data: data)
          as Map<String, dynamic>;
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Order>> orderList() async {
    try {
      final response = await apiProvider.get('/order/user');
      final orders = (response as List).map((e) => Order.fromJson(e)).toList();
      return orders;
    } on Exception {
      rethrow;
    }
  }
}
