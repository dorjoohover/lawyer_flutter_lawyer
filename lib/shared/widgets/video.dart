import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/data/data.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoView extends StatefulWidget {
  const VideoView(
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
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late RtcEngine rtc;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool isSwitchCamera = false;
  bool isMuted = false;
  bool isSpeaker = false;
  bool isCamera = true;
  Timer? countdownTimer;
  late Order order;
  Duration myDuration = Duration(minutes: 6);
  final _apiRepository = Get.find<ApiRepository>();
  // Duration startDuration = Duration(seconds: 0);

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
      Navigator.of(context).pop();
    }
    final reduceSecondsBy = 1;
    // setState(() {
    //   final seconds = myDuration.inSeconds - reduceSecondsBy;
    //   if (seconds < 0) {
    //     countdownTimer!.cancel();
    //   } else {
    //     myDuration = Duration(seconds: seconds);
    //   }
    // });
    // if (order.lawyerToken == 'string' &&
    //     order.userToken == 'string' &&
    //     myDuration.inSeconds % 5 == 0) {
    //   Order getOrder = await _apiRepository.getChannel(order.sId!);
    //   setState(() {
    //     if (order.lawyerToken != 'string' && order.userToken != 'string') {
    //       order = getOrder;
    //       myDuration = Duration(seconds: getOrder.expiredTime! * 60);
    //     }
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      order = widget.order;
    });
    Future.delayed(Duration.zero, () async {
      // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)
      //     .then((value) => print(value));
    });
    // startTimer();

    initAgora();
  }

  @override
  void dispose() {
    rtc.leaveChannel();
    setState(() {
      _localUserJoined = false;
    });
    super.dispose();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    rtc = createAgoraRtcEngine();
    await rtc.initialize(RtcEngineContext(
      appId: config.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    print('asdf');
    rtc.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          print("local user ${connection.toJson()} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          print("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          print('asdfg');
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await rtc.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await rtc.enableVideo();
    await rtc.startPreview();

    await rtc.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: widget.uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _onCallEnd(BuildContext context) async {
    setState(() {
      if (countdownTimer != null) {
        countdownTimer!.cancel();
      }
    });

    Navigator.of(context).pop();

    try {} catch (error) {
      Get.snackbar(error.toString(), 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: rtc,
                            canvas: VideoCanvas(uid: widget.uid),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            // AgoraVideoViewer(
            //   client: client,
            //   layoutType: Layout.oneToOne,
            // ),
            // Positioned(
            //     bottom: MediaQuery.of(context).padding.bottom + 150,
            //     left: 0,
            //     right: 0,
            //     child: Align(
            //       child: FittedBox(
            //         fit: BoxFit.contain,
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: medium, vertical: small),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(origin),
            //             color: Colors.white,
            //           ),
            //           child: Text(
            //             '$minutes:$seconds',
            //             style: Theme.of(context).textTheme.displayMedium,
            //           ),
            //         ),
            //       ),
            //     )),

            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: MediaQuery.of(context).padding.bottom + 50,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       RawMaterialButton(
            //         constraints: BoxConstraints(minWidth: 70),
            //         onPressed: () {
            //           setState(() {
            //             isMuted = !isMuted;
            //           });
            //           toggleMute(
            //             sessionController: client.sessionController,
            //           );
            //         },
            //         child: SvgPicture.asset(
            //           !isMuted ? svgMicrophone : svgMicrophoneDisable,
            //           width: 14,
            //         ),
            //         shape: CircleBorder(),
            //         elevation: 2.0,
            //         fillColor: isMuted ? primary : Colors.white,
            //         padding: const EdgeInsets.all(origin),
            //       ),
            //       RawMaterialButton(
            //         constraints: BoxConstraints(minWidth: 70),
            //         onPressed: () {
            //           setState(() {
            //             isSpeaker = !isSpeaker;
            //           });
            //           toggleMute(
            //             sessionController: client.sessionController,
            //           );
            //         },
            //         child: SvgPicture.asset(
            //           !isSpeaker ? svgVolume : svgVolumeDisable,
            //           width: 20,
            //         ),
            //         shape: CircleBorder(),
            //         elevation: 2.0,
            //         fillColor: isSpeaker ? primary : Colors.white,
            //         padding: const EdgeInsets.all(origin),
            //       ),
            //       RawMaterialButton(
            //         constraints: BoxConstraints(minWidth: 70),
            //         onPressed: () => _onCallEnd(context),
            //         child: Icon(Icons.call_end, color: Colors.white, size: 35),
            //         shape: CircleBorder(),
            //         elevation: 2.0,
            //         fillColor: error,
            //         padding: const EdgeInsets.all(origin),
            //       ),
            //       RawMaterialButton(
            //         constraints: BoxConstraints(minWidth: 60),
            //         shape: CircleBorder(),
            //         elevation: 2.0,
            //         fillColor: isSwitchCamera ? primary : Colors.white,
            //         padding: const EdgeInsets.all(origin),
            //         onPressed: () {
            //           setState(() {
            //             isSwitchCamera = !isSwitchCamera;
            //           });
            //           switchCamera(
            //             sessionController: client.sessionController,
            //           );
            //         },
            //         child: Icon(
            //           Icons.switch_camera,
            //           color: !isSwitchCamera ? primary : Colors.white,
            //           size: 20.0,
            //         ),
            //       ),
            //       RawMaterialButton(
            //         constraints: BoxConstraints(minWidth: 70),
            //         onPressed: () => toggleCamera(
            //           sessionController: client.sessionController,
            //         ),
            //         child: Icon(
            //           !isCamera ? Icons.videocam_off : Icons.videocam,
            //           color: !isCamera ? Colors.white : primary,
            //           size: 20.0,
            //         ),
            //         shape: CircleBorder(),
            //         elevation: 2.0,
            //         fillColor: !isCamera ? primary : Colors.white,
            //         padding: const EdgeInsets.all(origin),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: rtc,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
