
### 细节文档
[中文教程](https://juejin.cn/post/7206219564090097719)

### 使用！
使用其实就是实现之前定义的抽象类接口。
#### 1. 不匹配默认样式
这个很好理解，就是不匹配的文本展示样式，这个是必须实现的。
```
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
```
#### 2. 匹配链接
```
class URLMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: GestureDetector(
          onTap: () {
            print('to open url: ${matchInfo.value}');
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
        r"(http(s)?)://[a-zA-Z\d@:._+~#=-]{1,256}.[a-z\d]{2,18}\b([-a-zA-Z\d!@:_+.~#?&/=%,$]*)(?<![$])");
  }

  @override
  int get matchType => 2;
}
```
#### 3. 匹配邮箱地址
```
class EmailMatch extends XHHighlightMatch {
  @override
  InlineSpan matchBuilder(XHMatchInfo matchInfo) {
    return (TextSpan(
        text: matchInfo.value,
        style: const TextStyle(color: Colors.pink, fontSize: 16)));
  }

  @override
  Pattern? matchReg() {
    return RegExp(r"\b[\w.-]+@[\w.-]+.\w{2,4}\b");
  }

  @override
  int get matchType => 3;
}
```
#### 4. 匹配表情
```
class EmoMatch extends XHHighlightMatch {
 ...
}
```

#### 5. 初始化解析器
前面实现了3种匹配对象和1种不匹配对象， 如果你需要再匹配其他的类型，按照相同的方法添加就行了。是不是很简单！
```
final matchManager = HighlightMatchManager(matchList: [
  EmailMatch(),
  EmoMatch(),
  URLMatch(),
], unMatch: HighlightUnMatch());
```

#### 6.创建组件
```
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
          text: TextSpan(
              children: matchManager.matchThenGenInlineSpan(
                  "@!280849192149057536你好[爱心][呲牙] 看链接 https://mp.weixin.qq.com 邮箱地址: leaf@test.com"))),
      RichText(
          text: TextSpan(
              children: matchManager.matchThenGenInlineSpan("[你好][笑脸]")))
    ],
  );
}
```
效果图

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7195f6bae52d4d818214c37b537022bf~tplv-k3u1fbpfcp-watermark.image?)


