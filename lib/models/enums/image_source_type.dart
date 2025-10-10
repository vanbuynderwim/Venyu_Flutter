import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

enum ImageSourceType {
  camera,
  photoLibrary;

  // Helper methods
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ImageSourceType.camera:
        return l10n.imageSourceCameraTitle;
      case ImageSourceType.photoLibrary:
        return l10n.imageSourcePhotoLibraryTitle;
    }
  }

  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ImageSourceType.camera:
        return l10n.imageSourceCameraDescription;
      case ImageSourceType.photoLibrary:
        return l10n.imageSourcePhotoLibraryDescription;
    }
  }
}