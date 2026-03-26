import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/binder_model.dart';

class BinderCardWidget extends StatelessWidget {

  final BinderModel binder;
  final VoidCallback onTap;
  final Future<bool> Function() onDeleteConfirm;

  const BinderCardWidget({
    super.key,
    required this.binder,
    required this.onTap,
    required this.onDeleteConfirm,
  });

  Future<File?> getPreviewFile(String? fileName) async {
    if (fileName == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/binder_images/$fileName');

    if (await file.exists()) return file;

    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(binder.id),
      direction: DismissDirection.endToStart,

      confirmDismiss: (_) async {
        return await onDeleteConfirm();
      },

      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7F5),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Row(
            children: [

              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),

                child: FutureBuilder<File?>(
                  future: getPreviewFile(binder.preview),
                  builder: (context, snapshot) {

                    final file = snapshot.data;

                    if (file != null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, fit: BoxFit.cover),
                      );
                    }

                    return const Icon(Icons.photo);
                  },
                ),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    binder.name,
                    style: const TextStyle(
                      fontFamily: "Sora",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${binder.cardCount} cards",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}