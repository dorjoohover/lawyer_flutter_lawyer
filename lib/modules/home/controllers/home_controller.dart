import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/settings/views/settings_view.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/constants/enums.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  late IO.Socket socket;
  User? get user => rxUser.value;
  set user(value) => rxUser.value = value;

  Widget getView(int index) {
    switch (index) {
      case 0:
        return currentUserType.value == 'lawyer' ||
                currentUserType.value == 'our'
            ? const LawyerView()
            : const PrimeView();

      case 1:
        return currentUserType.value == 'lawyer' ||
                currentUserType.value == 'our'
            ? const SizedBox()
            : const EmergencyHomeView();
      case 2:
        return const SizedBox();
      case 3:
        return currentUserType.value == 'lawyer' ||
                currentUserType.value == 'our'
            ? const SettingsView()
            : const SizedBox();
      case 4:
        return currentUserType.value == 'lawyer' ||
                currentUserType.value == 'our'
            ? const SizedBox()
            : const SettingsView();
      default:
        return const Center(child: Text('Something went wrong'));
    }
  }

  changeNavIndex(int index) {
    currentIndex.value = index;
    getView(index);
    update();
  }

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
            if (user?.userType == 'our') {our.value = true}
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
        socket.on(
            ('response_emergency_order'),
            ((data) => {
                  if (our.value) {callkit()}
                }));
        socket.on(
            ('onlineEmergency'),
            ((data) => {
                  if ((data as List).contains(socket.id) == true)
                    {print(socket.id)}
                }));
      }
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      Get.find<SharedPreferences>().remove(StorageKeys.token.name);
      update();
    }
  }

  callkit() async {
    CallKitParams params = CallKitParams(
      id: "21232dgfgbcbgb",
      nameCaller: "Coding Is Life",
      appName: "Demo",
      avatar: "https://i.pravata.cc/100",
      handle: "123456",
      type: 0,
      textAccept: "Accept",
      textDecline: "Decline",
      duration: 30000,
      extra: {'userId': "sdhsjjfhuwhf"},
      ios: IOSParams(
          iconName: "Call Demo",
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
      android: AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: "#0955fa",
          backgroundUrl: "https://i.pravata.cc/500",
          actionColor: "#4CAF50",
          incomingCallNotificationChannelName: "Incoming call",
          missedCallNotificationChannelName: "Missed call"),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      switch (event!.event) {
        case Event.actionCallIncoming:
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          print('asdf');
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

  createEmergencyOrder(
    String lawyerId,
    int expiredTime,
    int price,
    String serviceType,
    String reason,
    LocationDto location,
  ) {
    Map data = {
      "userId": user!.sId,
      "date": DateTime.now().millisecondsSinceEpoch,
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
    };
    socket.emit('create_emergency_order', data);
  }

  changeOrderStatus(String id, String status) {
    Map data = {"id": id, "status": status};
    socket.emit('change_order_status', data);
  }

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
