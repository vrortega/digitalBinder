import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_card.dart';
import '../../theme/app_colors.dart';

class BinderWidget extends StatelessWidget {
  final List<File?> cards;
  final Function(int index) onCardTap;
  final Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final bool Function(String fileName) isFavorite;
  final bool hasPreviousPage;

  const BinderWidget({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onReorder,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.isFavorite,
    required this.hasPreviousPage,
  });

  Widget buildDraggableCard(int index) {
    final file = cards[index];

    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        final fromIndex = details.data;

        if (cards[fromIndex] == null) return;

        if (fromIndex != index) {
          onReorder(fromIndex, index);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            border: isHovering
                ? Border.all(color: AppColors.border, width: 2)
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: file != null
              ? Draggable<int>(
                  data: index,

                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: PhotoCard(
                        key: ValueKey(file.path),
                        image: file,
                        isFavorite: isFavorite(
                          file.path.split('/').last,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),

                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: PhotoCard(
                      key: ValueKey(file.path),
                      image: file,
                      isFavorite: isFavorite(
                        file.path.split('/').last,
                      ),
                      onTap: () => onCardTap(index),
                    ),
                  ),

                  child: PhotoCard(
                    key: ValueKey(file.path),
                    image: file,
                    isFavorite: isFavorite(
                      file.path.split('/').last,
                    ),
                    onTap: () => onCardTap(index),
                  ),
                )

              : PhotoCard(
                  image: file,
                  onTap: () => onCardTap(index),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: SizedBox(
          width: 380,
          height: 480,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 320,
                height: 480,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: buildDraggableCard(0)),
                          const SizedBox(height: 16),
                          Expanded(child: buildDraggableCard(1)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: buildDraggableCard(2)),
                          const SizedBox(height: 16),
                          Expanded(child: buildDraggableCard(3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPreviousPage)
                Positioned(
                  left: -5,
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: onPreviousPage,
                  ),
                ),
              Positioned(
                right: -5,
                child: IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: onNextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}