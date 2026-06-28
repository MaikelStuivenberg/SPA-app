import 'package:spa_app/core/config/camp_date_range.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/domain/repositories/program_repository.dart';
import 'package:spa_app/ui/features/program/models/activity.dart';

class GetProgramScheduleUseCase {
  GetProgramScheduleUseCase({
    required ProgramRepository programRepository,
    required RemoteConfigService remoteConfigService,
  })  : _programRepository = programRepository,
        _remoteConfigService = remoteConfigService;

  final ProgramRepository _programRepository;
  final RemoteConfigService _remoteConfigService;

  Future<List<Activity>> call() async {
    final campDates = CampDateRange.fromRemoteConfig(_remoteConfigService);

    final program = await _programRepository.getProgram();
    final activities = program.docs.map(Activity.createFromDoc).where((element) {
      final date = element.date;
      return date != null && campDates.contains(date);
    }).toList()
      ..sort((a, b) => a.date!.compareTo(b.date!));

    return activities;
  }
}

int getProgramDayIndex({
  required List<Activity> program,
  required DateTime minDate,
  required DateTime maxDate,
}) {
  final now = DateTime.now();
  if (now.isBefore(minDate) || now.isAfter(maxDate)) return 0;
  return now.day - minDate.day;
}
