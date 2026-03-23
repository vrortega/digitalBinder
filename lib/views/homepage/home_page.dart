import 'package:flutter/material.dart';
import 'package:digital_binder/views/binder/binder_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF6F3EF),
      appBar: null,
      body: SafeArea(
        child: BinderWidget(),
      ),
    );
  }
}