import 'package:flutter/material.dart';
import 'package:rumour/models/room.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/theme/app_text_styles.dart';

class RoomHeader extends StatelessWidget {
  final Room room;
  final VoidCallback onBackPressed;

  const RoomHeader({
    Key? key,
    required this.room,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkSurface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Room #${room.code}',
                  style: AppTextStyles.headlineMedium,
                ),
                Text(
                  '${room.memberCount} member${room.memberCount == 1 ? '' : 's'}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
