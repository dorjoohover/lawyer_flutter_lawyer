import 'package:dio/dio.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/providers/dio_provider.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final DioProvider apiProvider;

  Future<LoginResponse> login(String phone, String password) async {
    final data = {"phone": phone, "password": password};
    final res = await apiProvider.post('/auth/login', data: data);
    print('asdf');
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

  Future<List<User>> suggestedLawyersByCategory(
      String id, String cateId) async {
    try {
      final response =
          await apiProvider.get('/user/suggest/lawyer/$id/$cateId');
      final lawyers = (response as List).map((e) => User.fromJson(e)).toList();
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
    int date,
    String lawyerId,
    int expiredTime,
    int price,
    String serviceType,
    String serviceId,
    String subServiceId,
    LocationDto location,
  ) async {
    try {
      final data = {
        "date": date,

        "lawyerId": lawyerId,
        "serviceId": serviceId,
        "subServiceId": subServiceId,
        "location": location,
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

  Future<bool> createEmergencyOrder(
    int date,
    String lawyerId,
    int expiredTime,
    int price,
    String serviceType,
    String reason,
    LocationDto location,
  ) async {
    try {
      final data = {
        "date": date,
        "reason": reason,
        "lawyerId": lawyerId,
        "location": location,
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
      print(data);

      final response = await apiProvider.post('/order/emergency', data: data)
          as Map<String, dynamic>;
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> updateLawyer(User user) async {
    try {
      final data = {
        'experience': user.experience,
        'education': user.education,
        'degree': user.degree,
        'account': user.account,
        'licenseNumber': user.licenseNumber,
        'location': user.location,
        'certificate': user.certificate,
        'taxNumber': user.taxNumber,
        'workLocation': user.workLocation,
        'officeLocation': user.officeLocation,
        'experiences': user.experiences,
        'registerNumber': user.registerNumber,
        'profileImg': user.profileImg,
        'userServices': user.userServices,
        'workLocationString': user.workLocationString,
        'officeLocationString': user.officeLocationString,
        'email': user.email,
        'phoneNumbers': user.phoneNumbers,
        'profileImg': user.profileImg ?? '',
      };
      final res = await apiProvider.patch('/user', data: data) as String;
      print(res);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> addAvailableDays(Time time) async {
    try {
      final data = {
        "service": time.service,
        "serviceType": time.serviceType,
        "timeDetail": time.timeDetail,
      };

      final response = await apiProvider.post('/time', data: data);

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  Future<List<Time>> activeLawyer(
      String id, String type, int t, bool isActive) async {
    try {
      print('/time/active/$t/$id/$type/$isActive');
      final response =
          await apiProvider.get('/time/active/$t/$id/$type/$isActive');
      final time = (response as List).map((e) => Time.fromJson(e)).toList();
      return time;
    } on Exception {
      rethrow;
    }
  }

  Future<Order> setChannel(
    String url,
    String orderId,
    String channelName,
    String token,
  ) async {
    try {
      final response = await apiProvider.get(
        '/order/$url/token/$orderId/$channelName/{token}?token=$token',
      ) as Map<String, dynamic>;

      return Order.fromJson(response);
    } on Exception {
      rethrow;
    }
  }

  Future<Order> getChannel(String id) async {
    try {
      final response = await apiProvider.get(
        '/order/user/$id',
      ) as Map<String, dynamic>;

      return Order.fromJson(response);
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

  Future<Time> getTimeLawyer(String id) async {
    try {
      final response = await apiProvider.get(
        '/time/lawyer/$id',
      );
      if (response == null) {
        return Time(sId: '');
      } else {
        return Time.fromJson(response);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<LocationDto> getLawyerLocation(String id) async {
    try {
      final response = await apiProvider.get(
        '/user/lawyer/location/$id',
      );
      if (response == null) {
        return LocationDto(lat: 0.0, lng: 0.0);
      } else {
        return LocationDto.fromJson(response);
      }
    } on Exception catch (e) {
      print(e);
      return LocationDto(lat: 0.0, lng: 0.0);
    }
  }

  Future<bool> updateLawyerLocation(LocationDto location) async {
    try {
      final data = {
        "lat": location.lat,
        "lng": location.lng,
      };
      await apiProvider.patch('/user/location', data: data);

      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Time>> getTimeService(String service, String type) async {
    try {
      final response = await apiProvider.get('/time/service/$service/$type');
      final times = (response as List).map((e) => Time.fromJson(e)).toList();
      return times;
    } on Exception {
      rethrow;
    }
  }
}
