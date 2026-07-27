import 'package:flutter/material.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({
    Key? key,
    required this.date,
  }) : super(key: key);

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppColors.divider,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _getDateLabel(date),
              style: AppTextStyles.labelMedium,
            ),
          ),
          const Expanded(
            child: Divider(
              color: AppColors.divider,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
