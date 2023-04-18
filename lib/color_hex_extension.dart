import 'dart:ui';

extension ColorHex on Color {
  static Color? fromHexString(String hexString) {
    //todo: what if bad hex string
    if (hexString.length >= 6) {
      if (hexString[0] == '#') {
        return Color(
            int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
      } else {
        return Color(
            int.parse(hexString.substring(0, 6), radix: 16) + 0xFF000000);
      }
    }
    return null;
  }

  String toHexString() {
    return value.toRadixString(16).substring(2);
  }
}
