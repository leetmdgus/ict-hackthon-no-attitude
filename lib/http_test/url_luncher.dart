
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Launch Unity App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await _launchNativeApp();
            },
            child: Text('Launch App'),
          ),
        ),
      ),
    );
  }

  Future<void> _launchNativeApp() async {
    const platform = MethodChannel('com.example.ict_hackthon_no_attitude/launch');
    try {
      final result = await platform.invokeMethod('launchApp');
      print(result); // "App launched" 메시지 출력
    } on PlatformException catch (e) {
      print("Failed to launch app: '${e.message}'.");
    }
  }
}
