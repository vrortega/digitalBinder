import 'package:flutter/material.dart';
import 'views/homepage/home_page.dart';
import 'repositories/binder_repository.dart';
import 'services/image_service.dart';
import 'services/storage_service.dart';
import './theme/app_colors.dart';

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
      title: 'KBinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ).copyWith(
          surface: AppColors.background,
        ),
      ),
      home: HomePage(
        repository: repository,
        imageService: imageService,
      ),
    );
  }
}
