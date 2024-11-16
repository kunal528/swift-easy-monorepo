extension doubleExtension on double {
  static const SGD_TO_USD_RATE = 0.012;
  static const AED_TO_USD_RATE = 1;
  static const SGD_TO_AED_RATE = 0.012;
  String toCurrency({required String countryCode}) {
    switch (countryCode) {
      case 'India':
      case "₹":
        return (this / SGD_TO_USD_RATE).toStringAsFixed(2);
      case 'US':
      case "\$":
        return (this / AED_TO_USD_RATE).toStringAsFixed(2);
      default:
        return toStringAsFixed(2);
    }
  }

  String toUSD({required String countryCode}) {
    switch (countryCode) {
      case 'India':
      case '₹':
        return (this * SGD_TO_USD_RATE).toStringAsFixed(2);
      case 'US':
      case '\$':
        return (this * AED_TO_USD_RATE).toStringAsFixed(2);
      default:
        return toStringAsFixed(2);
    }
  }

  String toAED() {
    return (this * SGD_TO_AED_RATE).toStringAsFixed(2);
  }

  String toSGD() {
    return (this / SGD_TO_AED_RATE).toStringAsFixed(2);
  }
}
