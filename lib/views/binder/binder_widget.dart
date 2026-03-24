import 'package:flutter/material.dart';
import 'dart:io';
import 'photo_card.dart';

class BinderWidget extends StatelessWidget {

  final List<File?> cards;
  final Function(int index) onCardTap;

  const BinderWidget({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4EFEA),
      child: Center(
        child: Container(
          width: 360,
          height: 480,
          padding: const EdgeInsets.all(32),
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
      ),
    );
  }
}