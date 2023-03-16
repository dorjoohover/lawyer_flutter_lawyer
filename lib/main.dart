import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './pages/agora/index.dart';
import 'components/log_sink.dart';
import 'config/agora.config.dart' as config;

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showPerformanceOverlay = false;
  final _data = [...basic];
  bool _isConfigInvalid() {
    return config.appId == '410ec46f03af434c8be03a8471e1ba03' ||
        config.token ==
            '007eJxTYLDa9sTM7df0eyz/9tibrl65q1PRySr9a7n95k0eHPsmrPylwGBiaJCabGKWZmCcmGZibJJskZQKZFqYmBumGiYlGhgHLxZKaQhkZGi7y8PIyACBID4LQ0lqcQkDAwCc0CAO' ||
        config.channelId == 'test';
  }

  @override
  void initState() {
    super.initState();
    _requestPermissionIfNeed();
  }

  Future<void> _requestPermissionIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: _showPerformanceOverlay,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APIExample'),
          actions: [
            ToggleButtons(
              color: Colors.grey[300],
              selectedColor: Colors.white,
              renderBorder: false,
              children: const [
                Icon(
                  Icons.data_thresholding_outlined,
                )
              ],
              isSelected: [_showPerformanceOverlay],
              onPressed: (index) {
                setState(() {
                  _showPerformanceOverlay = !_showPerformanceOverlay;
                });
              },
            )
          ],
        ),
        body: !_isConfigInvalid()
            ? const InvalidConfigWidget()
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return _data[index]['widget'] == null
                      ? Ink(
                          color: Colors.grey,
                          child: ListTile(
                            title: Text(_data[index]['name'] as String,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white)),
                          ),
                        )
                      : ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            title: Text(
                                                _data[index]['name'] as String),
                                            // ignore: prefer_const_literals_to_create_immutables
                                            actions: [const LogActionWidget()],
                                          ),
                                          body:
                                              _data[index]['widget'] as Widget?,
                                        )));
                          },
                          title: Text(
                            _data[index]['name'] as String,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.black),
                          ),
                        );
                },
              ),
      ),
    );
  }

  // Display remote user's video
}

class InvalidConfigWidget extends StatelessWidget {
  /// Construct the [InvalidConfigWidget]
  const InvalidConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(
          'Make sure you set the correct appId, ${config.appId}, channelId, etc.. in the lib/config/agora.config.dart file.'),
    );
  }
}
