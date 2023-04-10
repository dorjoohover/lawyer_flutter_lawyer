import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/shared/constants/index.dart';
import 'package:get/get.dart';

class VideoView extends StatefulWidget {
  const VideoView(
      {Key? key,
      required this.token,
      required this.channelName,
      required this.name,
      required this.isLawyer,
      required this.uid})
      : super(key: key);
  final String token;
  final String channelName;
  final int uid;
  final String name;
  final bool isLawyer;
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final AgoraClient client;
  bool isSwitchCamera = false;
  bool isMuted = false;
  bool isCamera = true;
  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 6);
  Duration startDuration = Duration(seconds: 0);

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
      Navigator.pop(context);

      await client.release();
    }
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
        startDuration = Duration(seconds: 360 - seconds);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: config.appId,
          channelName: widget.channelName,
          tempToken: widget.token,
          uid: widget.uid),
    );
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  Future<void> _onCallEnd(BuildContext context) async {
    Navigator.pop(context);

    await client.release();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(startDuration.inMinutes.remainder(60));
    final seconds = strDigits(startDuration.inSeconds.remainder(60));

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
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                      toggleMute(
                        sessionController: client.sessionController,
                      );
                    },
                    child: Icon(
                      !isMuted ? Icons.mic_off : Icons.mic,
                      color: isMuted ? Colors.white : primary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: isMuted ? primary : Colors.white,
                    padding: const EdgeInsets.all(origin),
                  ),
                  RawMaterialButton(
                    onPressed: () => _onCallEnd(context),
                    child: Icon(Icons.call_end, color: Colors.white, size: 35),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: error,
                    padding: const EdgeInsets.all(origin),
                  ),
                  RawMaterialButton(
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
                    onPressed: () => toggleCamera(
                      sessionController: client.sessionController,
                    ),
                    child: Icon(
                      !isCamera ? Icons.videocam_off : Icons.videocam,
                      color: isCamera ? Colors.white : primary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: isCamera ? primary : Colors.white,
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
