import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickerService {
  final ImagePicker picker;

  PickerService(this.picker);

  Future<File?> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    return File(image.path);
  }
}