import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spa_app/features/home/widget/countdown.dart';
import 'package:spa_app/features/home/widget/music.dart';
import 'package:spa_app/features/home/widget/photo.dart';
import 'package:spa_app/features/home/widget/weather.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      '',
      _buildBody(),
    );
  }

  Widget _buildBody() {
    final userDataRepository = UserDataRepository();

    return FutureBuilder(
      future: userDataRepository.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: SpinKitFadingCube(
              color: Colors.white,
            ),
          );
        }

        final user = snapshot;

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hey', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    user.data!.firstname ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const WeatherWidget(),
                  const SizedBox(height: 8),
                  CountdownWidget(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const PhotoWidget(),
                      const MusicWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        ;
      },
    );
  }
}
