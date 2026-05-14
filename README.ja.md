# moyo


[SVG.js](http://svgjs.com) 用の幾何学的パターンジェネレーターで、ペンローズタイルを生成します。

このプロジェクトは [yucho/moyo](https://github.com/yucho/moyo) のフォークであり、ESモジュールとして動作するように調整されています。

## ライブデモ

[ES-Jam](https://ss.sabae.cc/#504) にて、オプションをライブで試すことができます。

## 機能

*   **ペンローズタイル**: P2（菱形）タイルを生成します。
*   **インフレーション制御**: `inflation` オプションでパターンの複雑さを調整できます（例: 3-10）。
*   **リムスタイル**: `clip`、`subtractive`、`additive` のいずれかのスタイルで、パターンの縁（エッジ）のレンダリングを制御します。
*   **カスタムカラー**: 2種類の菱形の塗りつぶし色を簡単に指定できます。

## 使い方

HTMLファイルにSVG.jsとmoyoモジュールを読み込みます。

```html
<div id="svg"></div>
<script type="module">
import SVG from "https://code4fukui.github.io/svg-es/SVG@2.7.1.js";
import moyo from "https://code4fukui.github.io/moyo/penrose.js";

// SVG.jsをmoyoプラグインで拡張
moyo(SVG);

// SVGキャンバスを作成
const draw = SVG("svg").size(600, 500);

// 基本的なペンローズタイルを生成
draw.penrose(600, { type: "rhombus", inflation: 5, rim: "clip" });
</script>
```

### 高度な使い方

「太い」菱形と「細い」菱形の塗りつぶし色をカスタマイズするために、追加のオブジェクトを渡すことができます。

```javascript
// カスタムカラーの例
draw.penrose(
  600,
  { type: "rhombus", inflation: 5, rim: "clip" },
  { fill: "hsl(30 90% 30%)" },  // 「太い」菱形のスタイル
  { fill: "hsl(80 90% 30%)" }   // 「細い」菱形のスタイル
);
```

## API

### `draw.penrose(size, options, [fatRhombusAttrs], [thinRhombusAttrs])`

| パラメーター          | 型       | 説明                                                         |
| ------------------- | -------- | ------------------------------------------------------------ |
| `size`              | `Number` | タイリングのおおよそのサイズ（ピクセル単位）。               |
| `options`           | `Object` | 設定プロパティを含むオブジェクト。                           |
| `fatRhombusAttrs`   | `Object` | （オプション）「太い」菱形タイルのSVG.js属性。               |
| `thinRhombusAttrs`  | `Object` | （オプション）「細い」菱形タイルのSVG.js属性。               |

#### オプションオブジェクト

| キー          | 型       | 説明                                                                           |
| ----------- | -------- | ------------------------------------------------------------------------------ |
| `type`      | `String` | タイリングの種類。現在は `'rhombus'` のみサポートされています。                |
| `inflation` | `Number` | インフレーションの反復回数。数値が大きいほど複雑なパターンになります。         |
| `rim`       | `String` | スタイル                                                                       |
