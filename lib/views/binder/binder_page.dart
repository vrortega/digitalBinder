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
import '../../services/camera_service.dart';
import '../../repositories/binder_repository.dart';
import '../../models/binder_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';

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

  final TextEditingController nameController = TextEditingController();
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
      cameraService: CameraService(ImagePicker()),
    );

    _loadBinderName();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadBinderName() async {
    final jsonString = await storage.getString("binders");
    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    try {
      final binder = decoded
          .map((e) => BinderModel.fromJson(e))
          .firstWhere((b) => b.id == widget.binderId);

      if (!mounted) return;

      setState(() {
        binderName = binder.name;
        nameController.text = binderName;
      });
    } catch (_) {
      nameController.text = binderName;
    }
  }

  Future<void> _saveBinderName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final jsonString = await storage.getString("binders");
    if (jsonString == null) return;

    List decoded = jsonDecode(jsonString);

    for (var binder in decoded) {
      if (binder["id"] == widget.binderId) {
        binder["name"] = trimmed;
      }
    }

    await storage.setString("binders", jsonEncode(decoded));

    if (!mounted) return;

    setState(() {
      binderName = trimmed;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Binder name updated")),
    );
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      nameController.text = binderName;
    });
  }

  Widget _buildTitle() {
    if (isEditing) {
      return SizedBox(
        width: 200,
        child: TextField(
          controller: nameController,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onSubmitted: _saveBinderName,
        ),
      );
    }

    return Text(
      binderName,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }

  void _onCardTap(int index) {
    _openCardMenu(index);
  }

  void _openCardMenu(int index) {
    final current = viewModel.pages[viewModel.currentPage][index];
    final isEmpty = current == null;
    final isFav = current != null && viewModel.isFavorite(current);

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            if (isEmpty) ...[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Scan card"),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.scanCard(index);
                },
              ),
            ],

            if (!isEmpty) ...[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Replace image"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Scan card"),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.scanCard(index);
                },
              ),
              ListTile(
                leading: Icon(
                  isFav ? Icons.star : Icons.star_border,
                ),
                title: Text(
                  isFav ? "Unfavorite card" : "Favorite card",
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.toggleFavorite(index);
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            centerTitle: true,
            title: _buildTitle(),
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              if (isEditing) ...[
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => _saveBinderName(nameController.text),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _cancelEditing,
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
              ],
            ],
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
                      isFavorite: (fileName) =>
                          viewModel.isFavorite(fileName),
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