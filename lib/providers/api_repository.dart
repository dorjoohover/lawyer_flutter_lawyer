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
      String phone, String password, String firstName, String lastName) async {
    final data = {
      "phone": phone,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "userType": "lawyer"
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

  Future<List<User>> suggestedLawyers() async {
    try {
      final response = await apiProvider.get('/user/suggest/lawyer');
      final lawyers = (response as List).map((e) => User.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }



  Future<List<User>> suggestedLawyersByCategory(String id) async {
    try {
      final response = await apiProvider.get('/user/suggest/lawyer/$id');
      final lawyers = (response as List).map((e) => User.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }

  Future<List<ServicePrice>> getPrice(
      String lawyerId, String service, String serviceId) async {
    try {
      final response =
          await apiProvider.get('/price/$serviceId/$service/$lawyerId');
      print('/price/$serviceId/$service/$lawyerId');
      final prices =
          (response as List).map((e) => ServicePrice.fromJson(e)).toList();
      return prices;
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

  Future<bool> createOrder(int date, String lawyerId, String expiredTime,
      int price, String serviceType, String serviceId, String userId) async {
    try {
      final data = {
        "date": date,
        "clientId": userId,
        "lawyerId": lawyerId,
        "serviceId": serviceId,
        "location": "string",
        "expiredTime": expiredTime,
        "serviceType": serviceType,
        "serviceStatus": "pending",
        "channelName": "string",
        "channelToken": "string",
        "price": "$price",
        "lawyerToken": "string",
        "userToken": "string",
        // here
        
      };
      final response =
          await apiProvider.post('/order', data: data) as Map<String, dynamic>;
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> updateLawyer(int experience, String bio, String profileImg,
      AvailableDay availableDay) async {
    try {
      List<AvailableDay> availableDays = [];
      availableDays.add(availableDay);
      final data = {
        "bio": bio,
        "profileImg": profileImg,
        "experience": experience,
        "availableDays": availableDays
      };
      final response = await apiProvider.patch('/user', data: data) as String;
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> addAvailableDays(AvailableDay availableDay) async {
    try {
      final data = {
        "serviceTypes": availableDay.serviceTypeTime,
        "serviceId": availableDay.serviceId,
      };

      final response = await apiProvider.patch('/user/available', data: data);
      print(response);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> setChannel(
    String orderId,
    String channelName,
    String token,
  ) async {
    try {
      final response = await apiProvider.get(
        '/order/token/$orderId/$channelName/{token}?token=${token}',
      ) as String;
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
