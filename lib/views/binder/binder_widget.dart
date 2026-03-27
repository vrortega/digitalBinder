import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_card.dart';

class BinderWidget extends StatelessWidget {
  final List<File?> cards;
  final Function(int index) onCardTap;
  final Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final bool hasPreviousPage;

  const BinderWidget({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onReorder,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.hasPreviousPage,
  });

  Widget buildDraggableCard(int index) {
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
                ? Border.all(color: Colors.grey, width: 2)
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: cards[index] != null
              ? Draggable<int>(
                  data: index,
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: PhotoCard(
                        image: cards[index],
                        onTap: () {},
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: PhotoCard(
                      image: cards[index],
                      onTap: () => onCardTap(index),
                    ),
                  ),
                  child: PhotoCard(
                    image: cards[index],
                    onTap: () => onCardTap(index),
                  ),
                )
              : PhotoCard(
                  image: cards[index],
                  onTap: () => onCardTap(index),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4EFEA),
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
                  color: const Color(0xFFF9F7F5),
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
                    icon: const Icon(Icons.arrow_back_ios),
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