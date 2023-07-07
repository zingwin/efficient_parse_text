import 'package:efficient_parse_text/efficient_parse_text.dart';
import 'package:flutter/material.dart';

import 'text_match_types.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本高亮解析',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '文本高亮解析'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final matchManager = XHHighlightMatchCore(matchList: [
  EmailMatch(),
  EmoMatch(),
  URLMatch(),
], unMatch: HighlightUnMatch());

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  children: matchManager.matchThenGenInlineSpan(
                      "你好[爱心][呲牙] 看链接 https://mp.weixin.qq.com 邮箱地址: leaf@test.com;"))),
          const Divider(),
          RichText(
              text: TextSpan(
                  children: matchManager.matchThenGenInlineSpan(
                      "你好[你好]https://www.baidu.com;llll"))),
          const Divider(),
          RichText(
              text: TextSpan(
                  children: matchManager.matchThenGenInlineSpan("[你好]z[笑脸]l"))),
          const Divider(),
          RichText(
              text: TextSpan(
                  children: matchManager.matchThenGenInlineSpan(
                      "Flutter调优工具使用及Flutter高性能编程部分要点分析:https://juejin.cn/post/7157905466821967902"))),
          const Divider(),
          RichText(
              text:
                  TextSpan(children: matchManager.matchThenGenInlineSpan("L"))),
          const Divider(),
          RichText(
              text: TextSpan(
                  children: matchManager.matchThenGenInlineSpan("leaf"))),
          const Divider(),
        ],
      ),
    );
  }
}
