import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../binder/binder_page.dart';
import '../binder/binder_previewcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
  }

  Future<bool> showDeleteDialog() async {

    return await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Delete binder"),
          content: const Text("Are you sure you want to delete this binder?"),
          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void openBinder(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BinderPage(binderId: id),
      ),
    ).then((_) {
      viewModel.loadBinders();
    });
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {

        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF4EFEA),

          body: viewModel.binders.isEmpty
              ? const Center(
                  child: Text(
                    "No binders yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: viewModel.binders.length,
                  itemBuilder: (context, index) {

                    final binder = viewModel.binders[index];

                    return BinderCardWidget(
                      binder: binder,

                      onTap: () => openBinder(binder.id),

                      onDeleteConfirm: () async {
                        final confirm = await showDeleteDialog();

                        if (confirm) {
                          await viewModel.deleteBinder(binder.id);
                        }

                        return confirm;
                      },
                    );
                  },
                ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {

              final binder = await viewModel.createBinder();

              if (!mounted) return;

              openBinder(binder.id);
            },
            backgroundColor: const Color(0xFFD8CFC7),
            child: const Icon(Icons.add),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}