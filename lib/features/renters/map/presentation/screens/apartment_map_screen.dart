import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/renters/map/controllers/map_controller.dart';
import 'package:yannyamba/features/renters/map/data/services/map_service.dart';

class ApartmentMapScreen extends StatelessWidget {
  final Apartment apartment;

  const ApartmentMapScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      init: MapController(apartment: apartment, mapService: MapService()),
      tag: apartment.id,
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Map View",
            centerTitle: true,
            showBackButton: true,
          ),
          body: GoogleMap(
            initialCameraPosition: controller.initialCameraPosition,
            markers: controller.markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
        );
      },
    );
  }
}
