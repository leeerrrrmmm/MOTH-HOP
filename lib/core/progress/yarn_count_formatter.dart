class YarnCountFormatter {
  const YarnCountFormatter._();

  static String format(int count) {
    if (count <= 100) return '$count';
    if (count < 10000) return '1к';
    if (count < 100000) return '10к';
    return '100к';
  }
}
