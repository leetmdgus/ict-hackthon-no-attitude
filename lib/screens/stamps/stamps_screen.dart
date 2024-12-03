import 'package:flutter/material.dart';
import 'package:ict_hackthon_no_attitude/shared/constants/colors.dart';
import 'package:ict_hackthon_no_attitude/theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../../services/stamp_service.dart';
import '../../shared/models/stamp.dart';
import 'components/stamp_card.dart';

class StampsScreen extends StatefulWidget {
  const StampsScreen({super.key});

  @override
  State<StampsScreen> createState() => _StampsScreenState();
}

class _StampsScreenState extends State<StampsScreen>
    with SingleTickerProviderStateMixin {
  List<StampData> stampCards = [];
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;

  Future<void> _loadStamps() async {
    try {
      setState(() {
        isLoading = true; // 로딩 시작
      });

      final fetchedStamps = await StampService.fetchStampData(3);

      if (mounted) {
        // 위젯이 여전히 존재하는지 확인
        setState(() {
          stampCards = [...fetchedStamps];
          isLoading = false; // 로딩 완료
        });
      }
    } catch (e) {
      print('Error loading stamps: $e');
      if (mounted) {
        setState(() {
          isLoading = false; // 에러 발생 시에도 로딩 상태 해제
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStamps();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectedStamps =
        stampCards.where((stamp) => stamp.isCollected).toList();
    final uncollectedStamps =
        stampCards.where((stamp) => !stamp.isCollected).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '나의 스탬프',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadStamps,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '수집한 스탬프',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${collectedStamps.length}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' / ${stampCards.length}',
                                  style: TextStyle(
                                    color: AppColors.primary.withOpacity(0.5),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.primary,
                      tabs: const [
                        Tab(text: '  수집한 스탬프  '),
                        Tab(text: '  미수집 스탬프  '),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildStampGrid(collectedStamps, true),
                        _buildStampGrid(uncollectedStamps, false),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStampGrid(List<StampData> stamps, bool isCollected) {
    if (stamps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '아직 수집한 스탬프가 없습니다',
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stamps.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (isCollected) {
              _showDetailDialog(context, stamps[index], index);
            }
          },
          child: StampCard(stampData: stamps[index]),
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, StampData stamp, int idx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        _getImageUrl(idx),
                        fit: BoxFit.fill,
                      )),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stamp.location,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '방문일: ${_formatDate(DateTime.now())}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
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

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String _getImageUrl(int imageIdx) {
    return 'http://3.37.197.243:8000/3/1.png';
  }
}
