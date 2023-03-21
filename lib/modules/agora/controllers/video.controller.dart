import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/agora.config.dart' as config;
import '../../../shared/index.dart';

class VideoController extends GetxController {
  final showPerformanceOverlay = false.obs;
  // final ApiRepository _apiRepository = Get.find();
  late RtcEngine engine;
  final remoteUid = <int>[].obs;

  final channelId = "".obs;
  final channelToken = "".obs;
  final isJoined = false.obs,
      switchCamera = true.obs,
      switchRender = true.obs,
      isUseFlutterTexture = false.obs,
      isUseAndroidSurfaceView = false.obs;

  final recordingVolume = 100.0.obs,
      playbackVolume = 100.0.obs,
      inEarMonitoringVolume = 100.0.obs;
  final channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting.obs;
  final channelController = TextEditingController();
  @override
  void onInit() {
    initEngine();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    disposeChannel();
  }

  joinChannel() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final cStatus = await Permission.camera.status;
        final mStatus = await Permission.microphone.status;
        if (!cStatus.isDenied && !mStatus.isDenied) {
          await engine.joinChannel(
            token:
                "006a941d13a5641456b95014aa4fc703f70IADlLRiEQMbTlx4iBdA0eEdlhO+Y+6/b/KqZO+N6Y+t6n73zKVG379yDIgBysYQAvNkYZAQAAQBcpBdkAgBcpBdkAwBcpBdkBABcpBdk",
            channelId: "asdf",
            uid: 1,
            options: ChannelMediaOptions(
              channelProfile: channelProfileType.value,
              clientRoleType: ClientRoleType.clientRoleBroadcaster,
            ),
          );
        }
      }
    } on DioError catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  Future<void> disposeChannel() async {
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> initEngine() async {
    engine = createAgoraRtcEngine();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.camera.request();
    }
    await engine.initialize(RtcEngineContext(
      appId: config.appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        isJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logSink.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');

        remoteUid.add(rUid);
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logSink.log(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

        remoteUid.removeWhere((element) => element == rUid);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

        isJoined.value = false;
        remoteUid.clear();
      },
    ));

    await engine.enableVideo();

    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
  }

  leaveChannel() async {
    await engine.leaveChannel();
    Get.to(() => PrimeView());
  }

  switchCameras() async {
    await engine.switchCamera();

    switchCamera.value = !switchCamera.value;
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
