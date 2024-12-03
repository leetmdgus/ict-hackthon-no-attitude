// import 'package:flutter/material.dart';
// import 'package:ict_hackthon_no_attitude/shared/constants/colors.dart';
// import 'package:ict_hackthon_no_attitude/theme/app_theme.dart';
// import '../../services/stamp_service.dart';
// import '../../shared/models/stamp.dart';
//
// class TravelHistoryScreen extends StatefulWidget {
//   final int userId;
//
//   const TravelHistoryScreen({
//     required this.userId,
//     super.key,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return _TravelHistoryScreenState();
//   }
// }
//
// class _TravelHistoryScreenState extends State<TravelHistoryScreen> {
//   List<StampData> stampCards = [];
//   List<StampData> collectedStamps = [];
//   bool isLoading = true;
//   String? errorMessage;
//
//   int visitedCnt = 0;
//
//   void getInitState() async {
//     try {
//       final fetchedCards = await StampService.fetchStampData(widget.userId);
//       if (mounted) {
//         setState(() {
//           stampCards = [...fetchedCards];
//           visitedCnt = stampCards.length;
//
//           collectedStamps = stampCards.toList()
//             ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching stamp data: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           errorMessage = '데이터를 불러오는데 실패했습니다';
//         });
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getInitState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('여행 히스토리'),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(errorMessage!),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isLoading = true;
//                             errorMessage = null;
//                           });
//                           getInitState();
//                         },
//                         child: const Text('다시 시도'),
//                       ),
//                     ],
//                   ),
//                 )
//               : collectedStamps.isEmpty
//                   ? const Center(child: Text('아직 방문한 장소가 없습니다'))
//                   : Column(
//                       children: [
//                         // 상단 요약 정보
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.1),
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(24),
//                               bottomRight: Radius.circular(24),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.place_outlined,
//                                   color: AppColors.primary),
//                               const SizedBox(width: 8),
//                               Text(
//                                 '${collectedStamps.length}개의 장소를 방문했어요!',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // 타임라인 리스트
//                         Expanded(
//                           child: ListView.builder(
//                             padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
//                             itemCount: collectedStamps.length,
//                             itemBuilder: (context, index) {
//                               if (index >= collectedStamps.length) {
//                                 return null;
//                               }
//
//                               final stamp = collectedStamps[index];
//                               final isLeft = index % 2 == 0;
//
//                               return Stack(
//                                 children: [
//                                   Positioned(
//                                     left:
//                                         MediaQuery.of(context).size.width / 2 -
//                                             1,
//                                     top: 20,
//                                     bottom: 0,
//                                     child: Container(
//                                       width: 2,
//                                       color: AppColors.primary.withOpacity(0.2),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       if (index == 0 ||
//                                           _formatDate(collectedStamps[index - 1]
//                                                   .timestamp!) !=
//                                               _formatDate(collectedStamps[index]
//                                                   .timestamp!)) ...[
//                                         // 날짜 표시
//                                         Container(
//                                           margin:
//                                               const EdgeInsets.only(bottom: 8),
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 4,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             gradient: AppTheme.primaryGradient,
//                                             borderRadius:
//                                                 BorderRadius.circular(16),
//                                           ),
//                                           child: Text(
//                                             _formatDate(stamp.timestamp!),
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                       // 스탬프 카드
//                                       IntrinsicHeight(
//                                         child: Row(
//                                           mainAxisAlignment: isLeft
//                                               ? MainAxisAlignment.start
//                                               : MainAxisAlignment.end,
//                                           children: [
//                                             if (!isLeft) const Spacer(),
//                                             SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               child: Card(
//                                                 elevation: 4,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(16),
//                                                 ),
//                                                 child: InkWell(
//                                                   borderRadius:
//                                                       BorderRadius.circular(16),
//                                                   onTap: () =>
//                                                       _showDetailDialog(context,
//                                                           stamp, 3),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             16),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             const Icon(
//                                                               Icons.place,
//                                                               size: 20,
//                                                               color: AppColors
//                                                                   .primary,
//                                                             ),
//                                                             const SizedBox(
//                                                                 width: 4),
//                                                             Expanded(
//                                                               child: Text(
//                                                                 stamp.location,
//                                                                 style:
//                                                                     const TextStyle(
//                                                                   fontSize: 16,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const SizedBox(
//                                                             height: 8),
//                                                         Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: Colors.grey
//                                                                   .shade200,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           8),
//                                                             ),
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             child:
//                                                                 Image.network(
//                                                               _getImageUrl(3),
//                                                               fit: BoxFit.fill,
//                                                             )),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             if (isLeft) const Spacer(),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 24),
//                                     ],
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//     );
//   }
//
//   String _getImageUrl(int imageIdex) {
//     return 'http://3.37.197.243:8000/3/${imageIdex}.png';
//   }
//
//   void _showDetailDialog(BuildContext context, StampData stamp, int idx) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 1,
//                   child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(16),
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: Image.network(
//                         _getImageUrl(idx),
//                         fit: BoxFit.fill,
//                       )),
//                 ),
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close),
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       padding: const EdgeInsets.all(8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.place, color: AppColors.primary),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           stamp.location,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     '방문일: ${_formatDate(stamp.timestamp!)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
//   }
// }
