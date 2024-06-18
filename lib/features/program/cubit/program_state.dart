part of 'program_cubit.dart';

class ProgramState {
  ProgramState({
    this.isLoading = false,
    this.program,
  });

  final bool isLoading;
  final List<Activity>? program;

  ProgramState copyWith({bool? isLoading, List<Activity>? program, int? page}) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      program: program ?? this.program,
    );
  }
}
