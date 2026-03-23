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

  Future<void> pickImage() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      final file = File(image.path);

      setState(() {
        int index = cards.indexWhere((c) => c == null);

        if (index != -1) {
          cards[index] = file;
        }
      });

    }
  }

  void openMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Add card image"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),

              const ListTile(
                leading: Icon(Icons.star_border),
                title: Text("Add wishlist card"),
              ),

              const ListTile(
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
        child: BinderWidget(cards: cards),
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