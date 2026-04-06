import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BinderPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const BinderPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            "${currentPage + 1} / $totalPages",
            key: ValueKey(currentPage),
            style: const TextStyle(
              color: AppColors.background,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
