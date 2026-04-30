import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yannyamba/core/models/property/apartment_model.dart';

import '../common/widgets/contact_options_sheet.dart';
import '../common/widgets/whatsapp_confirmation_dialog.dart';

class OwnerContactService {
  static Future<void> contactOwner(
    BuildContext context,
    Apartment apartment,
    String ownerName,
    String ownerPhone,
  ) async {
    //final owner = apartment.owner ?? apartment.mainContact;

    // if (owner == null || owner.phone.isEmpty) {
    //   _showErrorSnackbar(context, 'No contact information available');
    //   return;
    // }

    final phoneNumber = ownerPhone.replaceAll(RegExp(r'[^0-9+]'), '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: ContactOptionsSheet(
          ownerName: ownerName,
          phoneNumber: phoneNumber,
          apartment: apartment,
        ),
      ),
    );
  }

  static Future<bool> _showWhatsAppConfirmationDialog(
    BuildContext context,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const WhatsAppConfirmationDialog(),
        ) ??
        false;
  }

  static Future<void> launchPhone(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  static Future<void> launchWhatsApp(
    BuildContext context,
    String phoneNumber,
    Apartment apartment,
  ) async {
    final confirmed = await _showWhatsAppConfirmationDialog(context);
    if (!confirmed) return;

    final message =
        'Hello! I am interested in renting your property:\n\n'
        '${apartment.title}\n'
        'Location: ${apartment.address.street}, ${apartment.address.city}\n'
        'Rent: \$${apartment.rent}/month\n\n'
        'I would like to know more details.';

    final uri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
