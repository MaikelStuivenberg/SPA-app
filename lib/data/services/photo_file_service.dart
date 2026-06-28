import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/domain/entities/photo.dart';

class PhotoFileService {
  PhotoFileService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<File> downloadToTempFile(
    Photo photo, {
    String tempFileName = 'spa.jpg',
  }) async {
    final response = await _client.get(Uri.parse(photo.url));
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$tempFileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> saveToDownloads(Photo photo) async {
    final file = await downloadToTempFile(photo, tempFileName: 'SPA.jpg');
    await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: file.path,
        fileName: 'SPA-${photo.id}.jpg',
      ),
    );
  }

  Future<void> share(Photo photo) async {
    final file = await downloadToTempFile(photo);
    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> shareMultiple(List<Photo> photos) async {
    if (photos.isEmpty) return;

    final files = <XFile>[];
    for (var i = 0; i < photos.length; i++) {
      final file = await downloadToTempFile(
        photos[i],
        tempFileName: 'spa-${photos[i].id}.jpg',
      );
      files.add(XFile(file.path));
    }

    await Share.shareXFiles(files);
  }

  Future<int> saveMultipleToDownloads(List<Photo> photos) async {
    if (photos.isEmpty) return 0;

    var savedCount = 0;
    final downloadsDir = await getDownloadsDirectory();

    for (final photo in photos) {
      final file = await downloadToTempFile(
        photo,
        tempFileName: 'SPA-${photo.id}.jpg',
      );

      if (downloadsDir != null) {
        final destination = File('${downloadsDir.path}/SPA-${photo.id}.jpg');
        await file.copy(destination.path);
        savedCount++;
        continue;
      }

      final result = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: 'SPA-${photo.id}.jpg',
        ),
      );

      if (result != null) {
        savedCount++;
      }
    }

    return savedCount;
  }
}
