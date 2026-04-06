import 'package:flutter/material.dart';
import 'views/homepage/home_page.dart';
import 'repositories/binder_repository.dart';
import 'services/image_service.dart';
import 'services/storage_service.dart';

void main() {
  final storage = StorageService();

  runApp(
    DigitalBinderApp(
      repository: BinderRepository(storage),
      imageService: ImageService(),
    ),
  );
}

class DigitalBinderApp extends StatelessWidget {
  final BinderRepository repository;
  final ImageService imageService;

  const DigitalBinderApp({
    super.key,
    required this.repository,
    required this.imageService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiBinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFBFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFDAF4),
        ).copyWith(
          surface: const Color(0xFFFDFBFF),
        ),
      ),
      home: HomePage(
        repository: repository,
        imageService: imageService,
      ),
    );
  }
}