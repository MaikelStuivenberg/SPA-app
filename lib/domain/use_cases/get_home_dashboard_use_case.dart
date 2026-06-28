import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class HomeDashboard {
  const HomeDashboard({
    required this.user,
    required this.targetDate,
    required this.countdownEvent,
    required this.showNextProgram,
  });

  final UserData user;
  final DateTime targetDate;
  final String countdownEvent;
  final bool showNextProgram;
}

class GetHomeDashboardUseCase {
  GetHomeDashboardUseCase({
    required UserRepository userRepository,
    required RemoteConfigService remoteConfigService,
  })  : _userRepository = userRepository,
        _remoteConfigService = remoteConfigService;

  final UserRepository _userRepository;
  final RemoteConfigService _remoteConfigService;

  Future<HomeDashboard> call() async {
    final user = await _userRepository.getUser();
    final targetDate = DateTime.parse(
      _remoteConfigService.getString(RemoteConfigKeys.countdownDate),
    );
    final hoursRemaining = targetDate.difference(DateTime.now()).inHours;

    return HomeDashboard(
      user: user,
      targetDate: targetDate,
      countdownEvent:
          _remoteConfigService.getString(RemoteConfigKeys.countdownEvent),
      showNextProgram: hoursRemaining <= 6,
    );
  }
}
