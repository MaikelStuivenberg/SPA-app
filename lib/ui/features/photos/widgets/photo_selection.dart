import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/data/services/photo_file_service.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/app_shell.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/ui/features/photos/widgets/photo.dart';

class PhotoSelectionState {
  const PhotoSelectionState({
    this.isActive = false,
    this.selectedIds = const {},
  });

  final bool isActive;
  final Set<String> selectedIds;

  PhotoSelectionState copyWith({
    bool? isActive,
    Set<String>? selectedIds,
  }) {
    return PhotoSelectionState(
      isActive: isActive ?? this.isActive,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  bool isSelected(String photoId) => selectedIds.contains(photoId);
}

class SelectablePhotoGrid extends StatefulWidget {
  const SelectablePhotoGrid({
    required this.photos,
    required this.gridDelegate,
    required this.onBulkLike,
    this.controller,
    this.itemCount,
    this.extraItemBuilder,
    this.showLikeBadge = false,
    this.likeActionIcon = FontAwesomeIcons.heart,
    this.likeActionTooltip,
    this.floatAboveShellNavigation = false,
    this.onViewerToggleLike,
    super.key,
  });

  final List<Photo> photos;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final int? itemCount;
  final Widget Function(BuildContext context, int index)? extraItemBuilder;
  final bool showLikeBadge;
  final IconData likeActionIcon;
  final String? likeActionTooltip;
  final bool floatAboveShellNavigation;
  final Future<void> Function(List<Photo> photos) onBulkLike;
  final Future<void> Function(Photo photo, String userId)? onViewerToggleLike;

  @override
  State<SelectablePhotoGrid> createState() => _SelectablePhotoGridState();
}

class _SelectablePhotoGridState extends State<SelectablePhotoGrid> {
  PhotoSelectionState _selection = const PhotoSelectionState();
  bool _isProcessing = false;

  int get _itemCount => widget.itemCount ?? widget.photos.length;

  List<Photo> get _selectedPhotos {
    return widget.photos
        .where((photo) => _selection.selectedIds.contains(photo.id))
        .toList();
  }

  void _startSelection(String photoId) {
    setState(() {
      _selection = PhotoSelectionState(
        isActive: true,
        selectedIds: {photoId},
      );
    });
  }

  void _toggleSelection(String photoId) {
    final selectedIds = Set<String>.from(_selection.selectedIds);
    if (selectedIds.contains(photoId)) {
      selectedIds.remove(photoId);
    } else {
      selectedIds.add(photoId);
    }

    if (selectedIds.isEmpty) {
      _clearSelection();
      return;
    }

    setState(() {
      _selection = _selection.copyWith(selectedIds: selectedIds);
    });
  }

  void _clearSelection() {
    setState(() => _selection = const PhotoSelectionState());
  }

  void _onPhotoTap(Photo photo) {
    if (_selection.isActive) {
      _toggleSelection(photo.id);
    } else {
      showPhotoViewer(
        context,
        photo,
        onToggleLike: widget.onViewerToggleLike,
      );
    }
  }

  Future<void> _runBulkAction(Future<void> Function() action) async {
    if (_isProcessing || _selectedPhotos.isEmpty) return;

    setState(() => _isProcessing = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        _clearSelection();
      }
    }
  }

  Future<void> _bulkLike() async {
    await _runBulkAction(() => widget.onBulkLike(_selectedPhotos));
  }

  Future<void> _bulkDownload() async {
    final l10n = AppLocalizations.of(context)!;

    await _runBulkAction(() async {
      final saved =
          await getIt<PhotoFileService>().saveMultipleToDownloads(_selectedPhotos);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoBulkDownloadSuccess(saved))),
      );
    });
  }

  Future<void> _bulkSend() async {
    await _runBulkAction(
      () => getIt<PhotoFileService>().shareMultiple(_selectedPhotos),
    );
  }

  double _bottomBarOffset(BuildContext context) {
    const spacing = 8.0;
    if (!widget.floatAboveShellNavigation) {
      return spacing + MediaQuery.paddingOf(context).bottom;
    }
    return spacing + AppShell.bottomNavigationClearance(context);
  }

  double _selectionScrollPadding(BuildContext context) {
    return _bottomBarOffset(context) + 52;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Stack(
      children: [
        GridView.builder(
          controller: widget.controller,
          padding: EdgeInsets.only(
            bottom: _selection.isActive ? _selectionScrollPadding(context) : 0,
          ),
          gridDelegate: widget.gridDelegate,
          itemCount: _itemCount,
          itemBuilder: (context, index) {
            if (index >= widget.photos.length) {
              return widget.extraItemBuilder?.call(context, index) ??
                  const SizedBox.shrink();
            }

            final photo = widget.photos[index];
            final isSelected = _selection.isSelected(photo.id);

            return GestureDetector(
              onTap: () => _onPhotoTap(photo),
              onLongPress: () {
                if (_selection.isActive) {
                  _toggleSelection(photo.id);
                } else {
                  _startSelection(photo.id);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoGridThumbnail(photo: photo),
                  if (widget.showLikeBadge)
                    Positioned(
                      left: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.scrim.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: appColors.favorite,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              photo.likes.toString(),
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_selection.isActive)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.25)
                            : appColors.scrim.withValues(alpha: 0.35),
                      ),
                    ),
                  if (_selection.isActive && isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (_selection.isActive)
          Positioned(
            left: 16,
            right: 16,
            bottom: _bottomBarOffset(context),
            child: PhotoBulkActionsBar(
              selectedCount: _selection.selectedIds.length,
              isProcessing: _isProcessing,
              likeIcon: widget.likeActionIcon,
              likeTooltip: widget.likeActionTooltip,
              onCancel: _clearSelection,
              onLike: _bulkLike,
              onDownload: _bulkDownload,
              onSend: _bulkSend,
            ),
          ),
      ],
    );
  }
}

class PhotoBulkActionsBar extends StatelessWidget {
  const PhotoBulkActionsBar({
    required this.selectedCount,
    required this.isProcessing,
    required this.likeIcon,
    required this.onCancel,
    required this.onLike,
    required this.onDownload,
    required this.onSend,
    this.likeTooltip,
    super.key,
  });

  final int selectedCount;
  final bool isProcessing;
  final IconData likeIcon;
  final String? likeTooltip;
  final VoidCallback onCancel;
  final VoidCallback onLike;
  final VoidCallback onDownload;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(32),
      color: colorScheme.surface.withValues(alpha: 0.95),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: isProcessing ? null : onCancel,
              tooltip: l10n.photoSelectionCancel,
              icon: Icon(Icons.close, color: colorScheme.onSurface),
            ),
            Expanded(
              child: Text(
                l10n.photoSelectionCount(selectedCount),
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isProcessing)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else ...[
              IconButton(
                onPressed: onLike,
                tooltip: likeTooltip ?? l10n.photoSelectionLike,
                icon: FaIcon(likeIcon, color: appColors.favorite),
              ),
              IconButton(
                onPressed: onDownload,
                tooltip: l10n.photoSelectionDownload,
                icon: Icon(Icons.download, color: colorScheme.onSurface),
              ),
              IconButton(
                onPressed: onSend,
                tooltip: l10n.photoSelectionSend,
                icon: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> bulkToggleLikePhotos(
  BuildContext context,
  List<Photo> photos,
) async {
  final authState = context.read<AuthCubit>().state;
  if (authState is! AuthStateSuccess || authState.user.id == null) return;

  await context.read<PhotosCubit>().toggleLikeMultiple(
        photos: photos,
        userId: authState.user.id!,
      );
}
