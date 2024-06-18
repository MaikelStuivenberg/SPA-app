import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/features/photos/widgets/photo.dart';

class SendButton extends StatelessWidget {
  const SendButton({
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
        final path = directory.path;
        final file = File('$path/spa.jpg');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile('$path/spa.jpg')]);
      },
      icon: const Icon(
        FontAwesomeIcons.paperPlane,
        color: Colors.black,
      ),
    );
  }
}
