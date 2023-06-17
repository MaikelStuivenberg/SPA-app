import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        'https://www.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=$apiKey&user_id=$userId&extras=url_m,date_taken&sort=date-taken-desc&per_page=10&format=json&nojsoncallback=1';

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
            const Text(
              "Meest recente foto's",
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
              child: const Text('Bekijk alles', style: Styles.buttonText),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: _photos.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPhotoGridRow([
                          _photos[0],
                          _photos[2],
                          _photos[4],
                          _photos[6],
                          _photos[8]
                        ]),
                        _buildPhotoGridRow([
                          _photos[1],
                          _photos[3],
                          _photos[5],
                          _photos[7],
                          _photos[9]
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Text(''),
    );
  }

  Widget _buildPhotoGridRow(List<dynamic> sublist) {
    final photoWidth = ((MediaQuery.of(context).size.width - 32.0) / 2.0) - 8.0;
    return Column(
      children: [
        for (var i = 0; i < sublist.length; i++)
          Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                sublist[i]['url_m'].toString(),
                semanticLabel: '',
                fit: BoxFit.cover,
                width: photoWidth,
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error_outline),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
