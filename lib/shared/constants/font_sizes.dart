enum FontSize {
  small,
  medium,
  large
}

class AppFontSize {
  static const Map<FontSize, double> chatFontSize = {
    FontSize.small: 14.0,
    FontSize.medium: 16.0,
    FontSize.large: 18.0,
  };

  static const Map<FontSize, double> titleFontSize = {
    FontSize.small: 20.0,
    FontSize.medium: 24.0,
    FontSize.large: 28.0,
  };

  static const Map<FontSize, double> bodyFontSize = {
    FontSize.small: 12.0,
    FontSize.medium: 14.0,
    FontSize.large: 16.0,
  };

  static String getFontSizeName(FontSize size) {
    switch (size) {
      case FontSize.small:
        return '작게';
      case FontSize.medium:
        return '보통';
      case FontSize.large:
        return '크게';
    }
  }
}