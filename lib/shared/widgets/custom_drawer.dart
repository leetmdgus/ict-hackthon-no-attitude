import 'package:flutter/material.dart';
import 'package:ict_hackthon_no_attitude/screens/curr_stamp_guide/prev_stamp_guide_screen.dart';
import 'package:ict_hackthon_no_attitude/screens/curr_stamp_guide/stamp_guide_screen.dart';
import 'package:ict_hackthon_no_attitude/screens/travel_hisotry/travel_screen.dart';
import '../../screens/leaderboard/leader_screen.dart';
import '../../screens/settings/setting_screen.dart';
import '../../screens/stamps/stamps_screen.dart';
import '../../theme/app_theme.dart';
import '../constants/colors.dart';

class CustomDrawer extends StatelessWidget {
  final userId;

  const CustomDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FF)],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(gradient: AppTheme.primaryGradient),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '사용자님',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.map_outlined,
                    title: '스탬프 가이드',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StampGuideScreen(userId: userId)),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.military_tech_outlined,
                    title: '스탬프 수집 현황',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StampsScreen()),
                    ),
                  ),
                  // _buildDrawerItem(
                  //   context,
                  //   icon: Icons.timeline_outlined,
                  //   title: '여행 히스토리',
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => TravelHistoryScreen(
                  //         userId: userId,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: '리더보드',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen()),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: '설정',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '버전 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
