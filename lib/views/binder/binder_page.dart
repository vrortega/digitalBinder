import 'package:flutter/material.dart';
import 'package:digital_binder/viewmodels/binder_viewmodel.dart';
import 'package:digital_binder/views/binder/binder_widget.dart';

class BinderPage extends StatefulWidget {
  const BinderPage({super.key});

  @override
  State<BinderPage> createState() => _BinderPageState();
}

class _BinderPageState extends State<BinderPage> {

  final BinderViewModel viewModel = BinderViewModel();

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
                  viewModel.pickImage(index).then((_) => setState(() {}));
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete card"),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.deleteCard(index);
                  setState(() {});
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
      viewModel.pickImage(index).then((_) => setState(() {}));
    }

    if (action == CardAction.openMenu) {
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
          cards: viewModel.cards,
          onCardTap: onCardTap,
          onNextPage: () {
            viewModel.nextPage();
            setState(() {});
          },
          onPreviousPage: () {
            viewModel.previousPage();
            setState(() {});
          },
          hasPreviousPage: viewModel.hasPreviousPage,
        ),
      ),
    );
  }
}