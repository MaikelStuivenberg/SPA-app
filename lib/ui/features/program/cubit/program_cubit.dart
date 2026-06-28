import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/use_cases/get_program_schedule_use_case.dart';
import 'package:spa_app/ui/features/program/models/activity.dart';

part 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  ProgramCubit({required GetProgramScheduleUseCase getProgramScheduleUseCase})
      : _getProgramScheduleUseCase = getProgramScheduleUseCase,
        super(ProgramState());

  final GetProgramScheduleUseCase _getProgramScheduleUseCase;

  Future<void> fetchProgram() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final program = await _getProgramScheduleUseCase();
      emit(
        state.copyWith(
          isLoading: false,
          program: program,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
