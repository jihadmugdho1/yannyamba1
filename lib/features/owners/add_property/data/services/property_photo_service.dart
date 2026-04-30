import 'package:image_picker/image_picker.dart';

/// Provides image picking utilities for property photos.
class PropertyPhotoService {
  PropertyPhotoService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pickFromGallery({int imageQuality = 80}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return image?.path;
  }

  Future<String?> captureFromCamera({int imageQuality = 80}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return image?.path;
  }
}
