import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:ict_hackthon_no_attitude/shared/constants/colors.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  Map<int, Uint8List> markerIcons = {}; // type별 마커 아이콘 저장
  bool isModalVisible = false;
  Map<String, dynamic>? selectedPlace;

  bool isLoading = true;

  final LatLng _center = const LatLng(38.0868556, 128.6653638);

  // 타입: 0:관광지, 1:숙소, 2:식당, 3:카페
  List<dynamic> places = [];

  @override
  void initState() {
    super.initState();
    loadCustomMapPins(); // 커스텀 마커 로드
    sendIdToDjango();
  }

  // type별 커스텀 마커 이미지 로드
  Future<void> loadCustomMapPins() async {
    markerIcons[0] = await getBytesFromAsset("assets/img/icon-travel.png", 130);
    markerIcons[1] = await getBytesFromAsset("assets/img/icon_home.png", 130);
    markerIcons[2] =
        await getBytesFromAsset("assets/img/icon-restaurant.png", 130);
    markerIcons[3] = await getBytesFromAsset("assets/img/icon-cafe.png", 130);

    // 로딩 성공 여부 로그
    markerIcons.forEach((key, value) {
      if (value == null) {
        print("타입 $key 아이콘 로딩 실패");
      } else {
        print("타입 $key 아이콘 로딩 성공");
      }
    });
    setState(() {});
  }

  // 마커 이미지 크기 변경
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData? data = await rootBundle.load(path);
    if (data == null) {
      throw Exception("Failed to load asset at $path");
    }

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    // Null safety 적용
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            ?.buffer
            .asUint8List() ??
        Uint8List(0);
  }

  // 마커 추가 및 선 연결
  void _addMarkersAndPolylines() {
    if (places.isNotEmpty) {
      // places가 비어있지 않으면
      List<LatLng> polylinePoints = []; // 선을 그릴 좌표 리스트

      setState(() {
        // places 리스트를 순회하며 마커 추가
        for (int i = 0; i < places.length; i++) {
          var place = places[i];
          double latitude = place['langtitude'];
          double longitude = place['longtitude'];
          int type = place['type'];

          // type에 맞는 마커 아이콘 가져오기
          Uint8List? icon = markerIcons[type];

          if (icon != null) {
            // 마커 추가
            _markers.add(
              Marker(
                markerId: MarkerId('marker_$i'),
                position: LatLng(latitude, longitude),
                draggable: false,
                icon: BitmapDescriptor.fromBytes(icon),
                // type별 커스텀 아이콘 사용
                infoWindow: InfoWindow(
                  title: '장소: ${place['name']}',
                  snippet: '코스 ${i}',
                ),
                onTap: () {
                  mapController.showMarkerInfoWindow(
                      MarkerId('marker_$i')); // 마커 클릭 시 InfoWindow 표시

                  setState(() {
                    selectedPlace = place;
                    isModalVisible = true; // 모달창을 표시
                  });
                },
              ),
            );
          }

          // 폴리라인 좌표에 추가
          polylinePoints.add(LatLng(latitude, longitude));
        }

        // 폴리라인 추가
        _polylines.add(Polyline(
          polylineId: PolylineId('line_1'),
          color: Colors.red, // 선 색상
          width: 1, // 선의 두께
          points: polylinePoints, // places 리스트의 좌표들로 선을 연결
        ));
      });
    }
  }

  // Django 서버로 ID 전송
  Future<void> sendIdToDjango() async {
    final url = Uri.parse('http://3.37.197.243:8000/LLM_QUEST/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': 3}), // 예시로 id 값 보냄
    );

    if (response.statusCode == 200) {
      print("포트 성공");
      final String decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> result = jsonDecode(decodedBody);

      List<Map<String, dynamic>> placesData = result.map((place) {
        return {
          'name': place['name'],
          'text': place['text'],
          'type': place['type'],
          'phone': place['phone'],
          'address': place['address'],
          'langtitude': double.tryParse(place['langtitude'].toString()) ?? 0.0,
          'longtitude': double.tryParse(place['longtitude'].toString()) ?? 0.0,
        };
      }).toList();

      setState(() {
        places = placesData;
      });

      print(places);
      _addMarkersAndPolylines(); // places 데이터가 로드된 후 마커와 선 추가

      isLoading = false;
      setState(() {});
    } else {
      print('서버 오류: ${response.statusCode}');
    }
  }

  // 맵 생성 후 호출되는 콜백
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkersAndPolylines(); // 맵이 생성된 후 마커와 폴리라인 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(_markers),
            polylines: Set<Polyline>.of(_polylines),
          ),
          isLoading
              ? Center(
                  child: Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Colors.black87.withOpacity(0.4)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '로딩중입니다.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : (isModalVisible && selectedPlace != null)
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPlace!['name'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text("주소: ${selectedPlace!['address']}"),
                            Text("전화번호: ${selectedPlace!['phone']}"),
                            Text("설명: ${selectedPlace!['text']}"),
                            GestureDetector(
                              onTap: () async {
                                final Uri _url = Uri.parse('https://www.naver.com/');
                                await launchUrl(_url);
                                setState(() {});
                              },
                              child: Text(
                                "웹사이트 : ",
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isModalVisible = false; // 모달창 닫기
                                  });
                                },
                                child: const Text('닫기'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
        ],
      ),
    );
  }
}
