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

  List<Activity> activities(DateTime date) => program!.where((element) {
        return element.date!.year == date.year &&
            element.date!.month == date.month &&
            element.date!.day == date.day;
      }).toList();

  int get amountOfDays => program == null
      ? 0
      : firstActivity!.date!.difference(lastActivity!.date!).inDays.abs() + 1;

  ProgramState copyWith({bool? isLoading, List<Activity>? program, int? page}) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      program: program ?? this.program,
    );
  }
}
