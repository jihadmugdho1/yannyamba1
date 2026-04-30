import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yannyamba/core/core.dart';

class ProfileImageCard extends StatelessWidget {
  const ProfileImageCard({
    super.key,
    required this.imageUrl,
    this.imageFile,
    this.isEditing = false,
    this.onChangeImage,
  });

  final String imageUrl;
  final XFile? imageFile;
  final bool isEditing;
  final VoidCallback? onChangeImage;

  @override
  Widget build(BuildContext context) {
    final String displayImage = imageUrl.isEmpty
        ? ImagePath.profileAvatar
        : imageUrl;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: ClipOval(child: _buildImage(imageFile, displayImage)),
              ),
              if (isEditing)
                Positioned(
                  bottom: -4.w,
                  right: -4.w,
                  child: GestureDetector(
                    onTap: onChangeImage,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.typeColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(XFile? file, String path) {
    if (file != null) {
      return Image.file(
        File(file.path),
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    }

    if (path.isEmpty) {
      return Image.asset(
        ImagePath.profileAvatar,
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    }

    final uri = Uri.tryParse(path);
    final bool isNetwork = uri != null && uri.hasScheme;
    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    }

    final filePath = File(path);
    if (filePath.existsSync()) {
      return Image.file(
        filePath,
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    }

    return Image.asset(path, fit: BoxFit.cover, errorBuilder: _errorBuilder);
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 50.w, color: Colors.grey[600]),
    );
  }
}
