import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';

class PhotoStateWidget extends StatefulWidget {
  const PhotoStateWidget(this.photo, {super.key});

  final Photo photo;

  @override
  PhotoStateWidgetState createState() => PhotoStateWidgetState();
}

class PhotoStateWidgetState extends State<PhotoStateWidget> {
  final photoDataRepository = PhotoDataRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: widget.photo.thumbnailUrl,
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
                errorListener: (error) => const Center(
                  child: Icon(Icons.error_outline),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color.fromARGB(196, 255, 255, 255),
                ),
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    // IconButton(
                    //   onPressed: () async {
                    //     // Like photo
                    //     if (!widget.photo.likedBy
                    //         .contains(widget.currentUser.id)) {
                    //       await photoDataRepository.addLike(widget.photo.id);
                    //       setState(() {
                    //         widget.photo.likedBy
                    //             .add(widget.currentUser.id.toString());
                    //         widget.photo.likes++;
                    //       });
                    //     } else {
                    //       await photoDataRepository.removeLike(widget.photo.id);
                    //       setState(() {
                    //         widget.photo.likedBy
                    //             .remove(widget.currentUser.id.toString());
                    //         widget.photo.likes--;
                    //       });
                    //     }
                    //   },
                    //   icon: Column(
                    //     children: [
                    //       Icon(
                    //         widget.photo.likedBy.contains(widget.currentUser.id)
                    //             ? FontAwesomeIcons.solidHeart
                    //             : FontAwesomeIcons.heart,
                    //         color: widget.photo.likedBy
                    //                 .contains(widget.currentUser.id)
                    //             ? Colors.red
                    //             : Colors.black,
                    //       ),
                    //       Text(widget.photo.likes.toString()),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        final response =
                            await http.get(Uri.parse(widget.photo.url));
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
