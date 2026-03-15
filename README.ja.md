# moyo
geometricパターンを描画するためのSVG.jsエクステンション。

## デモ
[ES-Jamでデモを編集できます](https://ss.sabae.cc/#504)。

## 機能
- 菱形のペンローズタイリングの生成
- 種類: 菱形、菱形のみ、凧と矢羽、凧と矢羽のみ、凧と矢羽の混合、オリジナル
- 膨張率の調整 (3~10)
- リムのスタイル: クリップ、減算、加算

## 使い方
```html
<div id=svg></div>
<script type="module">
import SVG from "https://code4fukui.github.io/svg-es/SVG@2.7.1.js";
import moyo from "https://code4fukui.github.io/moyo/penrose.js";

moyo(SVG);

const draw = SVG("svg").size(600, 500); // svgjs 2.7 style
draw.penrose(600, { type: "rhombus" });  // 現在のところ "rhombus" のみ対応
</script>
```

## ライセンス
このプロジェクトは[ISCライセンス](https://github.com/code4fukui/moyo/blob/main/LICENSE)の下で公開されています。