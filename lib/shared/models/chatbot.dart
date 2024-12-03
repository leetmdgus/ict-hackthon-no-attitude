class ChatbotData {
  final String name;
  final String text;
  final int type;
  final String phone;
  final String address;
  final double langtitude;
  final double longtitude;

  ChatbotData(
      {required this.name,
      required this.text,
      required this.type,
      required this.phone,
      required this.address,
      required this.longtitude,
      required this.langtitude});

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    return ChatbotData(
      name: json['name'] as String,
      text: json['text'] as String,
      type: json['type'] as int,
      phone: json['phone'] as String,
      address: json['address'] as String,
      langtitude: double.tryParse(json['langtitude'].toString()) ?? 0.0,
      longtitude: double.tryParse(json['longtitude'].toString()) ?? 0.0,
    );
  }
}
