// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class StampData {
//   final int tourId;
//   final String location;
//   final DateTime timestamp;
//
//   StampData({
//     required this.tourId,
//     required this.location,
//     required this.timestamp,
//   });
//
//   factory StampData.fromJson(Map<String, dynamic> json) {
//    var timestamp = json['timestamp'];
//     DateTime parsedTimestamp;
//     if (timestamp is String) {
//       parsedTimestamp = DateTime.parse(timestamp);
//     } else {
//       print("Non-string timestamp detected. Type: ${timestamp.runtimeType}");
//       // UTC 시간대 처리를 위한 수정
//       parsedTimestamp = DateTime.fromMicrosecondsSinceEpoch(
//           timestamp.microsecondsSinceEpoch,
//           isUtc: true
//       );
//     }
//
//     return StampData(
//       tourId: json['tour_id'] as int,
//       location: json['location'] as String,
//       timestamp: parsedTimestamp,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'StampData(tourId: $tourId, location: $location, timestamp: $timestamp)';
//   }
// }
//
// class ImageRequestExample extends StatefulWidget {
//   @override
//   _ImageRequestExampleState createState() => _ImageRequestExampleState();
// }
//
// class _ImageRequestExampleState extends State<ImageRequestExample> {
//   int userId = 3;
//   List<StampData> stampDataList = [];
//   bool isLoading = true;
//   String errorMessage = '';
//
//   Future<void> fetchStampData() async {
//     try {
//       final url = Uri.parse("http://3.37.197.243:8000/mock_stamp_data/");
//       print("Fetching data from: $url");
//
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"id": userId}),
//       );
//
//       if (response.statusCode == 200) {
//         try {
//           // UTF-8 디코딩 처리
//           final String decodedBody = utf8.decode(response.bodyBytes);
//           final List<dynamic> jsonList = jsonDecode(decodedBody);
//           print("Successfully parsed JSON list. Length: ${jsonList.length}");
//
//           final List<StampData> tempList = [];
//           for (var item in jsonList) {
//             try {
//               tempList.add(StampData.fromJson(item));
//               print("Successfully processed item: $item");
//             } catch (e) {
//               print("Error processing individual item: $e");
//               print("Problematic item: $item");
//             }
//           }
//
//           setState(() {
//             stampDataList = tempList;
//             isLoading = false;
//             print("Final stamp data list length: ${stampDataList.length}");
//           });
//         } catch (e) {
//           print("Error parsing JSON: $e");
//           setState(() {
//             errorMessage = "데이터 파싱 중 오류가 발생했습니다";
//             isLoading = false;
//           });
//         }
//       } else {
//         print("Server responded with status code: ${response.statusCode}");
//         setState(() {
//           errorMessage = "서버 오류가 발생했습니다 (${response.statusCode})";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Network error: $e");
//       setState(() {
//         errorMessage = "네트워크 오류가 발생했습니다";
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStampData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Stamp Data")),
//         body: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : stampDataList.isEmpty
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(errorMessage.isEmpty ? '데이터가 없습니다' : errorMessage),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     isLoading = true;
//                     errorMessage = '';
//                   });
//                   fetchStampData();
//                 },
//                 child: Text('새로고침'),
//               ),
//             ],
//           ),
//         )
//             : ListView.builder(
//           itemCount: stampDataList.length,
//           itemBuilder: (context, index) {
//             final stamp = stampDataList[index];
//             return ListTile(
//               title: Text(stamp.location),
//               subtitle: Text(
//                 stamp.timestamp.toString(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(ImageRequestExample());
// }