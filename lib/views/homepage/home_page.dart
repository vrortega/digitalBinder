import 'package:flutter/material.dart';
import '../binder/binder_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void openMenu(BuildContext context) {

    showModalBottomSheet(
      context: context,
      builder: (context) {

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text("Create binder"),
                onTap: () {

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BinderPage(),
                    ),
                  );

                },
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

      body: const Center(
        child: Text(
          "No binders yet",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openMenu(context),
        backgroundColor: const Color(0xFFD8CFC7),
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}