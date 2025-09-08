import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Shows a modal bottom sheet to select an image source (camera or gallery).
/// Returns the selected [ImageSource] or null if no source is selected.
Future<ImageSource?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(sheetContext.S.camera),
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(sheetContext.S.gallery),
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}
