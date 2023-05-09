import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

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
  late final AgoraClient client;
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
      await client.release();
    }
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
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
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)
          .then((value) => print(value));
    });
    startTimer();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: config.appId,
        channelName: widget.channelName,
        username: widget.name,
        tempToken: widget.token,
        uid: widget.uid,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
      await Permission.camera.request();
    }

    try {
      await client.initialize();
    } catch (e) {
      Get.snackbar('', '');
    }
  }

  Future<void> _onCallEnd(BuildContext context) async {
    setState(() {
      if (countdownTimer != null) {
        countdownTimer!.cancel();
      }
    });

    if (!widget.isLawyer) {
      Navigator.of(context).push(createRoute(PrimeView()));
    } else {
      Navigator.of(context).push(createRoute(LawyerView()));
    }

    try {
      await client.release();
    } catch (error) {
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
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.oneToOne,
            ),
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 150,
                left: 0,
                right: 0,
                child: Align(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: medium, vertical: small),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(origin),
                        color: Colors.white,
                      ),
                      child: Text(
                        '$minutes:$seconds',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                )),
            // AgoraVideoButtons(
            //   onDisconnect: () {
            //     setState(() {
            //       if (countdownTimer != null) {
            //         countdownTimer!.cancel();
            //       }
            //     });
            //     Navigator.pop(context);
            //   },
            //   addScreenSharing: false,
            //   client: client,
            //   // muteButtonChild: SvgPicture.asset(
            //   //   client.sessionController.value.isLocalUserMuted
            //   //       ? svgMicrophone
            //   //       : svgMicrophoneDisable,
            //   //   width: 14,
            //   // ),
            // ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 70),
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                      toggleMute(
                        sessionController: client.sessionController,
                      );
                    },
                    child: SvgPicture.asset(
                      !isMuted ? svgMicrophone : svgMicrophoneDisable,
                      width: 14,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: isMuted ? primary : Colors.white,
                    padding: const EdgeInsets.all(origin),
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 70),
                    onPressed: () {
                      setState(() {
                        isSpeaker = !isSpeaker;
                      });
                      toggleMute(
                        sessionController: client.sessionController,
                      );
                    },
                    child: SvgPicture.asset(
                      !isSpeaker ? svgVolume : svgVolumeDisable,
                      width: 20,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: isSpeaker ? primary : Colors.white,
                    padding: const EdgeInsets.all(origin),
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 70),
                    onPressed: () => _onCallEnd(context),
                    child: Icon(Icons.call_end, color: Colors.white, size: 35),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: error,
                    padding: const EdgeInsets.all(origin),
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 60),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: isSwitchCamera ? primary : Colors.white,
                    padding: const EdgeInsets.all(origin),
                    onPressed: () {
                      setState(() {
                        isSwitchCamera = !isSwitchCamera;
                      });
                      switchCamera(
                        sessionController: client.sessionController,
                      );
                    },
                    child: Icon(
                      Icons.switch_camera,
                      color: !isSwitchCamera ? primary : Colors.white,
                      size: 20.0,
                    ),
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 70),
                    onPressed: () => toggleCamera(
                      sessionController: client.sessionController,
                    ),
                    child: Icon(
                      !isCamera ? Icons.videocam_off : Icons.videocam,
                      color: !isCamera ? Colors.white : primary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: !isCamera ? primary : Colors.white,
                    padding: const EdgeInsets.all(origin),
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
