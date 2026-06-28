import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/core/router/go_router_refresh_stream.dart';
import 'package:spa_app/core/router/no_transition_page.dart';
import 'package:spa_app/core/router/profile_completion.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/ui/core/widgets/app_shell.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/auth/pages/login_page.dart';
import 'package:spa_app/ui/features/auth/pages/password_reset_page.dart';
import 'package:spa_app/ui/features/auth/pages/register_page.dart';
import 'package:spa_app/ui/features/biblestudy/biblestudy.dart';
import 'package:spa_app/ui/features/home/home.dart';
import 'package:spa_app/ui/features/map/pages/map_page.dart';
import 'package:spa_app/ui/features/onboarding/pages/onboarding_page.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/ui/features/photos/pages/album_photos_page.dart';
import 'package:spa_app/ui/features/photos/pages/albums_page.dart';
import 'package:spa_app/ui/features/program/pages/program.dart';
import 'package:spa_app/ui/features/rules/pages/rules_page.dart';
import 'package:spa_app/ui/features/splash/splash.dart';
import 'package:spa_app/ui/features/tasks/models/task.dart';
import 'package:spa_app/ui/features/tasks/pages/all_tasks_page.dart';
import 'package:spa_app/ui/features/tasks/pages/task_details_page.dart';
import 'package:spa_app/ui/features/user/pages/edit_profile_page.dart';
import 'package:spa_app/ui/features/user/pages/user_details_page.dart';
import 'package:spa_app/ui/features/weather/weather.dart';

GoRouter createAppRouter(AuthCubit authCubit, AuthService authService) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final hasSession = authService.currentUser != null;
      const publicRoutes = {
        RoutePaths.splash,
        RoutePaths.login,
        RoutePaths.register,
        RoutePaths.resetPassword,
      };

      if (!hasSession && !publicRoutes.contains(state.matchedLocation)) {
        return RoutePaths.login;
      }

      if (hasSession && authState is AuthStateSuccess) {
        final user = authState.user;
        final location = state.matchedLocation;
        final incomplete = needsOnboarding(user);

        if (incomplete) {
          if (location != RoutePaths.onboarding) {
            return RoutePaths.onboarding;
          }
        } else {
          if (location == RoutePaths.onboarding) {
            return RoutePaths.home;
          }
          if (location == RoutePaths.login ||
              location == RoutePaths.register) {
            return RoutePaths.home;
          }
        }
      }

      if (state.matchedLocation == RoutePaths.allTasks ||
          state.matchedLocation == RoutePaths.taskDetails) {
        if (authState is AuthStateSuccess) {
          final user = authState.user;
          final canManageTasks =
              (user.staff ?? false) || (user.tentLeader ?? false);
          if (!canManageTasks) return RoutePaths.program;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const SplashPage()),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const LoginPage()),
      ),
      GoRoute(
        path: RoutePaths.register,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const RegisterPage()),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const PasswordResetPage()),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const OnboardingPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) =>
                noTransitionPage(state, const HomePage()),
          ),
          GoRoute(
            path: RoutePaths.photos,
            pageBuilder: (context, state) =>
                noTransitionPage(state, const AlbumsPage()),
            routes: [
              GoRoute(
                path: 'album/:albumId',
                pageBuilder: (context, state) {
                  final albumId = state.pathParameters['albumId']!;
                  return noTransitionPage(
                    state,
                    BlocProvider(
                      create: (_) => getIt<PhotosCubit>(param1: albumId)
                        ..fetchLastPhotos(),
                      child: AlbumPhotosPage(albumId: albumId),
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.map,
            pageBuilder: (context, state) =>
                noTransitionPage(state, const MapPage()),
          ),
          GoRoute(
            path: RoutePaths.rules,
            pageBuilder: (context, state) =>
                noTransitionPage(state, const RulesPage()),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.program,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const ProgramPage()),
      ),
      GoRoute(
        path: RoutePaths.allTasks,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const AllTasksPage()),
      ),
      GoRoute(
        path: RoutePaths.taskDetails,
        pageBuilder: (context, state) {
          final task = state.extra! as Task;
          return noTransitionPage(state, TaskDetailsPage(task: task));
        },
      ),
      GoRoute(
        path: RoutePaths.biblestudy,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const BibleStudyPage()),
      ),
      GoRoute(
        path: RoutePaths.userDetails,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const UserDetailsPage()),
      ),
      GoRoute(
        path: RoutePaths.editUser,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const EditProfilePage()),
      ),
      GoRoute(
        path: RoutePaths.weather,
        pageBuilder: (context, state) =>
            noTransitionPage(state, const WeatherPage()),
      ),
    ],
  );
}
