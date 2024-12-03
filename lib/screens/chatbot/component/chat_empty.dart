import 'package:flutter/material.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/font_sizes.dart';

class ChatEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(25.0),
                child: Image(
                  image: AssetImage('assets/img/sun.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '해키와 대화를 시작해보세요!',
              style: TextStyle(
                fontSize: AppFontSize.titleFontSize[1],
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '양양의 멋진 곳곳을 함께 탐험할\n준비가 되어있어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.bodyFontSize[1],
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
