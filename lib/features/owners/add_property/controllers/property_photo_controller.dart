import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/features/owners/add_property/controllers/add_property_controller.dart';

import '../data/services/property_photo_service.dart';

class PropertyPhotoController extends GetxController {
  PropertyPhotoController({PropertyPhotoService? photoService})
    : _photoService = photoService ?? PropertyPhotoService();

  final PropertyPhotoService _photoService;
  final AddPropertyController _addPropertyController = Get.find();

  RxList<String> get propertyPhotos => _addPropertyController.propertyPhotos;

  bool get canAddMore => propertyPhotos.length < _maxPhotos;

  int get maxPhotos => _maxPhotos;

  Future<void> openImageSourceSheet(BuildContext context) async {
    if (!_ensureCanAddMore()) return;

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => PropertyPhotoSourceSheet(
        onGalleryTap: () {
          Navigator.pop(context);
          pickFromGallery();
        },
        onCameraTap: () {
          Navigator.pop(context);
          capturePhoto();
        },
      ),
    );
  }

  Future<void> pickFromGallery() async {
    if (!_ensureCanAddMore()) return;
    try {
      final path = await _photoService.pickFromGallery();
      if (path != null) {
        _addPropertyController.addPhoto(path);
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> capturePhoto() async {
    if (!_ensureCanAddMore()) return;
    try {
      final path = await _photoService.captureFromCamera();
      if (path != null) {
        _addPropertyController.addPhoto(path);
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < propertyPhotos.length) {
      _addPropertyController.removePhoto(index);
    }
  }

  bool _ensureCanAddMore() {
    if (canAddMore) return true;
    Get.snackbar(
      'Limit Reached',
      'You can upload maximum $_maxPhotos photos',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(16.w),
    );
    return false;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(16.w),
    );
  }
}

const int _maxPhotos = 10;

class PropertyPhotoSourceSheet extends StatelessWidget {
  const PropertyPhotoSourceSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Supreme',
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: const Color(0xFF2196F3),
                size: 24.sp,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(fontSize: 16.sp),
              ),
              onTap: onGalleryTap,
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: const Color(0xFF2196F3),
                size: 24.sp,
              ),
              title: Text('Take Photo', style: TextStyle(fontSize: 16.sp)),
              onTap: onCameraTap,
            ),
          ],
        ),
      ),
    );
  }
}
