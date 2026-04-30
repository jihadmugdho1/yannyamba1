import 'package:get/state_manager.dart';
import 'package:yannyamba/core/core.dart';

class HomeController extends GetxController {
  final _networkCaller = NetworkCaller();
  final showNotmalApartmentsSection = true.obs;

  //Make the init method to fetch the toggle status
  @override
  void onInit() {
    super.onInit();
    getNormalApartmentsToggle();
  }

  Future<void> getNormalApartmentsToggle() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.getNormalApartmentToggle,
      );

      AppLoggerHelper.debug(
        'Normal Apartment Toggle Response: ${response.responseData}',
      );
      AppLoggerHelper.debug(
        'Normal Apartment Toggle Status Code: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.responseData != null) {
        final data = response.responseData;
        if (data is Map &&
            data['data'] is Map &&
            data['data']['isNormalApartmentShow'] is bool) {
          showNotmalApartmentsSection.value =
              data['data']['isNormalApartmentShow'] as bool;
          AppLoggerHelper.debug(
            'Normal Apartment Toggle Value: ${showNotmalApartmentsSection.value}',
          );
        } else {
          AppLoggerHelper.error(
            'Normal Apartment Toggle Response mismatch',
            'Expected Map with data.isNormalApartmentShow',
          );
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Normal Apartment Toggle Error', e);
    }
  }
}
