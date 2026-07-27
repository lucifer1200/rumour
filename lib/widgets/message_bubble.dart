import 'package:flutter/material.dart';
import 'package:rumour/models/message.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final formattedTime = timeFormat.format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwnMessage)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message.userAvatar),
              backgroundColor: AppColors.darkSurfaceVariant,
              onBackgroundImageError: (_, __) {},
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isOwnMessage)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.userName,
                      style: AppTextStyles.labelMedium,
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: isOwnMessage ? AppColors.ownMessageBg : AppColors.otherMessageBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isOwnMessage ? AppColors.ownMessageText : AppColors.otherMessageText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    formattedTime,
                    style: AppTextStyles.labelSmall,
                  ),
                ),
              ],
            ),
          ),
          if (isOwnMessage) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
