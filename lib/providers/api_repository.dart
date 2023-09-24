import 'package:dio/dio.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiRepository extends GetxService {
  final isProduction = const bool.fromEnvironment('dart.vm.product');
  var dio = createDio();
  static var storage = GetStorage();
  final token = storage.read(StorageKeys.token.name);
  static Dio createDio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://lawyernestjs-production.up.railway.app',
    ));
    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // get token from storage
            final token = storage.read(StorageKeys.token.name);

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {}
            return handler.next(options);
          },
        ),
        // RetryOnConnectionChangeInterceptor()
        // LogInterceptor(responseBody: true),
      ],
    );
    return dio;
  }

  Future<LoginResponse> login(String phone, String password) async {
    final data = {"phone": phone, "password": password};
    final res = await dio.post('/auth/login', data: data);
    print('asdf');
    return LoginResponse.fromJson(res.data);
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
    final res = await dio.post('/auth/register', data: data);
    return LoginResponse.fromJson(res.data);
  }

  Future<User> getUser() async {
    try {
      final response = await dio.get('/user/me');

      return User.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  Future<List<Service>> servicesList() async {
    try {
      final response = await dio.get('/service');
      final services =
          (response.data as List).map((e) => Service.fromJson(e)).toList();
      return services;
    } on Exception {
      rethrow;
    }
  }

  Future<List<SubService>> subServiceList(String id) async {
    try {
      final response = await dio.get('/service/$id');
      final services =
          (response.data as List).map((e) => SubService.fromJson(e)).toList();
      return services;
    } on Exception {
      rethrow;
    }
  }

  Future<List<User>> suggestedLawyers() async {
    try {
      final response = await dio.get('/user/suggest/lawyer');
      final lawyers =
          (response.data as List).map((e) => User.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }

  Future<List<User>> suggestedLawyersByCategory(
      String id, String cateId) async {
    try {
      final response = await dio.get('/user/suggest/lawyer/$id/$cateId');
      final lawyers =
          (response.data as List).map((e) => User.fromJson(e)).toList();
      return lawyers;
    } on Exception {
      rethrow;
    }
  }

  Future<Agora> getAgoraToken(String channelName, int uid) async {
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

      await dio.post('/order', data: data);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> sendRating(
    String id,
    double rate,
    String comment,
  ) async {
    try {
      final data = {
        "rating": rate,
        "message": comment,
      };

      await dio.post('/user/$id', data: data);

      return false;
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

      await dio.post('/order/emergency', data: data);
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
        'userServices': user.userServices,
        'workLocationString': user.workLocationString,
        'officeLocationString': user.officeLocationString,
        'email': user.email,
        'phoneNumbers': user.phoneNumbers,
        'profileImg': user.profileImg ?? '',
      };
      await dio.patch('/user', data: data);

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

      final response = await dio.post('/time', data: data);

      if (response.data != null) {
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
      final response = await dio.get('/time/active/$t/$id/$type/$isActive');
      final time =
          (response.data as List).map((e) => Time.fromJson(e)).toList();
      return time;
    } on Exception {
      rethrow;
    }
  }

  Future<Order> setChannel(
    bool isLawyer,
    String orderId,
    String channelName,
  ) async {
    try {
      Agora token = await getAgoraToken(channelName, isLawyer ? 2 : 1);

      final response = await dio.post(
          '/order/token/$orderId/$channelName/${isLawyer.toString()}',
          data: {'token': token.rtcToken});

      return Order.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  Future<Order> getChannel(String id) async {
    try {
      final response = await dio.get(
        '/order/user/$id',
      );

      return Order.fromJson(response.data);
    } on Exception {
      rethrow;
    }
  }

  Future<List<Order>> orderList() async {
    try {
      final response = await dio.get('/order/user');
      final orders =
          (response.data as List).map((e) => Order.fromJson(e)).toList();
       
      return orders;
    } on Exception {
      rethrow;
    }
  }

  Future<Time> getTimeLawyer(String id) async {
    try {
      final response = await dio.get(
        '/time/lawyer/$id',
      );
      if (response.data == null) {
        return Time(sId: '');
      } else {
        return Time.fromJson(response.data);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<LocationDto> getLawyerLocation(String id) async {
    try {
      final response = await dio.get(
        '/user/lawyer/location/$id',
      );
      if (response.data == null) {
        return LocationDto(lat: 0.0, lng: 0.0);
      } else {
        return LocationDto.fromJson(response.data);
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
      await dio.patch('/user/location', data: data);

      return true;
    } on Exception {
      return false;
    }
  }

  Future<List<Time>> getTimeService(String service, String type) async {
    try {
      final response = await dio.get('/time/service/$service/$type');
      final times =
          (response.data as List).map((e) => Time.fromJson(e)).toList();
      return times;
    } on Exception {
      rethrow;
    }
  }
}
