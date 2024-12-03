// class StampData {
//   final int id;
//   final String location;
//   final String description;
//   final double latitude;
//   final double longitude;
//   final bool isCollected;
//   final DateTime? timestamp; // 수집날짜
//
//   StampData({
//   required this.id,
//   required this.location,
//   required this.description,
//   required this.latitude,
//   required this.longitude,
//   this.isCollected = false,
//   this.timestamp,
//   });
//
//   factory StampData.fromJson(Map<String, dynamic> json) {
//     return StampData(
//       id: json['id'],
//       location: json['location'],
//       description: json['description'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       isCollected: json['is_collected'] ?? false,
//       timestamp: json['timestamp'] != null
//           ? DateTime.parse(json['timestamp'])
//           : null,
//     );
//   }
// }

class StampData {
  final int tourId;
  final String location;
  final DateTime? timestamp;
  final bool isCollected;

  StampData({
    required this.tourId,
    required this.location,
    required this.timestamp,
    required this.isCollected,
  });

  factory StampData.fromJson(Map<String, dynamic> json) {
    // var timestamp = json['timestamp'];
    // DateTime parsedTimestamp;
    //
    // if (timestamp is String) {
    //   parsedTimestamp = DateTime.parse(timestamp);
    // } else {
    //   print("Non-string timestamp detected. Type: ${timestamp.runtimeType}");
    //   parsedTimestamp = DateTime.fromMicrosecondsSinceEpoch(
    //       timestamp.microsecondsSinceEpoch,
    //       isUtc: true);
    // }

    return StampData(
      tourId: json['tour_id'] as int,
      location: json['location'] as String,
      isCollected: json['isCollected'] as bool,
      timestamp: null,
    );
  }
}
