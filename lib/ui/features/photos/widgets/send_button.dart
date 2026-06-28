import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/data/services/photo_file_service.dart';
import 'package:spa_app/domain/entities/photo.dart';

class SendButton extends StatelessWidget {
  const SendButton({required this.photo, super.key});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => getIt<PhotoFileService>().share(photo),
      icon: FaIcon(
        FontAwesomeIcons.paperPlane,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
