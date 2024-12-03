import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/font_sizes.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = '한국어';
  FontSize selectedFontSize = FontSize.medium;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      darkModeEnabled = prefs.getBool('darkMode') ?? false;
      selectedLanguage = prefs.getString('language') ?? '한국어';
      selectedFontSize =
          FontSize.values[prefs.getInt('fontSize') ?? 1]; // 기본값은 medium
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setBool('darkMode', darkModeEnabled);
    await prefs.setString('language', selectedLanguage);
    await prefs.setInt('fontSize', selectedFontSize.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
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
        child: ListView(
          children: [
            _buildSection(title: '글자크기', children: [
              _buildFontSizeSelector(),
            ]),
            _buildSection(
              title: '일반',
              children: [
                _buildSwitchTile(
                  title: '알림',
                  subtitle: '앱 알림을 받습니다',
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                      _saveSettings();
                    });
                  },
                ),
                _buildSwitchTile(
                  title: '다크 모드',
                  subtitle: '어두운 테마를 사용합니다',
                  value: darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      darkModeEnabled = value;
                      _saveSettings();
                    });
                  },
                ),
                _buildLanguageSelector(),
              ],
            ),
            _buildSection(
              title: '계정',
              children: [
                _buildListTile(
                  title: '프로필 수정',
                  icon: Icons.person_outline,
                  onTap: () {
                    // TODO: Implement profile edit
                  },
                ),
                _buildListTile(
                  title: '비밀번호 변경',
                  icon: Icons.lock_outline,
                  onTap: () {
                    // TODO: Implement password change
                  },
                ),
              ],
            ),
            _buildSection(
              title: '기타',
              children: [
                _buildListTile(
                  title: '도움말',
                  icon: Icons.help_outline,
                  onTap: () {
                    // TODO: Implement help
                  },
                ),
                _buildListTile(
                  title: '개인정보 처리방침',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    // TODO: Show privacy policy
                  },
                ),
                _buildListTile(
                  title: '약관',
                  icon: Icons.description_outlined,
                  onTap: () {
                    // TODO: Show terms
                  },
                ),
                _buildListTile(
                  title: '앱 버전',
                  icon: Icons.info_outline,
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppFontSize.titleFontSize[selectedFontSize],
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildFontSizeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: FontSize.values.map((size) {
              final isSelected = size == selectedFontSize;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFontSize = size;
                    _saveSettings();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppTheme.primaryGradient
                        : null,
                    color: isSelected ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppFontSize.getFontSizeName(size),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            '미리보기',
            style: TextStyle(
              fontSize: AppFontSize.bodyFontSize[selectedFontSize],
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '안녕하세요! 이 크기로 채팅이 표시됩니다.',
              style: TextStyle(
                fontSize: AppFontSize.chatFontSize[selectedFontSize],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: const Icon(
        Icons.language,
        color: AppColors.primary,
      ),
      title: const Text('언어'),
      trailing: DropdownButton<String>(
        value: selectedLanguage,
        items: const [
          DropdownMenuItem(value: '한국어', child: Text('한국어')),
          DropdownMenuItem(value: 'English', child: Text('English')),
          DropdownMenuItem(value: '日本語', child: Text('日本語')),
          DropdownMenuItem(value: '中文', child: Text('中文')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedLanguage = value;
              _saveSettings();
            });
          }
        },
      ),
    );
  }
}
