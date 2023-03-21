import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/agora.config.dart' as config;
import '../../../shared/index.dart';

class AudioController extends GetxController {
  final showPerformanceOverlay = false.obs;
  final ApiRepository _apiRepository = Get.find();
  final channelName = "".obs;
  late RtcEngine engine;
  final channelId = "".obs;
  final channelToken = "".obs;
  final isJoined = false.obs,
      openMicrophone = true.obs,
      enableSpeakerphone = true.obs,
      playEffect = false.obs,
      enableInEarMonitoring = false.obs;
  final recordingVolume = 100.0.obs,
      playbackVolume = 100.0.obs,
      inEarMonitoringVolume = 100.0.obs;
  final channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting.obs;
  final channelController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    disposeChannel();
  }

  joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    print(channelToken.value);
    print(channelId.value);
    try {
      final status = await Permission.microphone.status;
      if (!status.isDenied) {
        await engine.joinChannel(
            token:
                "006a941d13a5641456b95014aa4fc703f70IADlLRiEQMbTlx4iBdA0eEdlhO+Y+6/b/KqZO+N6Y+t6n73zKVG379yDIgBysYQAvNkYZAQAAQBcpBdkAgBcpBdkAwBcpBdkBABcpBdk",
            channelId: 'asdf',
            uid: 1,
            options: ChannelMediaOptions(
              channelProfile: channelProfileType.value,
              clientRoleType: ClientRoleType.clientRoleBroadcaster,
            ));
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
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        isJoined.value = false;
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
  }

  leaveChannel() async {
    await engine.leaveChannel();
    isJoined.value = false;
    openMicrophone.value = true;
    enableInEarMonitoring.value = false;
    playEffect.value = false;
    enableSpeakerphone.value = true;
    recordingVolume.value = 100;
    playbackVolume.value = 100;
    inEarMonitoringVolume.value = 100;
    Get.to(() => PrimeView());
  }

  switchMicrophone() async {
    // await await _engine.muteLocalAudioStream(!openMicrophone);
    await engine.enableLocalAudio(!openMicrophone.value);
    openMicrophone.value = !openMicrophone.value;
  }

  switchSpeakerphone() async {
    await engine.setEnableSpeakerphone(!enableSpeakerphone.value);

    enableSpeakerphone.value = !enableSpeakerphone.value;
  }

  switchEffect() async {
    if (playEffect.value) {
      await engine.stopEffect(1);
      playEffect.value = false;
    } else {
      final path =
          (await engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3"))!;
      await engine.playEffect(
          soundId: 1,
          filePath: path,
          loopCount: 0,
          pitch: 1,
          pan: 1,
          gain: 100,
          publish: true);
      // .then((value) {

      playEffect.value = true;
    }
  }

  onChangeInEarMonitoringVolume(double value) async {
    inEarMonitoringVolume.value = value;
    await engine.setInEarMonitoringVolume(inEarMonitoringVolume.value.toInt());
  }

  toggleInEarMonitoring(value) async {
    try {
      await engine.enableInEarMonitoring(
          enabled: value,
          includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      enableInEarMonitoring.value = value;
    } catch (e) {
      // Do nothing
    }
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
