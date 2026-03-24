import 'package:flutter/material.dart';
import '../binder/binder_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  void openMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: const [

              ListTile(
                leading: Icon(Icons.star_border),
                title: Text("Add wishlist card"),
              ),

              ListTile(
                leading: Icon(Icons.swap_vert),
                title: Text("Rearrange cards"),
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEA),

      body: Center(
        child: BinderWidget(
          cards: cards,
          onCardTap: onCardTap,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openMenu,
        backgroundColor: const Color(0xFFD8CFC7),
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}