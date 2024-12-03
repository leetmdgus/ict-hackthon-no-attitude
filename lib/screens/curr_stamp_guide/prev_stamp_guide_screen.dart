// import 'package:flutter/material.dart';
// import 'package:ict_hackthon_no_attitude/services/history_service.dart';
// import 'package:ict_hackthon_no_attitude/shared/models/history.dart';
// import '../../shared/constants/colors.dart';
// import '../../theme/app_theme.dart';
//
// class CurrStampGuideScreen extends StatefulWidget {
//   final int userId;
//
//   const CurrStampGuideScreen({required this.userId, super.key});
//
//   @override
//   State<StatefulWidget> createState() => _CurrStampGuideScreenState();
// }
//
// class _CurrStampGuideScreenState extends State<CurrStampGuideScreen> {
//   List<HistoryData> historyCards = [];
//   bool isLoading = true;
//   String? errorMessage;
//
//   void getInitState() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });
//
//       final fetchedCards = await HistoryService.fetchHistoryData(widget.userId);
//
//       if (mounted) {
//         setState(() {
//           historyCards = fetchedCards;
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
//         title: const Text('스탬프 가이드'),
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
//                         onPressed: getInitState,
//                         child: const Text('다시 시도'),
//                       ),
//                     ],
//                   ),
//                 )
//               : Column(
//                   children: [
//                     // 히스토리 리스트
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: historyCards.length,
//                         itemBuilder: (context, index) {
//                           final history = historyCards[index];
//
//                           return Card(
//                             margin: const EdgeInsets.only(bottom: 16),
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: InkWell(
//                               onTap: () =>
//                                   history.isCollected ? _showDetailDialog(context, history, index) : null,
//                               borderRadius: BorderRadius.circular(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   // 이미지 섹션
//                                   history.isCollected
//                                       ? ClipRRect(
//                                           borderRadius:
//                                               const BorderRadius.vertical(
//                                             top: Radius.circular(16),
//                                           ),
//                                           child: AspectRatio(
//                                             aspectRatio: 16 / 9,
//                                             child: Image.network(
//                                               _getImageUrl(index),
//                                               fit: BoxFit.fill,
//                                             ),
//                                           ),
//                                         )
//                                       : Container(
//                                           width: 100,
//                                           height: 100,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 24, vertical: 20),
//                                           margin: const EdgeInsets.fromLTRB(
//                                               16, 16, 16, 24),
//                                           // 하단 여백 추가
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: Icon(Icons.lock),
//                                         ),
//
//                                   // 정보 섹션
//                                   Padding(
//                                     padding: const EdgeInsets.all(16),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             const Icon(
//                                               Icons.place_outlined,
//                                               color: AppColors.primary,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               child: Text(
//                                                 history.location,
//                                                 style: const TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
//
//   String _getImageUrl(int imageIndex) {
//     return 'http://3.37.197.243:8000/3/${imageIndex + 1}.png';
//   }
//
//   void _showDetailDialog(BuildContext context, HistoryData history, int index) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                     child: AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: Image.network(
//                         _getImageUrl(index),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: const EdgeInsets.all(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.place_outlined,
//                             color: AppColors.primary),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             history.location,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // if (history.timestamp != null) ...[
//                     //   const SizedBox(height: 8),
//                     //   Text(
//                     //     '방문일: ${_formatDate(history.timestamp!)}',
//                     //     style: const TextStyle(
//                     //       fontSize: 14,
//                     //       color: AppColors.primary,
//                     //     ),
//                     //   ),
//                     // ],
//                     const SizedBox(height: 16),
//                     Text(
//                       history.description,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
//   }
// }
