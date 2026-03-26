import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_binder/viewmodels/binder_viewmodel.dart';
import 'package:digital_binder/views/binder/binder_widget.dart';

class BinderPage extends StatefulWidget {
  final String binderId;

  const BinderPage({
    super.key,
    required this.binderId,
  });

  @override
  State<BinderPage> createState() => _BinderPageState();
}

class _BinderPageState extends State<BinderPage> {
  late final BinderViewModel viewModel;

  String binderName = "New Binder";

  bool isEditing = false;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    viewModel = BinderViewModel(widget.binderId);
    loadBinderName();
  }

  Future<void> loadBinderName() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString("binders");

    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    final binder = decoded.firstWhere(
      (e) => e["id"] == widget.binderId,
    );

    binderName = binder["name"];

    nameController = TextEditingController(text: binderName);

    setState(() {});
  }

  Future<void> saveBinderName(String name) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString("binders");

    if (jsonString == null) return;

    List decoded = jsonDecode(jsonString);

    for (var binder in decoded) {
      if (binder["id"] == widget.binderId) {
        binder["name"] = name;
      }
    }

    await prefs.setString("binders", jsonEncode(decoded));

    binderName = name;

    setState(() {
      isEditing = false;
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
                  viewModel.pickImage(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete card"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.deleteCard(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onCardTap(int index) {
    final action = viewModel.onCardTap(index);

    if (action == CardAction.addImage) {
      viewModel.pickImage(index);
    }

    if (action == CardAction.openMenu) {
      openCardMenu(index);
    }
  }

  Widget buildTitle() {
    if (isEditing) {
      return TextField(
        controller: nameController,
        autofocus: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          saveBinderName(value);
        },
      );
    }

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Text(
        binderName,
        style: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
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
          appBar: AppBar(
            title: buildTitle(),
            backgroundColor: const Color(0xFFF4EFEA),
            elevation: 0,
          ),
          body: Center(
            child: BinderWidget(
              cards: viewModel.cards,
              onCardTap: onCardTap,
              onReorder: viewModel.reorderCards, 
              onNextPage: viewModel.nextPage,
              onPreviousPage: viewModel.previousPage,
              hasPreviousPage: viewModel.hasPreviousPage,
            ),
          ),
        );
      },
    );
  }
}
