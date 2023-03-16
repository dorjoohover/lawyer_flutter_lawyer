import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/agora.config.dart' as config;
import '../../../shared/index.dart';

class AudioController extends GetxController {
  final showPerformanceOverlay = false.obs;

  late RtcEngine engine;
  final channelId = config.channelId.obs;
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
    channelController.text = channelId.value;
    initEngine();
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

    await engine.joinChannel(
        token:
            '006a941d13a5641456b95014aa4fc703f70IAAe7ayASteEEd4q2fy05l/3TwYMBceTfSS9jP12HjyAsb3zKVG379yDIgCFxHEEca8UZAQAAQARehNkAgARehNkAwARehNkBAARehNk',
        channelId: channelController.text,
        uid: 1,
        options: ChannelMediaOptions(
          channelProfile: channelProfileType.value,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
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
    print('asdf');
    await engine.leaveChannel();
    isJoined.value = false;
    openMicrophone.value = true;
    enableInEarMonitoring.value = false;
    playEffect.value = false;
    enableSpeakerphone.value = true;
    recordingVolume.value = 100;
    playbackVolume.value = 100;
    inEarMonitoringVolume.value = 100;
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
