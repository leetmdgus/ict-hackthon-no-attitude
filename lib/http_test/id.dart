import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device ID Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceIdScreen(),
    );
  }
}

class DeviceIdScreen extends StatefulWidget {
  @override
  _DeviceIdScreenState createState() => _DeviceIdScreenState();
}

class _DeviceIdScreenState extends State<DeviceIdScreen> {
  String? deviceId;

  @override
  void initState() {
    super.initState();
    fetchDeviceId();
  }

  Future<void> fetchDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? id;
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    id = androidInfo.id; // Android 고유 ID

    setState(() {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device ID Display"),
      ),
      body: Center(
        child: deviceId != null
            ? Text(
          'Device ID: $deviceId',
          style: TextStyle(fontSize: 18),
        )
            : CircularProgressIndicator(), // ID를 가져오는 동안 로딩 표시
      ),
    );
  }
}
