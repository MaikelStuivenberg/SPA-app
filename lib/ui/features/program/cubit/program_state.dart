part of 'program_cubit.dart';

class ProgramState {
  ProgramState({
    this.isLoading = false,
    this.program,
  });

  final bool isLoading;
  final List<Activity>? program;

  Activity? get firstActivity => program?.first;
  Activity? get lastActivity => program?.last;
  Activity? get nextActivity {
    final now = DateTime.now();
    if (program == null) return null;

    for (final element in program!) {
      final date = element.date;
      if (date != null && date.isAfter(now)) {
        return element;
      }
    }
    return null;
  }

  List<Activity> activities(DateTime date) => program!.where((element) {
        final activityDate = element.date;
        if (activityDate == null) return false;
        return activityDate.year == date.year &&
            activityDate.month == date.month &&
            activityDate.day == date.day;
      }).toList();

  int get amountOfDays {
    if (program == null || program!.isEmpty) return 0;

    final firstDay = _dateOnly(firstActivity!.date!);
    final lastDay = _dateOnly(lastActivity!.date!);
    return lastDay.difference(firstDay).inDays + 1;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  ProgramState copyWith({bool? isLoading, List<Activity>? program, int? page}) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      program: program ?? this.program,
    );
  }
}
