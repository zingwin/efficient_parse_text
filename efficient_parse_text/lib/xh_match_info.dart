class XHMatchInfo {
  /// 匹配的类型
  final int matchType;

  /// 匹配结果在原字符串中的起始位置
  final int start;

  /// 匹配结果在原字符串中的结束位置
  final int end;

  /// 匹配结果
  final String value;

  XHMatchInfo({
    required this.matchType,
    required this.start,
    required this.end,
    required this.value,
  });
}
