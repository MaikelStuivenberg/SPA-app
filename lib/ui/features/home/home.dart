import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/features/home/cubit/home_cubit.dart';
import 'package:spa_app/ui/features/home/widget/countdown.dart';
import 'package:spa_app/ui/features/home/widget/music.dart';
import 'package:spa_app/ui/features/home/widget/next_program.dart';
import 'package:spa_app/ui/features/home/widget/photo.dart';
import 'package:spa_app/ui/features/home/widget/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading || state.dashboard == null) {
          return Center(
            child: SpinKitFadingCube(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }

        final dashboard = state.dashboard!;

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => context.push(RoutePaths.userDetails),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            dashboard.user.firstname ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const WeatherWidget(),
                  const SizedBox(height: 8),
                  if (dashboard.showNextProgram) const NextProgramWidget(),
                  if (!dashboard.showNextProgram)
                    CountdownWidget(
                      targetDate: dashboard.targetDate,
                      countdownEvent: dashboard.countdownEvent,
                    ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      PhotoWidget(),
                      SizedBox(width: 8),
                      MusicWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
