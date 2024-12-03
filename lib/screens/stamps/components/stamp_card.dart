import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/models/stamp.dart';
import '../../../theme/app_theme.dart';

class StampCard extends StatelessWidget {
  final StampData stampData;

  const StampCard({
    super.key,
    required this.stampData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: stampData.isCollected
              ? AppColors.primary
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stampData.isCollected
                        ? AppColors.primary
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    stampData.isCollected ? Icons.star : Icons.lock,
                    color: stampData.isCollected ? Colors.white : Colors.grey,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '#${stampData.tourId+1}',
                      style: TextStyle(
                        color: stampData.isCollected
                            ? AppColors.primary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  stampData.location,
                  style: TextStyle(
                    color: stampData.isCollected ? Colors.black87 : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (stampData.isCollected) ...[
                  const SizedBox(height: 4),
                  // Text(
                  //   DateFormat('yyyy.MM.dd').format(stampData.timestamp!),
                  //   style: TextStyle(
                  //     color: AppColors.primary.withOpacity(0.8),
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
