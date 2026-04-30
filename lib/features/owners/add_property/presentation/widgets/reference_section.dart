import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/owners/add_property/data/models/reference_model.dart';

import '../../controllers/add_property_controller.dart';

class ReferenceSection extends StatelessWidget {
  final AddPropertyController controller;
  const ReferenceSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.listingType.value == 'furnished'
                ? AppText.referenceContactFurnished.tr
                : AppText.referenceContactMandatory.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Supreme',
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppText.provideAtLeastOnePersonWhoCanVerify.tr,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 16),

          // First reference - shown as inline fields (always present)
          Obx(() {
            if (controller.references.isEmpty) return const SizedBox.shrink();

            return _FirstReferenceFields(
              reference: controller.references[0],
              controller: controller,
            );
          }),

          // Additional references section
          Obx(() {
            if (controller.references.length > 1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  Text(
                    AppText.additionalReferenceOptional.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Supreme',
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.references.length - 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // Skip first reference (index 0), show from index 1 onwards
                      final actualIndex = index + 1;
                      return _ReferenceCard(
                        reference: controller.references[actualIndex],
                        index: actualIndex,
                        controller: controller,
                      );
                    },
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Add reference button
          const SizedBox(height: 16),
          Obx(
            () => controller.references.length < 2
                ? Center(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.addReference(),
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: Text(
                        AppText.addAnotherReferenceOptional.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: const BorderSide(color: Color(0xFF10B981)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// First reference shown as inline fields
class _FirstReferenceFields extends StatefulWidget {
  final ReferenceModel reference;
  final AddPropertyController controller;

  const _FirstReferenceFields({
    required this.reference,
    required this.controller,
  });

  @override
  State<_FirstReferenceFields> createState() => _FirstReferenceFieldsState();
}

class _FirstReferenceFieldsState extends State<_FirstReferenceFields> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.reference.name);
    phoneController = TextEditingController(text: widget.reference.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: AppText.name.tr,
          hint: AppText.enterName.tr,
          controller: nameController,
          keyboardType: TextInputType.name,
          onChanged: (v) {
            widget.controller.updateReference(
              0,
              widget.reference.copyWith(name: v),
            );
          },
          isRequired: widget.controller.listingType.value != 'furnished',
        ),
        const SizedBox(height: 16),
        _buildPhoneNumberField(
          controller: phoneController,
          onChanged: (v) {
            widget.controller.updateReference(
              0,
              widget.reference.copyWith(phoneNumber: v),
            );
          },
          countryCode: widget.controller.referenceCountryCodes.isNotEmpty
              ? widget.controller.referenceCountryCodes[0]
              : CountryCode(dialCode: '+237', code: 'CM', name: 'Cameroon'),
          onCountryCodeChanged: (countryCode) {
            widget.controller.updateReferenceCountryCode(0, countryCode);
          },
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppText.relationship.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF374151),
                  ),
                ),
                if (widget.controller.listingType.value != 'furnished') ...[
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: widget.reference.relationship,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: RelationshipTypes.all.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: Color(0xFF374151),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  widget.controller.updateReference(
                    0,
                    widget.reference.copyWith(relationship: newValue),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: Color(0xFF374151),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Color(0xFF374151),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField({
    required TextEditingController controller,
    required Function(String) onChanged,
    required CountryCode countryCode,
    required Function(CountryCode) onCountryCodeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppText.enterOwnerPhoneNumber.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: Color(0xFF374151),
              ),
            ),
            if (widget.controller.listingType.value != 'furnished') ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: CountryCodePicker(
                  onChanged: onCountryCodeChanged,
                  initialSelection: countryCode.code,
                  favorite: const ['+237'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                  dialogTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  searchStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  dialogSize: const Size(300, 400),
                  barrierColor: Colors.black54,
                  showFlag: true,
                  showFlagDialog: true,
                  flagWidth: 24,
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                height: 24,
                width: 1,
                color: Color(0xFFE5E7EB),
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF374151),
                  ),
                  decoration: InputDecoration(
                    hintText: AppText.enterOwnerPhoneNumber.tr,
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReferenceCard extends StatefulWidget {
  final ReferenceModel reference;
  final int index;
  final AddPropertyController controller;

  const _ReferenceCard({
    required this.reference,
    required this.index,
    required this.controller,
  });

  @override
  State<_ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<_ReferenceCard> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.reference.name);
    phoneController = TextEditingController(text: widget.reference.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${AppText.reference.tr} ${widget.index}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Supreme',
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppText.optional.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () =>
                    widget.controller.removeReference(widget.index),
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                color: const Color(0xFFEF4444),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            label: AppText.name.tr,
            hint: AppText.enterOwnerPhoneNumber.tr,
            controller: nameController,
            keyboardType: TextInputType.name,
            onChanged: (v) {
              widget.controller.updateReference(
                widget.index,
                widget.reference.copyWith(name: v),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildPhoneNumberFieldWithController(
            controller: phoneController,
            onChanged: (v) {
              widget.controller.updateReference(
                widget.index,
                widget.reference.copyWith(phoneNumber: v),
              );
            },
            countryCode:
                widget.controller.referenceCountryCodes.length > widget.index
                ? widget.controller.referenceCountryCodes[widget.index]
                : CountryCode(dialCode: '+237', code: 'CM', name: 'Cameroon'),
            onCountryCodeChanged: (countryCode) {
              widget.controller.updateReferenceCountryCode(
                widget.index,
                countryCode,
              );
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.relationship.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: widget.reference.relationship,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF10B981)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: RelationshipTypes.all.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        color: Color(0xFF374151),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.controller.updateReference(
                      widget.index,
                      widget.reference.copyWith(relationship: newValue),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithController({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: Color(0xFF374151),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberFieldWithController({
    required TextEditingController controller,
    required Function(String) onChanged,
    required CountryCode countryCode,
    required Function(CountryCode) onCountryCodeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          ),
          child: Row(
            children: [
              // Country code picker
              SizedBox(
                width: 120,
                child: CountryCodePicker(
                  onChanged: onCountryCodeChanged,
                  initialSelection: countryCode.code,
                  favorite: const ['+237'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                  dialogTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  searchStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontFamily: 'Montserrat',
                  ),
                  dialogSize: const Size(300, 400),
                  barrierColor: Colors.black.withValues(alpha: 0.5),
                  showFlag: true,
                  showFlagDialog: true,
                  flagWidth: 24,
                  padding: EdgeInsets.zero,
                ),
              ),

              // Divider
              Container(
                height: 24,
                width: 1,
                color: const Color(0xFFE5E7EB),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              // Phone number input
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF374151),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
