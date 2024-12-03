import 'package:flutter/material.dart';
import 'package:ict_hackthon_no_attitude/services/user_rating_service.dart';
import 'package:ict_hackthon_no_attitude/shared/models/user_score.dart';
import '../../shared/constants/colors.dart';
import '../../theme/app_theme.dart';
import 'components/leader_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardState();
  }
}

class _LeaderboardState extends State<LeaderboardScreen> {
  bool isLoading = true;
  List<UserScore> users = [];

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    final fetchedUsers = await UserRatingService.fetchUserData(3);
    users = fetchedUsers.toList()
      ..sort((a, b) => b.collectedStamp.compareTo(a.collectedStamp));

    isLoading = false; // 로딩 완료
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리더보드'),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FF)],
          ),
        ),
        child: isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('${users.length} 사람들을 불러오는 중입니다. .')
                ],
              ))
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTopRanker(
                          context,
                          rank: 2,
                          name: users[1].userName,
                          stampCnt: users[1].collectedStamp,
                          size: 80,
                        ),
                        _buildTopRanker(
                          context,
                          rank: 1,
                          name: users[0].userName,
                          stampCnt: users[0].collectedStamp,
                          size: 100,
                          isFirst: true,
                        ),
                        _buildTopRanker(
                          context,
                          rank: 3,
                          name: users[2].userName,
                          stampCnt: users[2].collectedStamp,
                          size: 80,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: users.length - 3,
                        itemBuilder: (context, index) {
                          return LeaderCard(
                            rank: index + 4,
                            name: users[index + 3].userName,
                            stampCnt: users[index + 3].collectedStamp,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTopRanker(
    BuildContext context, {
    required int rank,
    required String name,
    required int stampCnt,
    required double size,
    bool isFirst = false,
  }) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: isFirst
                ? AppTheme.primaryGradient
                : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: (isFirst ? AppColors.primary : Colors.grey)
                    .withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: Colors.white,
                fontSize: isFirst ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$stampCnt 개',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
