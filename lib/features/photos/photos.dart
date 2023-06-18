import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  PhotosPageState createState() => PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> {
  List<dynamic> _photos = [];

  @override
  void initState() {
    super.initState();
    _getRecentImagesInAlbum();
  }

  Future<void> _getRecentImagesInAlbum() async {
    // TODO(Maikel): Move this code to an service class
    const apiKey = '639f377344ffa79f1f0ebc8349dbae6f';
    const userId = '195851792@N04';
    // const albumId = '72177720300776159';

    const url =
        'https://www.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=$apiKey&user_id=$userId&extras=url_m,date_taken&sort=date-taken-desc&per_page=10&format=json&nojsoncallback=1&extras=url_m,url_k';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _photos = data['photos']['photo'] as List<dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.photoTitle,
              style: Styles.pageTitle,
            ),
            Expanded(child: _buildPhotoGrid()),
            ElevatedButton(
              onPressed: () async {
                const url =
                    'https://www.flickr.com/photos/salvationarmyyouthnl/albums/72177720300776159/with/52237203531/';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              style: Styles.buttonStyle,
              child: Text(AppLocalizations.of(context)!.photoSeeAll,
                  style: Styles.buttonText),
            ),
            Container(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: _photos.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildPhotoGridRow(),
                    ],
                  ),
                ],
              ),
            )
          : const Text(''),
    );
  }

  Widget _buildPhotoGridRow() {
    return Expanded(
      child: Column(
        children: [
          for (var i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      _photos[i]['url_m'].toString(),
                      semanticLabel: '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () async {
                          final response = await http
                              .get(Uri.parse(_photos[i]['url_k'].toString()));
                          final directory = await getTemporaryDirectory();
                          final path = directory.path;
                          final file = File('$path/spa.jpg');
                          await file.writeAsBytes(response.bodyBytes);
                          await Share.shareXFiles([XFile('$path/spa.jpg')]);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
