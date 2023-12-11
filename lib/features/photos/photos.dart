import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  PhotosPageState createState() => PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> {
  List<dynamic> _photos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _getRecentImagesInAlbum();
  }

  Future<void> _getRecentImagesInAlbum() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final minUploadDate = remoteConfig.getInt('flickr_min_upload_date');
    final maxUploadDate = remoteConfig.getInt('flickr_max_upload_date');
    final photosPerPage = remoteConfig.getInt('show_photos_per_page');

    const apiKey = '639f377344ffa79f1f0ebc8349dbae6f';
    const userId = '195851792@N04';

    var url = 'https://www.flickr.com/services/rest/';
    url += '?method=flickr.people.getPhotos&api_key=$apiKey';
    url += '&user_id=$userId&extras=url_m,date_taken';
    url += '&sort=date-taken-desc&min_upload_date=$minUploadDate';
    url += '&max_upload_date=$maxUploadDate';
    url += '&per_page=$photosPerPage&format=json';
    url += '&nojsoncallback=1&extras=url_m,url_k';

    final response = await http.get(Uri.parse(url));
    loading = false;
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _photos = data['photos']['photo'] as List<dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.photoTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(child: _buildPhotoGrid()),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final albumId = FirebaseRemoteConfig.instance
                        .getString('flickr_album_id');
                    final url =
                        'https://www.flickr.com/photos/salvationarmyyouthnl/albums/$albumId/';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.photoSeeAll,
                  ),
                ),
              ),
              Container(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
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
          : Text(
              loading
                  ? 'Even geduld..'
                  : "We zijn druk bezig met het maken van foto's van dit jaar! Check later nog eens. :)",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }

  Widget _buildPhotoGridRow() {
    return Expanded(
      child: Column(
        children: [
          for (var i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
