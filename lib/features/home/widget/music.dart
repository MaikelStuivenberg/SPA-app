import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/shared/widgets/card.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosCubit, PhotosState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: CardWidget(
              height: 200,
              child: Container(),
            ),
          );
        }

        if (state.photos == null || state.photos!.isEmpty) {
          return const Text('No photos found');
        }

        return Expanded(
          child: CardWidget(
            height: 200,
            child: GestureDetector(
              onTap: () {
                // Open the Spotify playlist link
                launchUrl(Uri.parse('https://open.spotify.com/playlist/28ZxH1fGEMHhoT9HrpgJb6?si=8d5d2ba4a60c4f43'));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SPA',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Worship',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Image.asset('assets/spotify.png', height: 75),
                ],
              ),
            ),
            ),
          ),
        );
      },
    );
  }
}
