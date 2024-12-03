class HistoryData {
  final int tourId;
  final String location;
  final String description;
  final bool isCollected;

  HistoryData({
    required this.tourId,
    required this.location,
    required this.description,
    required this.isCollected
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
        tourId: json['tourId'] as int,
        location: json['location'] as String,
        description: json['description'] as String,
        isCollected: json['isCollected'] as bool
    );
  }
}