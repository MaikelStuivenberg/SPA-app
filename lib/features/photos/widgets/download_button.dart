import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:native_exif/native_exif.dart';
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
        Directory directory;

        try {
          directory = await getTemporaryDirectory();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Het lukt op jouw telefoon niet om de foto op te slaan. Gebruik de verstuur optie om de foto te delen.')),
          );
          return;
        }

        final path = directory.path;
        final file = File('$path/SPA-${widget.photo.id}.jpg');

        await file.writeAsBytes(response.bodyBytes);



        try {
          final dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
          final exif = await Exif.fromPath(file.path!);
          await exif.writeAttribute(
            'DateTimeOriginal',
            dateFormat.format(widget.photo.createdAt),
          );
          await exif.close();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }

        // Ask the user to save it
        final params = SaveFileDialogParams(
            sourceFilePath: file.path, fileName: 'SPA-${widget.photo.id}.jpg');
        final finalPath = await FlutterFileDialog.saveFile(params: params);

        if(finalPath == null) {
          return;
        }
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
