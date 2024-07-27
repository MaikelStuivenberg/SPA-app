import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spa_app/features/photos/widgets/photo.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.widget,
  });

  final PhotoStateWidget widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final response = await http.get(Uri.parse(widget.photo.url));
        final directory = await getTemporaryDirectory();

        if (directory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Het lukt op jouw telefoon niet om de fot-o op te slapen. Gebruik de verstuur optie om de foto te delen.')),
          );
          return;
        }

        final path = directory.path;
        final file = File('$path/SPA.jpg');
        await file.writeAsBytes(response.bodyBytes);

        // Ask the user to save it
        final params = SaveFileDialogParams(sourceFilePath: file.path, fileName: 'SPA-${widget.photo.id}.jpg');
        final finalPath = await FlutterFileDialog.saveFile(params: params);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('De foto is opgeslagen in je downloads map.'),
          ),
        );
      },
      icon: const Icon(
        Icons.download,
        color: Colors.black,
      ),
    );
  }
}
