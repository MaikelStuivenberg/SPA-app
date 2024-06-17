import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/shared/widgets/card.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosCubit, PhotosState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        if (state.photos == null || state.photos!.isEmpty) {
          return const Text('No photos found');
        }

        return Expanded(
          child: CardWidget(
            padding: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: state.photos!.first.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
