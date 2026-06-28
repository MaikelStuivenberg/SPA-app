import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/ui/core/widgets/card.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return BlocBuilder<AlbumsCubit, AlbumsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: CardWidget(
              height: 200,
              accentColor: appColors.tertiary,
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Expanded(
          child: CardWidget(
            height: 200,
            accentColor: appColors.tertiary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SPA',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Worship',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/spotify.png', height: 75),
              ],
            ),
            onTap: () {
              launchUrl(
                Uri.parse(
                  'https://open.spotify.com/playlist/'
                  '28ZxH1fGEMHhoT9HrpgJb6?si=8d5d2ba4a60c4f43',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
