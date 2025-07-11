import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/features/photos/widgets/download_button.dart';
import 'package:spa_app/features/photos/widgets/send_button.dart';
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
    return BlocBuilder(
      bloc: BlocProvider.of<AuthCubit>(context),
      builder: (context, state) {
        final currentUser = (state! as AuthStateSuccess).user;

        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.photo.thumbnailUrl,
                  fit: BoxFit.cover,
                  cacheKey: widget.photo.thumbnailUrl,
                  fadeInDuration: Duration.zero,
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
                      IconButton(
                        onPressed: () async {
                          // Like photo
                          if (!widget.photo.likedBy.contains(currentUser.id)) {
                            await photoDataRepository.addLike(widget.photo.id);
                            setState(() {
                              widget.photo.likedBy
                                  .add(currentUser.id.toString());
                              widget.photo.likes++;
                            });
                          } else {
                            await photoDataRepository
                                .removeLike(widget.photo.id);
                            setState(() {
                              widget.photo.likedBy
                                  .remove(currentUser.id.toString());
                              widget.photo.likes--;
                            });
                          }
                        },
                        icon: Column(
                          children: [
                            Icon(
                              widget.photo.likedBy.contains(currentUser.id)
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              color:
                                  widget.photo.likedBy.contains(currentUser.id)
                                      ? Colors.red
                                      : Colors.black,
                            ),
                            Text(widget.photo.likes.toString()),
                          ],
                        ),
                      ),
                      DownloadButton(widget: widget),
                      SendButton(widget: widget),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
