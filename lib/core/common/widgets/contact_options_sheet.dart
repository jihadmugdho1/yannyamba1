import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/common/stats/controllers/stats_controller.dart';
import '../../core.dart';
import 'premium_contact_option.dart';

class ContactOptionsSheet extends StatelessWidget {
  final String ownerName;
  final String phoneNumber;
  final Apartment apartment;

  const ContactOptionsSheet({
    super.key,
    required this.ownerName,
    required this.phoneNumber,
    required this.apartment,
  });

  @override
  Widget build(BuildContext context) {
    final statsController = Get.find<StatsController>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            _header(),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppText.chooseAnOption.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 12),

            PremiumContactOption(
              icon: Icons.phone_rounded,
              label: AppText.phoneCall.tr,
              subtitle: AppText.directCallToOwner.tr,
              gradientColors: [Colors.blue, Colors.blueAccent],
              onTap: () {
                Navigator.pop(context);
                statsController.incrementQueryCount(apartment.id);
                OwnerContactService.launchPhone(phoneNumber);
              },
            ),
            const SizedBox(height: 12),

            PremiumContactOption(
              icon: Icons.chat,
              label: AppText.whatsapp.tr,
              subtitle: AppText.sendInstantMessage.tr,
              gradientColors: [Color(0xFF25D366), Color(0xFF128C7E)],
              onTap: () async {
                Navigator.pop(context);
                statsController.incrementQueryCount(apartment.id);
                await OwnerContactService.launchWhatsApp(
                  context,
                  phoneNumber,
                  apartment,
                );
              },
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey[400]!, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppText.cancel.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.purple[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_outline,
              size: 24,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              ownerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_outlined, size: 18),
                const SizedBox(width: 6),
                Text(phoneNumber, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
