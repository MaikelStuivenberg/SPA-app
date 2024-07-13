import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/routes.dart';
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
          return Expanded(
            child: CardWidget(
              height: 200,
              child: Container(),
            ),
          );
        }

        if (state.photos == null || state.photos!.isEmpty) {
          return Container();
        }

        return Expanded(
          child: CardWidget(
            padding: 0,
            height: 200,
            onTap: () {
              Navigator.pushNamed(context, Routes.photos);
            },
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
