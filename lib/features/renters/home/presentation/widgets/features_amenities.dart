import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FeaturesAmenities extends StatelessWidget {
  final Apartment apartment;

  const FeaturesAmenities({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final combined = [...apartment.features, ...apartment.amenities];
    AppLoggerHelper.debug(
      'Features: ${apartment.features}, Amenities: ${apartment.amenities}',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features & Amenities',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFeaturesList(combined),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList(List<String> features) {
    List<Widget> widgets = [];
    for (int i = 0; i < features.length; i += 2) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _bulletText(features[i])),
              if (i + 1 < features.length)
                Expanded(child: _bulletText(features[i + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _bulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: getTextStyle(fontSize: 14, color: AppColors.textColor),
          ),
        ),
      ],
    );
  }
}
