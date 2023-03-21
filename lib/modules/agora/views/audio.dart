import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/modules/agora/controllers/controllers.dart';
import 'package:get/get.dart';

class AudioView extends StatelessWidget {
  AudioView({super.key});

  final controller = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: controller.channelController,
                  decoration: const InputDecoration(hintText: 'Channel ID'),
                ),
                const Text('Channel Profile: '),
                Obx(
                  () => DropdownButton<ChannelProfileType>(
                      items: items,
                      value: controller.channelProfileType.value,
                      onChanged: controller.isJoined.value
                          ? null
                          : (v) async {
                              controller.channelProfileType.value = v!;
                            }),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () => {
                                controller.isJoined.value
                                    ? controller.leaveChannel()
                                    : controller.joinChannel(),
                              },
                          child: Obx(
                            () => Text(
                                '${controller.isJoined.value ? 'Leave' : 'Join'} channel'),
                          )),
                    )
                  ],
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.switchMicrophone(),
                        child: Obx(() => Text(
                            'Microphone ${controller.openMicrophone.value ? 'on' : 'off'}')),
                      ),
                      ElevatedButton(
                          onPressed: () => controller.isJoined.value
                              ? controller.switchSpeakerphone()
                              : null,
                          child: Obx(
                            () => Text(controller.enableSpeakerphone.value
                                ? 'Speakerphone'
                                : 'Earpiece'),
                          )),
                      if (!kIsWeb)
                        ElevatedButton(
                            onPressed: () => controller.isJoined.value
                                ? controller.switchEffect()
                                : null,
                            child: Obx(
                              () => Text(
                                  '${controller.playEffect.value ? 'Stop' : 'Play'} effect'),
                            )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('RecordingVolume:'),
                          Obx(() => Slider(
                                value: controller.recordingVolume.value,
                                min: 0,
                                max: 400,
                                divisions: 5,
                                label: 'RecordingVolume',
                                onChanged: controller.isJoined.value
                                    ? (double value) async {
                                        controller.recordingVolume.value =
                                            value;

                                        await controller.engine
                                            .adjustRecordingSignalVolume(
                                                value.toInt());
                                      }
                                    : null,
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('PlaybackVolume:'),
                          Obx(() => Slider(
                                value: controller.playbackVolume.value,
                                min: 0,
                                max: 400,
                                divisions: 5,
                                label: 'PlaybackVolume',
                                onChanged: controller.isJoined.value
                                    ? (double value) async {
                                        controller.playbackVolume.value = value;

                                        await controller.engine
                                            .adjustPlaybackSignalVolume(
                                                value.toInt());
                                      }
                                    : null,
                              ))
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Text('InEar Monitoring Volume:'),
                            Switch(
                              value: controller.enableInEarMonitoring.value,
                              onChanged: (value) => () =>
                                  controller.isJoined.value
                                      ? controller.toggleInEarMonitoring(value)
                                      : null,
                              activeTrackColor: Colors.grey[350],
                              activeColor: Colors.white,
                            )
                          ]),
                          if (controller.enableInEarMonitoring.value)
                            SizedBox(
                                width: 300,
                                child: Obx(() => Slider(
                                      value: controller
                                          .inEarMonitoringVolume.value,
                                      min: 0,
                                      max: 100,
                                      divisions: 5,
                                      label:
                                          'InEar Monitoring Volume ${controller.inEarMonitoringVolume.value}',
                                      onChanged: (value) => controller
                                              .isJoined.value
                                          ? controller
                                              .onChangeInEarMonitoringVolume(
                                                  controller
                                                      .inEarMonitoringVolume
                                                      .value)
                                          : null,
                                    )))
                        ],
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                ))
          ],
        ),
      ),
    );
  }
}
