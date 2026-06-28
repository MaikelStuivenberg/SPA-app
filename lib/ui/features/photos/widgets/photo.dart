import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/ui/features/photos/widgets/download_button.dart';
import 'package:spa_app/ui/features/photos/widgets/send_button.dart';

String photoHeroTag(Photo photo) => 'photo-${photo.id}';

void showPhotoViewer(
  BuildContext context,
  Photo photo, {
  Future<void> Function(Photo photo, String userId)? onToggleLike,
}) {
  final scrimColor = context.appColors.scrim;
  PhotosCubit? photosCubit;
  try {
    photosCubit = context.read<PhotosCubit>();
  } on ProviderNotFoundException {
    photosCubit = null;
  }

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) {
      Widget overlay = PhotoViewerOverlay(
        photo: photo,
        routeAnimation: animation,
        onToggleLike: onToggleLike,
      );
      if (photosCubit != null) {
        overlay = BlocProvider<PhotosCubit>.value(
          value: photosCubit,
          child: overlay,
        );
      }
      return overlay;
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: ColoredBox(color: scrimColor),
          ),
          child,
        ],
      );
    },
  );
}

class PhotoViewerOverlay extends StatefulWidget {
  const PhotoViewerOverlay({
    required this.photo,
    required this.routeAnimation,
    this.onToggleLike,
    super.key,
  });

  final Photo photo;
  final Animation<double> routeAnimation;
  final Future<void> Function(Photo photo, String userId)? onToggleLike;

  @override
  State<PhotoViewerOverlay> createState() => _PhotoViewerOverlayState();
}

class _PhotoViewerOverlayState extends State<PhotoViewerOverlay> {
  double _dragOffset = 0;
  bool _isZoomed = false;

  void _close() {
    Navigator.of(context).pop();
  }

  void _onZoomChanged(bool isZoomed) {
    if (_isZoomed != isZoomed) {
      setState(() {
        _isZoomed = isZoomed;
        if (isZoomed) {
          _dragOffset = 0;
        }
      });
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomed) {
      return;
    }
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0, double.infinity);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed) {
      return;
    }
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset > 80 || velocity > 700) {
      _close();
      return;
    }
    setState(() => _dragOffset = 0);
  }

  Widget _buildPhotoContent() {
    return PhotoStateWidget(
      widget.photo,
      routeAnimation: widget.routeAnimation,
      onZoomChanged: _onZoomChanged,
      onToggleLike: widget.onToggleLike,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dragProgress = (_dragOffset / 200).clamp(0.0, 1.0);
    final chromeOpacity = CurvedAnimation(
      parent: widget.routeAnimation,
      curve: const Interval(0.4, 1, curve: Curves.easeOut),
    );

    final photoContent = Transform.translate(
      offset: Offset(0, _dragOffset),
      child: Opacity(
        opacity: 1 - dragProgress * 0.5,
        child: _buildPhotoContent(),
      ),
    );

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: FadeTransition(
              opacity: chromeOpacity,
              child: _PhotoCloseButton(onPressed: _close),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
              child: _isZoomed
                  ? photoContent
                  : GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      child: photoContent,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCloseButton extends StatelessWidget {
  const _PhotoCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.77),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed,
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        icon: Icon(Icons.close, color: colorScheme.onSurface),
      ),
    );
  }
}

class PhotoGridSkeleton extends StatefulWidget {
  const PhotoGridSkeleton({this.borderRadius = 4, super.key});

  final double borderRadius;

  @override
  State<PhotoGridSkeleton> createState() => _PhotoGridSkeletonState();
}

class _PhotoGridSkeletonState extends State<PhotoGridSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = colorScheme.surfaceContainerHighest;
    final highlight = colorScheme.surfaceContainerLow;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: ColoredBox(
            color: Color.lerp(base, highlight, _controller.value)!,
          ),
        );
      },
    );
  }
}

class PhotoGridThumbnail extends StatelessWidget {
  const PhotoGridThumbnail({
    required this.photo,
    this.borderRadius = 4,
    super.key,
  });

