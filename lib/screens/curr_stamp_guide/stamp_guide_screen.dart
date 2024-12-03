import 'package:flutter/material.dart';
import 'package:ict_hackthon_no_attitude/shared/constants/colors.dart';
import 'package:ict_hackthon_no_attitude/theme/app_theme.dart';
import '../../services/history_service.dart';
import '../../shared/models/history.dart';

class StampGuideScreen extends StatefulWidget {
  final int userId;

  const StampGuideScreen({
    required this.userId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _StampGuideScreenState();
  }
}

class _StampGuideScreenState extends State<StampGuideScreen> {
  List<HistoryData> historyCards = [];
  bool isLoading = true;
  String? errorMessage;
  int visitedCnt = 0;

  void getInitState() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedCards = await HistoryService.fetchHistoryData(widget.userId);

      if (mounted) {
        setState(() {
          historyCards = fetchedCards;
          isLoading = false;

          for (int i = 0; i < fetchedCards.length; i++) {
            if (historyCards[i].isCollected) {
              visitedCnt++;
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching history data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = '데이터를 불러오는데 실패했습니다';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getInitState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스탬프 가이드'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          getInitState();
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // 상단 요약 정보
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.place_outlined,
                              color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '${visitedCnt}개의 장소를 방문했어요!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        itemCount: historyCards.length,
                        itemBuilder: (context, index) {
                          if (index >= historyCards.length) {
                            return null;
                          }

                          final history = historyCards[index];
                          final isLeft = index % 2 == 0;

                          return Stack(
                            children: [
                              Positioned(
                                left: MediaQuery.of(context).size.width / 2 - 1,
                                top: 20,
                                bottom: 0,
                                child: Container(
                                  width: 2,
                                  color: AppColors.primary.withOpacity(0.2),
                                ),
                              ),
                              Column(
                                children: [
                                  // 스탬프 카드
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: isLeft
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        if (!isLeft) const Spacer(),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              onTap: history.isCollected
                                                  ? () => _showDetailDialog(
                                                      context, history, 3)
                                                  : null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.place,
                                                          size: 20,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            history.location,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    history.isCollected
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(16),
                                                            ),
                                                            child: AspectRatio(
                                                              aspectRatio:
                                                                  16 / 9,
                                                              child:
                                                                  Image.network(
                                                                _getImageUrl(
                                                                    index),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 100,
                                                            height: 100,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        20),
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16,
                                                                    16,
                                                                    16,
                                                                    24),
                                                            // 하단 여백 추가
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Icon(
                                                                Icons.lock),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (isLeft) const Spacer(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  String _getImageUrl(int imageIdex) {
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI5KZk0fWq1X9KoKuU-cBO21UgNsNdn9VPcg&s';
  }

  void _showDetailDialog(BuildContext context, HistoryData history, int idx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
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
                              history.location,
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
                        history.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
