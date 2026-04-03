import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../binder/binder_page.dart';
import '../binder/binder_previewcard.dart';
import '../../repositories/binder_repository.dart';
import '../../services/image_service.dart';
import 'package:digital_binder/widgets/primary_fab.dart';

class HomePage extends StatefulWidget {
  final BinderRepository repository;
  final ImageService imageService;

  const HomePage({
    super.key,
    required this.repository,
    required this.imageService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel(
      repository: widget.repository,
      imageService: widget.imageService,
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
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
          ),
        ) ??
        false;
  }

  void _openBinder(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BinderPage(binderId: id),
      ),
    );

    viewModel.loadBinders();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4EFEA),
          body: _buildBody(),
          floatingActionButton: PrimaryFab(
            onPressed: _onCreateBinder,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildBody() {
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return const Center(child: Text("Something went wrong"));

      case ViewState.success:
        if (viewModel.binders.isEmpty) {
          return const Center(child: Text("No binders yet"));
        }

        return ListView.builder(
          itemCount: viewModel.binders.length,
          itemBuilder: (_, index) {
            final binder = viewModel.binders[index];

            return BinderCardWidget(
              binder: binder,
              onTap: () => _openBinder(binder.id),
              onDeleteConfirm: () async {
                final confirm = await _showDeleteDialog();

                if (confirm) {
                  await viewModel.deleteBinder(binder.id);
                }

                return confirm;
              },
            );
          },
        );
    }
  }

  Future<void> _onCreateBinder() async {
    final binder = await viewModel.createBinder();

    if (!mounted) return;

    _openBinder(binder.id);
  }
}
