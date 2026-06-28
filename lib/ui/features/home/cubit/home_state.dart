part of 'home_cubit.dart';

class HomeState {
  const HomeState({
    this.isLoading = false,
    this.dashboard,
  });

  final bool isLoading;
  final HomeDashboard? dashboard;

  HomeState copyWith({
    bool? isLoading,
    HomeDashboard? dashboard,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
    );
  }
}
