import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_card.dart';

class BinderWidget extends StatelessWidget {

  final List<File?> cards;
  final Function(int index) onCardTap;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final bool hasPreviousPage;

  const BinderWidget({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.hasPreviousPage,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFFF4EFEA),

      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// BINDER
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

                        Expanded(
                          child: PhotoCard(
                            image: cards[0],
                            onTap: () => onCardTap(0),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                          child: PhotoCard(
                            image: cards[1],
                            onTap: () => onCardTap(1),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      children: [

                        Expanded(
                          child: PhotoCard(
                            image: cards[2],
                            onTap: () => onCardTap(2),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                          child: PhotoCard(
                            image: cards[3],
                            onTap: () => onCardTap(3),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            if (hasPreviousPage)
              Positioned(
                left: -10,
                child: IconButton(
                  iconSize: 18,
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: onPreviousPage,
                ),
              ),

            Positioned(
              right: -10,
              child: IconButton(
                iconSize: 18,
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: onNextPage,
              ),
            ),

          ],
        ),
      ),
    );
  }
}