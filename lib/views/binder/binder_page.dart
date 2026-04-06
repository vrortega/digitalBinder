import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:digital_binder/viewmodels/binder_viewmodel.dart';
import 'package:digital_binder/views/binder/binder_widget.dart';
import 'package:digital_binder/widgets/binder_pagination_widget.dart';

import '../../services/image_service.dart';
import '../../services/storage_service.dart';
import '../../services/picker_service.dart';
import '../../services/binder_service.dart';
import '../../repositories/binder_repository.dart';
import '../../models/binder_model.dart';
import 'package:image_picker/image_picker.dart';

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

  final storage = StorageService();

  @override
  void initState() {
    super.initState();

    viewModel = BinderViewModel(
      binderId: widget.binderId,
      repository: BinderRepository(storage),
      imageService: ImageService(),
      pickerService: PickerService(ImagePicker()),
      binderService: BinderService(),
    );

    _loadBinderName();
  }

  Future<void> _loadBinderName() async {
    final jsonString = await storage.getString("binders");

    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    final binder = decoded
        .map((e) => BinderModel.fromJson(e))
        .firstWhere((b) => b.id == widget.binderId);

    setState(() {
      binderName = binder.name;
      nameController = TextEditingController(text: binderName);
    });
  }

  Future<void> _saveBinderName(String name) async {
    final jsonString = await storage.getString("binders");

    if (jsonString == null) return;

    List decoded = jsonDecode(jsonString);

    for (var binder in decoded) {
      if (binder["id"] == widget.binderId) {
        binder["name"] = name;
      }
    }

    await storage.setString("binders", jsonEncode(decoded));

    setState(() {
      binderName = name;
      isEditing = false;
    });
  }

  Widget _buildTitle() {
    if (isEditing) {
      return TextField(
        controller: nameController,
        autofocus: true,
        decoration: const InputDecoration(border: InputBorder.none),
        onSubmitted: _saveBinderName,
      );
    }

    return GestureDetector(
      onDoubleTap: () => setState(() => isEditing = true),
      child: Text(
        binderName,
        style: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void _onCardTap(int index) async {
    final current = viewModel.pages[viewModel.currentPage][index];

    if (current == null) {
      await viewModel.pickImage(index);
    } else {
      _openCardMenu(index);
    }
  }

  void _openCardMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, __) {
        if (viewModel.state == ViewState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.state == ViewState.error) {
          return const Scaffold(
            body: Center(child: Text("Erro ao carregar binder")),
          );
        }

        return Scaffold(
        backgroundColor: const Color(0xFFFDFBFF),


          appBar: AppBar(
            title: _buildTitle(),
            backgroundColor: const Color(0xFFFDFBFF),
            elevation: 0,
          ),

          body: FutureBuilder<List<File?>>(
            future: viewModel.cards,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                  Center(
                    child: BinderWidget(
                      cards: snapshot.data!,
                      onCardTap: _onCardTap,
                      onReorder: viewModel.reorderCards,
                      onNextPage: viewModel.nextPage,
                      onPreviousPage: viewModel.previousPage,
                      hasPreviousPage: viewModel.hasPreviousPage,
                    ),
                  ),

                  BinderPaginationWidget(
                    currentPage: viewModel.currentPage,
                    totalPages: viewModel.pages.length,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}