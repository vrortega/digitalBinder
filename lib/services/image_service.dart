import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<Directory> _getImagesDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/binder_images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir;
  }

  Future<String> saveImage(File image) async {
    final imagesDir = await _getImagesDirectory();

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    final newPath = '${imagesDir.path}/$fileName';

    final newImage = await image.copy(newPath);

    if (!await newImage.exists()) {
      throw Exception("Erro ao salvar imagem");
    }

    return fileName;
  }

  Future<void> deleteImage(String fileName) async {
    final imagesDir = await _getImagesDirectory();

    final file = File('${imagesDir.path}/$fileName');

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File?> getImageFile(String fileName) async {
    final imagesDir = await _getImagesDirectory();

    final file = File('${imagesDir.path}/$fileName');

    if (await file.exists()) return file;

    return null;
  }

  Future<void> deleteImagesFromBinder(List pages) async {
    final imagesDir = await _getImagesDirectory();

    for (var page in pages) {
      for (var fileName in page) {
        if (fileName != null) {
          final file = File('${imagesDir.path}/$fileName');

          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    }
  }
}