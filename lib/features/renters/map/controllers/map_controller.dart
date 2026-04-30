import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

import '../data/services/map_service.dart';

class MapController extends GetxController {
  final Apartment apartment;
  final MapService mapService;

  late final CameraPosition initialCameraPosition;
  late final Set<Marker> markers;

  MapController({required this.apartment, required this.mapService});

  @override
  void onInit() {
    super.onInit();
    final location = LatLng(
      apartment.address.latitude,
      apartment.address.longitude,
    );

    initialCameraPosition = CameraPosition(target: location, zoom: 15);

    markers = mapService.buildApartmentMarker(apartment);
  }
}
