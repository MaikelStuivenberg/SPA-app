import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Picks a gallery image and compresses it for use as a profile photo.
Future<Uint8List?> pickAndCompressProfileImage() async {
  final value = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (value == null) return null;

  return FlutterImageCompress.compressWithFile(
    value.path,
    quality: 80,
    minWidth: 1440,
    minHeight: 810,
  );
}

/// Circular avatar with a camera button for profile photo selection.
class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    required this.foregroundImage,
    required this.onPickPressed,
    this.size = 96,
    this.heroTag,
    super.key,
  });

  final ImageProvider<Object>? foregroundImage;
  final VoidCallback onPickPressed;
  final double size;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final avatar = CircleAvatar(
      backgroundColor: Colors.transparent,
      foregroundImage: foregroundImage ??
          const AssetImage('assets/profile_default.jpg') as ImageProvider<Object>,
    );

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          if (heroTag != null)
            Hero(
              transitionOnUserGestures: true,
              tag: heroTag!,
              child: avatar,
            )
          else
            avatar,
          Positioned(
            bottom: 0,
            right: -size * 0.26,
            child: RawMaterialButton(
              onPressed: onPickPressed,
              fillColor: colorScheme.primary,
              shape: const CircleBorder(),
              child: Icon(
                Icons.camera_alt_outlined,
                color: colorScheme.onPrimary,
                size: size * 0.21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
