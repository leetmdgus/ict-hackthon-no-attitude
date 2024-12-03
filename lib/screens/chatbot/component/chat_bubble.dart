import 'package:flutter/material.dart';
import '../../../shared/constants/font_sizes.dart';
import '../../../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final List<String> chatbotHistory;
  final int index;
  final FontSize fontSize;

  const ChatBubble({
    super.key,
    required this.isUserMessage,
    required this.chatbotHistory,
    required this.index,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/img/sun.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: isUserMessage ? AppTheme.primaryGradient : null,
                color: isUserMessage ? null : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                chatbotHistory[index],
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black87,
                  fontSize: AppFontSize.chatFontSize[fontSize],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
