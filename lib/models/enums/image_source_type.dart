enum ImageSourceType {
  camera,
  photoLibrary;

  // Helper methods
  String get title {
    switch (this) {
      case ImageSourceType.camera:
        return 'Camera';
      case ImageSourceType.photoLibrary:
        return 'Photo Library';
    }
  }

  String get description {
    switch (this) {
      case ImageSourceType.camera:
        return 'Take a new photo';
      case ImageSourceType.photoLibrary:
        return 'Choose from library';
    }
  }
}