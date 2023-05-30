import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/providers/api_repository.dart';
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
  String channelId = config.channelId;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100,
      _playbackVolume = 100,
      _inEarMonitoringVolume = 100;
  late TextEditingController _controller;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 6);
  late Order order;
  // Duration startDuration = Duration(seconds: 0);
  final _apiRepository = Get.find<ApiRepository>();
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
    if (myDuration.inSeconds < 1) {
      Get.snackbar('Анхааруулга', "Цаг дууслаа");
      await _leaveChannel();
    }
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);

        // startDuration = Duration(seconds: 360 - seconds);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.isLawyer);
    setState(() {
      myDuration = Duration(seconds: widget.order.expiredTime! * 60);
    });
    Future.delayed(Duration.zero, () async {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    });
    startTimer();
    _controller = TextEditingController(text: channelId);
    _initEngine();
  }

  void onEnd() {
    print('onEnd');
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    countdownTimer!.cancel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: config.appId,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
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
    print('asdf');
    print(widget.token);
    print(widget.channelName);
    print(widget.uid);
    await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid == 0 ? 1 : widget.uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() => countdownTimer!.cancel());
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
    });
    Navigator.of(context).push(
        createRoute(widget.isLawyer ? const LawyerView() : const PrimeView()));
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

  _switchEffect() async {
    if (playEffect) {
      await _engine.stopEffect(1);
      setState(() {
        playEffect = false;
      });
    } else {
      final path =
          (await _engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3"))!;
      await _engine.playEffect(
          soundId: 1,
          filePath: path,
          loopCount: 0,
          pitch: 1,
          pan: 1,
          gain: 100,
          publish: true);
      // .then((value) {
      setState(() {
        playEffect = true;
      });
    }
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    try {
      await _engine.enableInEarMonitoring(
          enabled: value,
          includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      _enableInEarMonitoring = value;
      setState(() {});
    } catch (e) {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelProfileType = [
      ChannelProfileType.channelProfileLiveBroadcasting,
      ChannelProfileType.channelProfileCommunication,
    ];
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final items = channelProfileType
        .map((e) => DropdownMenuItem(
              child: Text(
                e.toString().split('.')[1],
              ),
              value: e,
            ))
        .toList();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: huge),
        height: MediaQuery.of(context).size.height,
        child: Column(
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
                        onTap: isJoined ? _switchSpeakerphone : null,
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: !enableSpeakerphone ? primary : lightGray,
                              borderRadius: BorderRadius.circular(100)),
                          child: SvgPicture.asset(
                            enableSpeakerphone ? svgVolume : svgVolumeDisable,
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
        ),
      ),
    );
  }
}


// Column(
//               children: [
                

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     const Text('RecordingVolume:'),
//                     Slider(
//                       value: _recordingVolume,
//                       min: 0,
//                       max: 400,
//                       divisions: 5,
//                       label: 'RecordingVolume',
//                       onChanged: isJoined
//                           ? (double value) async {
//                               setState(() {
//                                 _recordingVolume = value;
//                               });
//                               await _engine
//                                   .adjustRecordingSignalVolume(value.toInt());
//                             }
//                           : null,
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     const Text('PlaybackVolume:'),
//                     Slider(
//                       value: _playbackVolume,
//                       min: 0,
//                       max: 400,
//                       divisions: 5,
//                       label: 'PlaybackVolume',
//                       onChanged: isJoined
//                           ? (double value) async {
//                               setState(() {
//                                 _playbackVolume = value;
//                               });
//                               await _engine
//                                   .adjustPlaybackSignalVolume(value.toInt());
//                             }
//                           : null,
//                     )
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(mainAxisSize: MainAxisSize.min, children: [
//                       const Text('InEar Monitoring Volume:'),
//                       Switch(
//                         value: _enableInEarMonitoring,
//                         onChanged: isJoined ? _toggleInEarMonitoring : null,
//                         activeTrackColor: Colors.grey[350],
//                         activeColor: Colors.white,
//                       )
//                     ]),
//                     if (_enableInEarMonitoring)
//                       SizedBox(
//                           width: 300,
//                           child: Slider(
//                             value: _inEarMonitoringVolume,
//                             min: 0,
//                             max: 100,
//                             divisions: 5,
//                             label:
//                                 'InEar Monitoring Volume $_inEarMonitoringVolume',
//                             onChanged: isJoined
//                                 ? _onChangeInEarMonitoringVolume
//                                 : null,
//                           ))
//                   ],
//                 ),
//               ],
//             ),