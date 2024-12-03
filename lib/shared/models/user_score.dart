class UserScore {
  final int userId;
  final String userName;
  final int collectedStamp;

  UserScore({
    required this.userId,
    required this.userName,
    required this.collectedStamp,
  });

  factory UserScore.fromJson(Map<String, dynamic> json) {
    return UserScore(
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      collectedStamp: json['collectedStamp'] as int,
    );
  }
}
