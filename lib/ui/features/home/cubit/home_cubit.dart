import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/use_cases/get_home_dashboard_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required GetHomeDashboardUseCase getHomeDashboardUseCase})
      : _getHomeDashboardUseCase = getHomeDashboardUseCase,
        super(const HomeState());

  final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  Future<void> loadDashboard() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final dashboard = await _getHomeDashboardUseCase();
      emit(
        state.copyWith(
          isLoading: false,
          dashboard: dashboard,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
