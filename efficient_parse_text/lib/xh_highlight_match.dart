import 'package:flutter/material.dart';
import 'xh_match_info.dart';

abstract class XHHighlightMatch {
  /// 匹配组件生成器
  InlineSpan matchBuilder(XHMatchInfo matchInfo);

  /// 匹配正则，不匹配返回null
  Pattern? matchReg();

  /// 匹配类型，不同的匹配需要保证唯一值
  int get matchType;
}
