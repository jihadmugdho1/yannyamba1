import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/services/whatsapp_service.dart';

import '../data/models/contact_request_model.dart';
import '../data/services/contact_service.dart';

class ContactController extends GetxController {
  ContactController({ContactService? service})
    : _service = service ?? ContactService();

  final ContactService _service;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Rxn<XFile> attachment = Rxn<XFile>();
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final RxnString subjectError = RxnString();
  final RxnString descriptionError = RxnString();

  late final List<Worker> _workers;

  @override
  void onInit() {
    super.onInit();

    subjectController.addListener(() {
      if (subjectError.value != null &&
          subjectController.text.trim().isNotEmpty) {
        subjectError.value = null;
      }
    });

    descriptionController.addListener(() {
      if (descriptionError.value != null &&
          descriptionController.text.trim().isNotEmpty) {
        descriptionError.value = null;
      }
    });

    _workers = [
      ever<String?>(error, (message) {
        if (message?.isNotEmpty ?? false) {
          _showSnackbar(
            title: 'Action needed',
            message: message!,
            backgroundColor: AppColors.error,
          );
        }
      }),
    ];
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> chooseAttachment() async {
    error.value = null;
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
      await _pickAttachment(source);
    }
  }

  Future<void> _pickAttachment(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        attachment.value = pickedFile;
      }
    } catch (e) {
      error.value = 'Attachment selection failed: ${e.toString()}';
    }
  }

  void removeAttachment() {
    attachment.value = null;
  }

  void resetForm({bool clearMessages = true}) {
    subjectController.clear();
    descriptionController.clear();
    attachment.value = null;

    if (clearMessages) {
      error.value = null;
    }

    subjectError.value = null;
    descriptionError.value = null;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;

    error.value = null;
    subjectError.value = null;
    descriptionError.value = null;

    final subject = subjectController.text.trim();
    final description = descriptionController.text.trim();

    var hasValidationError = false;

    if (subject.isEmpty) {
      subjectError.value = 'Subject is required.';
      hasValidationError = true;
    }

    if (description.isEmpty) {
      descriptionError.value = 'Description is required.';
      hasValidationError = true;
    }

    if (hasValidationError) {
      return;
    }

    isSubmitting.value = true;

    final request = ContactRequest(
      subject: subject,
      description: description,
      attachmentPath: attachment.value?.path,
    );

    try {
      final success = await _service.sendContactRequest(request);
      if (success) {
        resetForm(clearMessages: false);
        // Show success dialog instead of snackbar
        await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 28),
                const SizedBox(width: 12),
                const Text('Success'),
              ],
            ),
            content: const Text(
              'Your message has been sent successfully! We will get back to you soon.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close both dialog and contact screen
                  Get.close(2);
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        error.value = 'Failed to send your message. Please try again later.';
      }
    } catch (e) {
      error.value = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> contactSupportViaWhatsApp(BuildContext context) async {
    const supportPhoneNumber = '+237650000000'; // Support phone number
    const message = 'Hello! I need help with the Yannyamba app.';

    try {
      await WhatsAppService.openWhatsAppDirect(
        supportPhoneNumber,
        message: message,
      );
    } catch (e) {
      error.value =
          'Could not open WhatsApp. Please make sure WhatsApp is installed.';
    }
  }

  void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    try {
      Get.closeCurrentSnackbar();
    } catch (e) {
      // Ignore if no snackbar is currently shown
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
