import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class MapService {
  Set<Marker> buildApartmentMarker(Apartment apartment) {
    final location = LatLng(
      apartment.address.latitude,
      apartment.address.longitude,
    );
    AppLoggerHelper.debug(
      'Building marker for apartment ${apartment.address.fullAddress} at location $location',
    );

    return {
      Marker(
        markerId: MarkerId(apartment.id),
        position: location,
        infoWindow: InfoWindow(
          title: apartment.title,
          snippet: apartment.address.fullAddress,
        ),
      ),
    };
  }
}
