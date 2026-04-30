import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';

import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';

class ProfileController extends GetxController {
  ProfileController({required this.profileService});

  final ProfileService profileService;
  late final AuthenticationController _authenticationController;

  final Rxn<Profile> profile = Rxn<Profile>();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEditing = false.obs;
  final RxBool isSaving = false.obs;
  final Rxn<XFile> selectedImage = Rxn<XFile>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _authenticationController = Get.find<AuthenticationController>();
    ever<bool>(_authenticationController.isLoggedIn, (isLoggedIn) {
      if (isLoggedIn) {
        fetchProfile();
      } else {
        _handleLoggedOutState();
      }
    });

    if (_authenticationController.isLoggedIn.value) {
      fetchProfile();
    } else {
      _handleLoggedOutState();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    if (!_authenticationController.isLoggedIn.value) {
      _handleLoggedOutState();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final profileData = await profileService.getProfile();
      profile.value = profileData;
      _populateFormFields(profileData);
      selectedImage.value = null;
    } catch (error) {
      errorMessage.value = error.toString();
      profile.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void _handleLoggedOutState() {
    isLoading.value = false;
    errorMessage.value = '';
    profile.value = null;
    isEditing.value = false;
    selectedImage.value = null;
  }

  void enterEditMode() {
    final currentProfile = profile.value;
    if (currentProfile == null) {
      return;
    }
    _populateFormFields(currentProfile);
    selectedImage.value = null;
    isEditing.value = true;
  }

  void cancelEdit() {
    isEditing.value = false;
    selectedImage.value = null;
    final currentProfile = profile.value;
    if (currentProfile != null) {
      _populateFormFields(currentProfile);
    }
  }

  Future<void> saveProfile() async {
    final currentProfile = profile.value;
    if (currentProfile == null) {
      return;
    }

    final imagePath = selectedImage.value?.path ?? currentProfile.imageUrl;

    final updatedProfile = Profile(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      imageUrl: imagePath,
      roles: currentProfile.roles,
    );

    try {
      isSaving.value = true;
      final savedProfile = await profileService.updateProfile(updatedProfile);
      profile.value = savedProfile;
      selectedImage.value = null;
      isEditing.value = false;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> showImageSourcePicker() async {
    final ImageSource? source = await Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    if (source != null) {
      await _pickProfileImage(source);
    }
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = pickedFile;
      }
    } catch (error) {
      Get.snackbar('Image selection failed', error.toString());
    }
  }

  void _populateFormFields(Profile data) {
    nameController.text = data.name;
    phoneController.text = data.phoneNumber;
    emailController.text = data.email;
  }
}
