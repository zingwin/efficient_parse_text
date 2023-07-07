import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';
import 'xh_highlight_match.dart';
import 'xh_match_info.dart';

class XHHighlightMatchCore {
  /// 需要正则匹配列表
  final List<XHHighlightMatch> matchList;

  /// 不匹配样式
  final XHHighlightMatch unMatch;

  /// 需要匹配的数组转为字典，方便内部使用
  final Map<int, XHHighlightMatch> _toMatchMap = {};

  /// 构造方法
  XHHighlightMatchCore({required this.matchList, required this.unMatch}) {
    for (XHHighlightMatch item in matchList) {
      if (item.matchReg() != null) {
        _toMatchMap.putIfAbsent(item.matchType, () => item);
      }
    }
  }

  List<XHMatchInfo> startMatch(String target) {
    StringScanner scanner = StringScanner(target);

    List<XHHighlightMatch> rules = _toMatchMap.values.toList();
    List<int> types = _toMatchMap.keys.toList();
    List<XHMatchInfo> tmpMatchList = [];

    while (!scanner.isDone) {
      bool hasMatch = false;
      for (int i = 0; i < rules.length; i++) {
        if (scanner.scan(rules[i].matchReg()!)) {
          Match? match = scanner.lastMatch;
          if (match != null) {
            tmpMatchList.add(XHMatchInfo(
              matchType: types[i],
              start: match.start,
              end: match.end,
              value: match.group(0) ?? '',
            ));
          }
          hasMatch = true;
          break;
        }
      }
      if (scanner.isDone) break;
      if (!hasMatch) scanner.position++;
    }

    List<XHMatchInfo> allMatchList = [];
    int cursor = 0;
    if (tmpMatchList.isEmpty) {
      return [
        XHMatchInfo(
            matchType: unMatch.matchType,
            start: cursor,
            end: target.length - 1,
            value: target.substring(cursor))
      ];
    }

    for (int i = 0; i < tmpMatchList.length; i++) {
      XHMatchInfo match = tmpMatchList[i];
      if (cursor != match.start) {
        allMatchList.add(XHMatchInfo(
            matchType: unMatch.matchType,
            start: cursor,
            end: match.start,
            value: target.substring(cursor, match.start)));
      }
      allMatchList.add(match);
      cursor = match.end;
    }
    if (cursor != target.length - 1) {
      allMatchList.add(XHMatchInfo(
          matchType: unMatch.matchType,
          start: cursor,
          end: target.length - 1,
          value: target.substring(cursor)));
    }
    return allMatchList;
  }

  List<InlineSpan> generateTextInlineSpans(List<XHMatchInfo> infoList) {
    List<InlineSpan> span = [];
    for (int i = 0; i < infoList.length; i++) {
      XHMatchInfo match = infoList[i];
      if (_toMatchMap.containsKey(match.matchType)) {
        span.add(_toMatchMap[match.matchType]!.matchBuilder(match));
      } else {
        span.add(unMatch.matchBuilder(match));
      }
    }
    return span;
  }

  List<InlineSpan> matchThenGenInlineSpan(String target) {
    final infoList = startMatch(target);
    return generateTextInlineSpans(infoList);
  }
}
