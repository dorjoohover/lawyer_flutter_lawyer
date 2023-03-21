import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/modules/agora/controllers/controllers.dart';
import 'package:get/get.dart';

import '../../../shared/index.dart';

class VideoView extends StatelessWidget {
  VideoView({super.key});

  final controller = Get.put(VideoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExampleActionsWidget(
        displayContentBuilder: (context, isLayoutHorizontal) {
          return Stack(
            children: [
              AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: controller.engine,
                  canvas: const VideoCanvas(uid: 0),
                  useFlutterTexture: controller.isUseFlutterTexture.value,
                  useAndroidSurfaceView:
                      controller.isUseAndroidSurfaceView.value,
                ),
                onAgoraVideoViewCreated: (viewId) {
                  controller.engine.startPreview();
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.of(controller.remoteUid.map(
                      (e) => SizedBox(
                        width: 120,
                        height: 120,
                        child: AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: controller.engine,
                            canvas: VideoCanvas(uid: e),
                            connection: RtcConnection(
                                channelId: controller.channelController.text),
                            useFlutterTexture:
                                controller.isUseFlutterTexture.value,
                            useAndroidSurfaceView:
                                controller.isUseAndroidSurfaceView.value,
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
              )
            ],
          );
        },
        actionsBuilder: (context, isLayoutHorizontal) {
          final channelProfileType = [
            ChannelProfileType.channelProfileLiveBroadcasting,
            ChannelProfileType.channelProfileCommunication,
          ];
          final items = channelProfileType
              .map((e) => DropdownMenuItem(
                    child: Text(
                      e.toString().split('.')[1],
                    ),
                    value: e,
                  ))
              .toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS))
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Flutter texture: '),
                            Obx(() => Switch(
                                  value: controller.isUseFlutterTexture.value,
                                  onChanged: controller.isJoined.value
                                      ? null
                                      : (changed) {
                                          controller.isUseFlutterTexture.value =
                                              changed;
                                        },
                                ))
                          ]),
                    if (defaultTargetPlatform == TargetPlatform.android)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Android SurfaceView: '),
                            Obx(
                              () => Switch(
                                value: controller.isUseAndroidSurfaceView.value,
                                onChanged: controller.isJoined.value
                                    ? null
                                    : (changed) {
                                        controller.isUseAndroidSurfaceView
                                            .value = changed;
                                      },
                              ),
                            )
                          ]),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              const Text('Channel Profile: '),
              Obx(
                () => DropdownButton<ChannelProfileType>(
                  items: items,
                  value: controller.channelProfileType.value,
                  onChanged: controller.isJoined.value
                      ? null
                      : (v) {
                          controller.channelProfileType.value = v!;
                        },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.isJoined.value
                                ? controller.leaveChannel()
                                : controller.joinChannel();
                          },
                          child: Obx(
                            () => Text(
                                '${controller.isJoined.value ? 'Leave' : 'Join'} channel'),
                          )))
                ],
              ),
              if (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS) ...[
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => controller.switchCameras(),
                  child: Text(
                      'Camera ${controller.switchCamera.value ? 'front' : 'rear'}'),
                ),
              ],
            ],
          );
        },
      ),
    );
    // if (!_isInit) return Container();
  }
}
