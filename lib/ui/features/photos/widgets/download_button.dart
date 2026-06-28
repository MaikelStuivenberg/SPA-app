import 'package:flutter/material.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/data/services/photo_file_service.dart';
import 'package:spa_app/domain/entities/photo.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({required this.photo, super.key});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await getIt<PhotoFileService>().saveToDownloads(photo);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('De foto is opgeslagen in je downloads map.'),
            ),
          );
        }
      },
      icon: Icon(
        Icons.download,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
