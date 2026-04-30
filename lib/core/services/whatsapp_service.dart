import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class WhatsAppService {
  static Future<bool> showRentalConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Important Information',
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are about to contact the property owner via WhatsApp.',
                style: getTextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textColor2,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryBlue,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Please complete all rental agreements through our app/company for your safety and protection.',
                        style: getTextStyle(
                          fontSize: 10.sp,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        'Continue to WhatsApp',
                        style: getTextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  static Future<void> openWhatsAppForProperty(
    Apartment apartment, {
    String? customMessage,
  }) async {
    final owner = apartment.owner ?? apartment.mainContact;
    if (owner == null || owner.phone.isEmpty) {
      debugPrint('No valid owner phone found');
      return;
    }

    final phoneNumber = owner.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final message =
        customMessage ??
        'Hello! I am interested in renting your property:\n\n'
            '${apartment.title}\n'
            'Location: ${apartment.address.street}, ${apartment.address.city}\n'
            'Rent: \$${apartment.rent.toStringAsFixed(0)}/month\n\n'
            'I would like to know more details about this property.';
    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch WhatsApp for number: $phoneNumber');
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  static Future<void> contactOwnerViaWhatsApp(
    BuildContext context,
    Apartment apartment, {
    String? customMessage,
  }) async {
    final confirmed = await showRentalConfirmationDialog(context);
    if (confirmed) {
      await openWhatsAppForProperty(apartment, customMessage: customMessage);
    }
  }

  static Future<void> openWhatsAppDirect(
    String phoneNumber, {
    String? message,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    final whatsappUrl = message != null
        ? 'https://wa.me/$cleanPhone?text=$encodedMessage'
        : 'https://wa.me/$cleanPhone';
    final uri = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }
}
