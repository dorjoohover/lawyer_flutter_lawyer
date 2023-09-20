import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/agora.config.dart' as config;
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
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
  bool isJoined = false;
  List<String> logs = [];
  bool isSwitchCamera = false;
  bool isMuted = false;
  bool isSpeaker = false;
  bool isCamera = true;
  double rating = 0;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  final controller = Get.put(HomeController());
  Timer? countdownTimer;
  late Order order;
  Duration myDuration = Duration(minutes: 6);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    if (countdownTimer != null) {
      setState(() => countdownTimer!.cancel());
    }
  }

  void setCountDown() async {
    if (myDuration.inSeconds == 300) {
      Get.snackbar('Анхааруулга', "5 мин үлдлээ", icon: Icon(Icons.warning));
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialogView(
      //           icon: Icons.expand_outlined,
      //           title: 'Таны уулзалт дуусахад 5 мин үлдлээ.',
      //           text: 'Та уулзалтаа сунгах уу?',
      //           approve: () {
      //             myDuration = Duration(minutes: 6);
      //             Navigator.pop(context);
      //           },
      //           color: warning);
      //     });
    }
    if (myDuration.inSeconds == 60) {
      Get.snackbar('Анхааруулга', "1 мин үлдлээ", icon: Icon(Icons.warning));
    }
    if (myDuration.inSeconds < 1) {
      Get.snackbar('Анхааруулга', "Цаг дууслаа");
      _onCallEnd(context);
      countdownTimer!.cancel();
    }
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0 && countdownTimer != null) {
        _onCallEnd(context);
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
      order = widget.order;
    });
    // setState(() {
    //   myDuration = Duration(seconds: widget.order.expiredTime! * 60);
    // });
    Future.delayed(Duration.zero, () async {
      // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)
      //     .then((value) => print(value));
    });

    initAgora();
  }

  @override
  void dispose() async {
    _onCallEnd(context);

    super.dispose();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    rtc = createAgoraRtcEngine();
    await rtc.initialize(RtcEngineContext(
      appId: config.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    rtc.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          logSink.log('[onError] err: $err, msg: $msg');
          logs.add('[onError] err: $err, msg: $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          logSink.log(
              '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
          logs.add(
              '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
          setState(() {
            isJoined = true;
          });
          if (_remoteUid == null) {
            controller.callOrder(order, widget.uid == 2 ? 'user' : 'lawyer');
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          logs.add(
              '[onUserJoined] connection: ${connection.toJson()} remoteUid: $remoteUid elapsed: $elapsed');

          setState(() {
            _remoteUid = remoteUid;
          });
          startTimer();
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          logSink.log(
              '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
          logs.add(
              '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

          stopTimer();
        },
      ),
    );

    await rtc.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await rtc.enableVideo();
    await rtc.startPreview().then((value) => logs.add('startPreview'));

    await rtc.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  Future<void> _onCallEnd(BuildContext context) async {
    try {
      await rtc.leaveChannel();
      if (controller.user?.userType == 'user') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialogView(
                  icon: Icons.expand_outlined,
                  title: 'Та хуульчид санал өгнө үү.',
                  text: '',
                  approveBtn: 'Илгээх',
                  cancelBtn: 'Болих',
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        rating = rating;
                      });
                    },
                  ),
                  approve: () {
                    controller.sendRate(
                        order.lawyerId!.sId!, rating == 0 ? 1 : rating);
                    Get.to(() => const HomeView());
                  },
                  cancel: () async {},
                  color: success);
            });
        Get.to(() => const HomeView());
      }
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
            Center(
              child: _remoteVideo(minutes, seconds),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: isJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: rtc,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo(String minutes, String seconds) {
    if (_remoteUid != null) {
      return Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController.remote(
                rtcEngine: rtc,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.channelName),
                useFlutterTexture: isCamera),
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
                  constraints: BoxConstraints(minWidth: 70),
                  onPressed: () async {
                    await rtc.enableLocalAudio(!isMuted);

                    setState(() {
                      isMuted = !isMuted;
                    });
                  },
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: isMuted ? primary : Colors.white,
                  padding: const EdgeInsets.all(origin),
                  child: SvgPicture.asset(
                    !isMuted ? svgMicrophone : svgMicrophoneDisable,
                    width: 14,
                  ),
                ),
                RawMaterialButton(
                  constraints: const BoxConstraints(minWidth: 70),
                  onPressed: () {
                    _onCallEnd(context);
                    setState(() {
                      if (countdownTimer != null) {
                        countdownTimer!.cancel();
                      }
                    });
                  },
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: error,
                  padding: const EdgeInsets.all(origin),
                  child:
                      const Icon(Icons.call_end, color: Colors.white, size: 35),
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
                    rtc.switchCamera();
                  },
                  child: Icon(
                    Icons.switch_camera,
                    color: !isSwitchCamera ? primary : Colors.white,
                    size: 20.0,
                  ),
                ),
                RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 70),
                  onPressed: () => {
                    setState(() {
                      isCamera = !isCamera;

                      if (!isCamera) {
                        rtc.disableVideo();
                      } else {
                        rtc.enableVideo();
                      }
                    })
                  },
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
          )
        ],
      );
    } else {
      // return ListView(
      //   children: [
      //     Text(widget.token),
      //     SizedBox(height: 300),
      //     Text(widget.channelName),
      //     Text(
      //       widget.uid.toString(),
      //     ),
      //     ...logs.map((e) => Text(e))
      //   ],
      // );
      return Center(
        child: Text(
          '${widget.uid == 2 ? 'Хэрэглэгч' : 'Хуульч'} орж иртэл түр хүлээнэ үү ',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
