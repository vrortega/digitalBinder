import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'binder_widget.dart';

class BinderPage extends StatefulWidget {
  const BinderPage({super.key});

  @override
  State<BinderPage> createState() => _BinderPageState();
}

class _BinderPageState extends State<BinderPage> {

  final ImagePicker picker = ImagePicker();

  List<File?> cards = [
    null,
    null,
    null,
    null,
  ];

  Future<void> pickImage(int index) async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        cards[index] = File(image.path);
      });
    }
  }

  void deleteCard(int index) {
    setState(() {
      cards[index] = null;
    });
  }

  void openCardMenu(int index) {

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Replace image"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(index);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete card"),
                onTap: () {
                  Navigator.pop(context);
                  deleteCard(index);
                },
              ),

            ],
          ),
        );
      },
    );
  }

  void onCardTap(int index) {

    if (cards[index] == null) {
      pickImage(index);
    } else {
      openCardMenu(index);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEA),

      appBar: AppBar(
        title: const Text("My Binder"),
        backgroundColor: const Color(0xFFF4EFEA),
        elevation: 0,
      ),

      body: Center(
        child: BinderWidget(
          cards: cards,
          onCardTap: onCardTap,
        ),
      ),
    );
  }
}