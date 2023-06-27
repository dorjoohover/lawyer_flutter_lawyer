import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../modules.dart';

class HomeController extends GetxController
    with StateMixin<User>, WidgetsBindingObserver {
  final ApiRepository _apiRepository = Get.find();
  final authController = Get.put(AuthController(apiRepository: Get.find()));

  final showPerformanceOverlay = false.obs;
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final rxUser = Rxn<User?>();
  final currentUserType = 'user'.obs;
  final our = false.obs;
  final loading = false.obs;
  final emergencyOrder = Rxn<Order?>();
  late IO.Socket socket;
  User? get user => rxUser.value;
  set user(value) => rxUser.value = value;

  Future<void> setupApp() async {
    isLoading.value = true;
    try {
      user = await _apiRepository.getUser();
      change(user, status: RxStatus.success());
      if (user?.userType == 'lawyer') {
        currentUserType.value = 'lawyer';
      }
      if (user?.userType == 'our') {
        currentUserType.value = 'our';
      }
      if (user != null) {
        socket = IO.io(
            "https://lawyernestjs-production.up.railway.app", <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket'],
        });
        socket.connect();
        socket.onConnect(
          (data) => {
            if (user?.userType == 'our') {our.value = true},
          },
        );

        socket.onDisconnect((_) => {
              if (user?.userType == 'our') {our.value = false}
            });
        socket.onConnectError((data) => {
              if (user?.userType == 'our') {our.value = false}
            });
        socket.onError((error) => {
              if (user?.userType == 'our') {our.value = false}
            });
        socket.on(('response_emergency_order'), ((data) {
          Order order = Order.fromJson(
              jsonDecode(jsonEncode(data)) as Map<String, dynamic>);

          if (our.value || order.lawyerId?.sId == user?.sId) {
            emergencyOrder.value = order;
            callkit(order);
          }

          if (order.clientId?.sId == user?.sId) {
            getChannelToken(order, false, '');
          }
        }));
        socket.on(
            ('onlineEmergency'),
            ((data) => {
                  if ((data as List).contains(socket.id) == true)
                    {print(socket.id)}
                }));
      }
    } on DioError catch (e) {
      Get.find<SharedPreferences>().remove(StorageKeys.token.name);
      update();
    }
  }

  callOrder(Order order, String userType) {
    if (order.date != null &&
        order.date! > DateTime.now().millisecondsSinceEpoch - 30 * 60000 &&
        order.date! < DateTime.now().millisecondsSinceEpoch + 30 * 60000) {
      // if (order.lawyerId?.sId == user?.sId && userType == user?.userType) {
      //   callkit(order);
      // }
      // if (order.clientId?.sId == user?.sId && userType == user?.userType) {
      //   callkit(order);
      // }
    }
  }

  sendRate(String id, double rate) async {
    await _apiRepository.sendRating(id, rate, '');
  }

  getChannelToken(Order order, bool isLawyer, String? profileImg) async {
    try {
      loading.value = true;

      Order getOrder = await _apiRepository.getChannel(order.sId!);

      String channelName = getOrder.channelName!;
      if (channelName == 'string') {
        channelName = DateTime.now().millisecondsSinceEpoch.toString();
      }

      if (getOrder.lawyerToken == null ||
          getOrder.userToken == null ||
          getOrder.lawyerToken == 'string' ||
          getOrder.userToken == 'string') {
        getOrder = await _apiRepository.setChannel(
          user?.userType != 'user',
          order.sId!,
          channelName,
        );
      }

      if (getOrder.serviceType == 'onlineEmergency') {
        Get.to(
          () => AudioView(
              order: getOrder,
              isLawyer: user?.userType != 'user',
              channelName: getOrder.channelName!,
              token: user?.userType != 'user'
                  ? getOrder.lawyerToken ?? ''
                  : getOrder.userToken ?? '',
              name: user?.userType != 'user'
                  ? getOrder.clientId!.lastName!
                  : getOrder.lawyerId == null
                      ? 'Lawmax'
                      : getOrder.lawyerId!.lastName!,
              uid: user?.userType != 'user' ? 2 : 1),
        );
      }
      if (getOrder.serviceType == 'online') {
        Get.to(
          () => VideoView(
              order: getOrder,
              isLawyer: user?.userType != 'user',
              channelName: getOrder.channelName!,
              token: user?.userType != 'user'
                  ? getOrder.lawyerToken ?? ''
                  : getOrder.userToken ?? '',
              name: user?.userType != 'user'
                  ? getOrder.clientId!.lastName!
                  : getOrder.lawyerId!.lastName!,
              uid: user?.userType != 'user' ? 2 : 1),
        );
      }

      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      print(e.response);
      Get.snackbar(
        'Error',
        'Something went wrong',
      );
    }
  }

  callkit(Order order) async {
    CallKitParams params = CallKitParams(
      id: order.sId,
      nameCaller: order.clientId?.firstName,
      appName: "Lawmax",
      avatar: "https://i.pravata.cc/100",
      handle: order.clientId?.lastName,
      type: 0,
      textAccept: "Дуудлага авах",
      textDecline: "Дуудлага цуцлах",
      duration: 30000,
      extra: {'userId': order.clientId?.sId},
      ios: const IOSParams(
          iconName: "Lawmax",
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          ringtonePath: 'system_ringtone_default'),
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: "#0955fa",
          backgroundUrl: "https://i.pravata.cc/500",
          actionColor: "#4CAF50",
          incomingCallNotificationChannelName: "Дуудлага ирж байна",
          missedCallNotificationChannelName: "Аваагүй дуудлага"),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      switch (event!.event) {
        case Event.actionCallIncoming:
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          await getChannelToken(
              order, user?.userType != 'user', user?.profileImg ?? '');

          break;
        case Event.actionCallDecline:
          // TODO: declined an incoming call
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          // TODO: missed an incoming call
          break;

        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: Handle this case.
          break;
        case Event.actionCallCallback:
          // TODO: Handle this case.
          break;
        case Event.actionCallToggleHold:
          // TODO: Handle this case.
          break;
        case Event.actionCallToggleMute:
          // TODO: Handle this case.
          break;
        case Event.actionCallToggleDmtf:
          // TODO: Handle this case.
          break;
        case Event.actionCallToggleGroup:
          // TODO: Handle this case.
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: Handle this case.
          break;
        case Event.actionCallCustom:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Future<bool> createEmergencyOrder(
    String lawyerId,
    int expiredTime,
    int price,
    String serviceType,
    String reason,
    LocationDto location,
  ) async {
    Map data = {
      "userId": user!.sId,
      "date": DateTime.now().millisecondsSinceEpoch,
      "reason": reason,
      "lawyerId": lawyerId,
      "location": location,
      "expiredTime": expiredTime,
      "serviceType": serviceType,
      "serviceStatus": "pending",
      "channelName": DateTime.now().millisecondsSinceEpoch,
      "channelToken": "string",
      "price": price,
      "lawyerToken": "string",
      "userToken": "string",
    };
    socket.emit('create_emergency_order', data);
    return true;
  }

  // changeOrderStatus(String id, String status) {
  //   Map data = {"id": id, "status": status};
  //   socket.emit('change_order_status', data);
  // }

  @override
  void onInit() async {
    await setupApp();
    super.onInit();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
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
