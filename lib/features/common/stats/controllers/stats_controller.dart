import 'package:yannyamba/features/common/stats/services/stats_services.dart';

class StatsController {
  final StatsServices _statsService = StatsServices();

  //Increment the view count for any apartment
  void incrementViewCount(String apartmentId) {
    _statsService.incrementViewCount(apartmentId);
  }

  //Increment the query count for any apartment
  void incrementQueryCount(String apartmentId) {
    _statsService.incrementQueryCount(apartmentId);
  }
}
