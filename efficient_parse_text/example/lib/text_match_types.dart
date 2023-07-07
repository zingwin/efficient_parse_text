import 'package:efficient_parse_text/xh_highlight_match.dart';
import 'package:efficient_parse_text/xh_match_info.dart';
import 'package:flutter/material.dart';

import 'main.dart';

/// 默认样式，不需要解析的文本
class HighlightUnMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    return TextSpan(
        text: matchInfo.value,
        style: const TextStyle(fontSize: 16, color: Colors.black));
  }

  @override
  Pattern? matchReg() {
    return null;
  }

  @override
  int get matchType => -1;
}

///表情解析
class EmoMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    String? asset; //allEmoMap[matchText!];
    return WidgetSpan(
        alignment: PlaceholderAlignment.bottom,
        child: GestureDetector(
            onTap: () {
              showDialog(
                  context: navigatorKey.currentState!.context,
                  barrierDismissible: false,
                  builder: (c) {
                    return AlertDialog(
                      title: Text(
                        "点击了表情： ${matchInfo.value}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(c).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  });
            },
            child: asset == null
                ? Text(matchInfo.value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple))
                : Image.asset(
                    asset,
                    width: 14,
                    height: 14,
                  )));
  }

  @override
  Pattern? matchReg() {
    return RegExp(r"\[(.*?)\]");
  }

  @override
  int get matchType => 1;
}

///链接解析
class URLMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: GestureDetector(
          onTap: () {
            showDialog(
                context: navigatorKey.currentState!.context,
                barrierDismissible: false,
                builder: (c) {
                  return AlertDialog(
                    title: Text(
                      "点击了链接： ${matchInfo.value}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(c).pop();
                          },
                          child: const Text("OK"))
                    ],
                  );
                });
          },
          child: Text(
            matchInfo.value,
            style: const TextStyle(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }

  @override
  Pattern? matchReg() {
    return RegExp(
        r"(http(s)?)://[a-zA-Z\d@:._+~#=-]{1,256}\.[a-z\d]{2,18}\b([-a-zA-Z\d!@:_+.~#?&/=%,$]*)(?<![$])");
  }

  @override
  int get matchType => 2;
}

/// 邮箱解析
class EmailMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    return (TextSpan(
        text: matchInfo.value,
        style: const TextStyle(color: Colors.pink, fontSize: 16)));
  }

  @override
  Pattern? matchReg() {
    return RegExp(r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b");
  }

  @override
  int get matchType => 3;
}