  final Photo photo;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photoHeroTag(photo),
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: photo.thumbnailUrl,
            cacheKey: photo.thumbnailUrl,
            fadeInDuration: Duration.zero,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorListener: (error) => const Center(
              child: Icon(Icons.error_outline),
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoStateWidget extends StatefulWidget {
  const PhotoStateWidget(
    this.photo, {
    this.routeAnimation,
    this.onZoomChanged,
    this.onToggleLike,
    super.key,
  });

  final Photo photo;
  final Animation<double>? routeAnimation;
  final ValueChanged<bool>? onZoomChanged;
  final Future<void> Function(Photo photo, String userId)? onToggleLike;

  @override
  State<PhotoStateWidget> createState() => _PhotoStateWidgetState();
}

class _PhotoStateWidgetState extends State<PhotoStateWidget> {
  bool _fullImageLoaded = false;
  bool _isZoomed = false;
  late Photo _displayPhoto;
  final TransformationController _zoomController = TransformationController();

  @override
  void initState() {
    super.initState();
    _displayPhoto = widget.photo;
    _zoomController.addListener(_handleZoomChanged);
  }

  @override
  void didUpdateWidget(covariant PhotoStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo.id != widget.photo.id) {
      _displayPhoto = widget.photo;
    }
  }

  @override
  void dispose() {
    _zoomController
      ..removeListener(_handleZoomChanged)
      ..dispose();
    super.dispose();
  }

  void _handleZoomChanged() {
    final scale = _zoomController.value.getMaxScaleOnAxis();
    final isZoomed = scale > 1.01;
    if (isZoomed == _isZoomed) {
      return;
    }
    setState(() => _isZoomed = isZoomed);
    widget.onZoomChanged?.call(isZoomed);
  }

  void _onFullImageLoaded() {
    if (_fullImageLoaded) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _fullImageLoaded = true);
      }
    });
  }

  Widget _buildPhotoImage({
    required Photo displayPhoto,
    required double width,
    required double height,
  }) {
    return CachedNetworkImage(
      imageUrl: displayPhoto.url,
      fit: BoxFit.contain,
      width: width,
      height: height,
      cacheKey: displayPhoto.url,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (context, url) => CachedNetworkImage(
        imageUrl: displayPhoto.thumbnailUrl,
        cacheKey: displayPhoto.thumbnailUrl,
        fit: BoxFit.contain,
        width: width,
        height: height,
        fadeInDuration: Duration.zero,
        errorListener: (error) => const Center(
          child: Icon(Icons.error_outline),
        ),
      ),
      imageBuilder: (context, imageProvider) {
        _onFullImageLoaded();
        return Image(
          image: imageProvider,
          fit: BoxFit.contain,
          width: width,
          height: height,
        );
      },
      errorWidget: (context, url, error) {
        _onFullImageLoaded();
        return CachedNetworkImage(
          imageUrl: displayPhoto.thumbnailUrl,
          cacheKey: displayPhoto.thumbnailUrl,
          fit: BoxFit.contain,
          width: width,
          height: height,
          fadeInDuration: Duration.zero,
          errorListener: (_) => const Center(
            child: Icon(Icons.error_outline),
          ),
        );
      },
    );
  }

  Future<void> _handleToggleLike(Photo photo, String userId) async {
    PhotosCubit? photosCubit;
    try {
      photosCubit = context.read<PhotosCubit>();
    } on ProviderNotFoundException {
      photosCubit = null;
    }

    if (photosCubit != null) {
      await photosCubit.toggleLike(photo: photo, userId: userId);
      return;
    }

    if (widget.onToggleLike == null) return;

    await widget.onToggleLike!(photo, userId);
    if (!mounted) return;

    final isLiked = photo.likedBy.contains(userId);
    final likedBy = List<String>.from(photo.likedBy);
    if (isLiked) {
      likedBy.remove(userId);
    } else {
      likedBy.add(userId);
    }

    setState(() {
      _displayPhoto = photo.copyWith(
        likes: isLiked ? photo.likes - 1 : photo.likes + 1,
        likedBy: likedBy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthStateSuccess) {
          return const SizedBox.shrink();
        }

        final currentUser = state.user;
        final colorScheme = Theme.of(context).colorScheme;
        final appColors = context.appColors;

        PhotosCubit? photosCubit;
        try {
          photosCubit = context.read<PhotosCubit>();
        } on ProviderNotFoundException {
          photosCubit = null;
        }

        final displayPhoto = photosCubit != null
            ? context.select<PhotosCubit, Photo>((cubit) {
                return cubit.state.photos?.firstWhere(
                      (item) => item.id == widget.photo.id,
                      orElse: () => widget.photo,
                    ) ??
                    widget.photo;
              })
            : _displayPhoto;

        final actions = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: colorScheme.surface.withValues(alpha: 0.77),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _handleToggleLike(displayPhoto, currentUser.id!);
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      displayPhoto.likedBy.contains(currentUser.id)
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: displayPhoto.likedBy.contains(currentUser.id)
                          ? appColors.favorite
                          : colorScheme.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Text(displayPhoto.likes.toString()),
                  ],
                ),
              ),
              DownloadButton(photo: displayPhoto),
              SendButton(photo: displayPhoto),
            ],
          ),
        );

        Widget actionsBar = actions;
        if (widget.routeAnimation != null) {
          actionsBar = FadeTransition(
            opacity: CurvedAnimation(
              parent: widget.routeAnimation!,
              curve: const Interval(
                0.4,
                1,
                curve: Curves.easeOut,
              ),
            ),
            child: actions,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: LayoutBuilder(
                      builder: (context, imageConstraints) {
                        final imageWidth = constraints.maxWidth;
                        final imageHeight = imageConstraints.maxHeight;

                        return InteractiveViewer(
                          transformationController: _zoomController,
                          minScale: 1,
                          maxScale: 4,
                          panEnabled: _isZoomed,
                          clipBehavior: Clip.none,
                          child: Hero(
                            tag: photoHeroTag(displayPhoto),
                            child: Material(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _buildPhotoImage(
                                  displayPhoto: displayPhoto,
                                  width: imageWidth,
                                  height: imageHeight,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,
                    child: _fullImageLoaded
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 12),
                              actionsBar,
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
