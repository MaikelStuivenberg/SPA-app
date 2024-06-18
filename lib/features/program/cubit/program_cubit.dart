import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/features/program/models/activity.dart';
import 'package:spa_app/shared/repositories/program_data.dart';

part 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  ProgramCubit() : super(ProgramState());

  Future<void> fetchProgram() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final programDataRepository = getIt.get<ProgramDataRepository>();
      final program = await programDataRepository.getProgram();
      final mappedProgram = program.docs.map(Activity.createFromDoc).toList();

      emit(
        state.copyWith(
          isLoading: false,
          program: mappedProgram,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
