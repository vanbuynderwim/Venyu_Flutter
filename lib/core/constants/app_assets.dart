class AppAssets {
  static const _images = _Images();
  static const _icons = _Icons();
  
  static _Images get images => _images;
  static _Icons get icons => _icons;
}

class _Images {
  const _Images();
  // Add other image assets here if needed
}

class _Icons {
  const _Icons();
  
  // Icon base classes
  final blocked = const _IconVariants('blocked');
  final bulb = const _IconVariants('bulb');
  final card = const _IconVariants('card');
  final chevron = const _IconVariants('chevron');
  final company = const _IconVariants('company');
  final delete = const _IconVariants('delete');
  final edit = const _IconVariants('edit');
  final email = const _IconVariants('email');
  final filter = const _IconVariants('filter');
  final handshake = const _IconVariants('handshake');
  final image = const _IconVariants('image');
  final link = const _IconVariants('link');
  final location = const _IconVariants('location');
  final match = const _IconVariants('match');
  final notification = const _IconVariants('notification');
  final profile = const _IconVariants('profile');
  final report = const _IconVariants('report');
  final settings = const _IconVariants('settings');
  final venue = const _IconVariants('venue');
  final verified = const _IconVariants('verified');
  
  // Special checkbox icons (only have 3 variants)
  final checkboxOff = const _CheckboxVariants('checkbox_off');
  final checkboxOn = const _CheckboxVariants('checkbox_on');
  
  // Special radiobutton icons (only have 3 variants)
  final radiobuttonOff = const _RadiobuttonVariants('radiobutton_off');
  final radiobuttonOn = const _RadiobuttonVariants('radiobutton_on');
}

class _IconVariants {
  const _IconVariants(this.baseName);
  
  final String baseName;
  static const String _basePath = 'assets/images/icons';
  
  String get regular => '$_basePath/${baseName}_regular.png';
  String get outlined => '$_basePath/${baseName}_outlined.png';
  String get selected => '$_basePath/${baseName}_selected.png';
  String get accent => '$_basePath/${baseName}_accent.png';
  String get white => '$_basePath/${baseName}_white.png';
}

class _CheckboxVariants {
  const _CheckboxVariants(this.baseName);
  
  final String baseName;
  static const String _basePath = 'assets/images/icons';
  
  String get regular => '$_basePath/${baseName}_regular.png';
  String get outlined => '$_basePath/${baseName}_outlined.png';
  String get white => '$_basePath/${baseName}_white.png';
  String get accent => '$_basePath/${baseName}_accent.png';
  String get selected => '$_basePath/${baseName}_selected.png';
}

class _RadiobuttonVariants {
  const _RadiobuttonVariants(this.baseName);
  
  final String baseName;
  static const String _basePath = 'assets/images/icons';
  
  String get regular => '$_basePath/${baseName}_regular.png';
  String get outlined => '$_basePath/${baseName}_outlined.png';
  String get white => '$_basePath/${baseName}_white.png';
  String get accent => '$_basePath/${baseName}_accent.png';
  String get selected => '$_basePath/${baseName}_selected.png';
}