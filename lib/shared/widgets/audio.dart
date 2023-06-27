import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// AudioView Example
class AudioView extends StatefulWidget {
  /// Construct the [AudioView]
  const AudioView(
      {Key? key,
      required this.token,
      required this.channelName,
      required this.name,
      required this.isLawyer,
      required this.order,
      required this.uid})
      : super(key: key);
  final String token;
  final String channelName;
  final int uid;
  final String name;
  final bool isLawyer;
  final Order order;
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AudioView> {
  late final RtcEngine _engine;
  int? _remoteUid;
  List<String> logs = [];
  String channelId = config.channelId;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;

  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 6);
  late Order order;

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() async {
    if (myDuration.inSeconds == 300) {
      Get.snackbar('Анхааруулга', "5 мин үлдлээ", icon: Icon(Icons.warning));
    }
    if (myDuration.inSeconds == 60) {
      Get.snackbar('Анхааруулга', "1 мин үлдлээ", icon: Icon(Icons.warning));
    }
    if (myDuration.inSeconds < 1) {
      Get.snackbar('Анхааруулга', "Цаг дууслаа");
      await _leaveChannel();
    }
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      myDuration = Duration(seconds: widget.order.expiredTime! * 60);
    });
    Future.delayed(Duration.zero, () async {
      // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    });
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
    Get.to(() => const HomeView(),
        curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: config.appId,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
        logs.add('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        logs.add(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        print("remote user $remoteUid joined");
        logs.add(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $remoteUid elapsed: $elapsed');

        setState(() {
          _remoteUid = remoteUid;
        });
        startTimer();
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        logs.add(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

        stopTimer();
      },
    ));

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    await _joinChannel();
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid == 0 ? 1 : widget.uid,
        options: ChannelMediaOptions(
            channelProfile: _channelProfileType,
            clientRoleType: ClientRoleType.clientRoleBroadcaster));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
    setState(() {
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
    });
    Get.to(() => const HomeView(),
        curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
  }

  _switchMicrophone() async {
    // await await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  _switchSpeakerphone() async {
    await _engine.setEnableSpeakerphone(!enableSpeakerphone);
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(vertical: huge),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      width: double.infinity,
      child: _remoteUid != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                space4,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 122,
                        height: 122,
                        decoration: BoxDecoration(
                            color: const Color(0xffc4c4c4),
                            borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          svgUser,
                          width: 57,
                          height: 54,
                        )),
                    space16,
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 69),
                  child: Column(
                    children: [
                      Text(
                        '$minutes:$seconds',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _switchMicrophone,
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: !openMicrophone ? primary : lightGray,
                                  borderRadius: BorderRadius.circular(100)),
                              child: SvgPicture.asset(
                                openMicrophone
                                    ? svgMicrophone
                                    : svgMicrophoneDisable,
                                width: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 36,
                          ),
                          GestureDetector(
                            onTap: _leaveChannel,
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: error,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 36,
                          ),
                          GestureDetector(
                            onTap: _switchSpeakerphone,
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:
                                      !enableSpeakerphone ? primary : lightGray,
                                  borderRadius: BorderRadius.circular(100)),
                              child: SvgPicture.asset(
                                enableSpeakerphone
                                    ? svgVolume
                                    : svgVolumeDisable,
                                width: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                '${widget.uid == 2 ? 'Хэрэглэгч' : 'Хуульч'} орж иртэл түр хүлээнэ үү ',
                textAlign: TextAlign.center,
              ),
            ),
    ));
  }
}
