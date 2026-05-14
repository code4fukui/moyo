# moyo

> 日本語のREADMEはこちらです: [README.ja.md](README.ja.md)



A geometric pattern generator for [SVG.js](http://svgjs.com) that creates Penrose tilings.

This project is a fork of [yucho/moyo](https://github.com/yucho/moyo), adapted to work as an ES module.

## Live Demo

You can experiment with the options live on [ES-Jam](https://ss.sabae.cc/#504).

## Features

*   **Penrose Tilings**: Generates P2 (rhombus) tilings.
*   **Inflation Control**: Adjust the complexity of the pattern with the `inflation` option (e.g., 3-10).
*   **Rim Styles**: Control the pattern's edge rendering with `clip`, `subtractive`, or `additive` styles.
*   **Custom Colors**: Easily specify fill colors for the two rhombus types.

## Usage

Include SVG.js and the moyo module in your HTML file.

```html
<div id="svg"></div>
<script type="module">
import SVG from "https://code4fukui.github.io/svg-es/SVG@2.7.1.js";
import moyo from "https://code4fukui.github.io/moyo/penrose.js";

// Extend SVG.js with the moyo plugin
moyo(SVG);

// Create an SVG canvas
const draw = SVG("svg").size(600, 500);

// Generate a basic Penrose tiling
draw.penrose(600, { type: "rhombus", inflation: 5, rim: "clip" });
</script>
```

### Advanced Usage

You can pass additional objects to customize the fill colors for the "fat" and "thin" rhombi.

```javascript
// Example with custom colors
draw.penrose(
  600,
  { type: "rhombus", inflation: 5, rim: "clip" },
  { fill: "hsl(30 90% 30%)" },  // Style for "fat" rhombus
  { fill: "hsl(80 90% 30%)" }   // Style for "thin" rhombus
);
```

## API

### `draw.penrose(size, options, [fatRhombusAttrs], [thinRhombusAttrs])`

| Parameter          | Type     | Description                                                  |
| ------------------ | -------- | ------------------------------------------------------------ |
| `size`             | `Number` | The approximate size of the tiling in pixels.                |
| `options`          | `Object` | An object with configuration properties.                     |
| `fatRhombusAttrs`  | `Object` | (Optional) SVG.js attributes for the "fat" rhombus tiles.    |
| `thinRhombusAttrs` | `Object` | (Optional) SVG.js attributes for the "thin" rhombus tiles.   |

#### Options Object

| Key         | Type     | Description                                                                    |
| ----------- | -------- | ------------------------------------------------------------------------------ |
| `type`      | `String` | The type of tiling. Currently, only `'rhombus'` is supported.                  |
| `inflation` | `Number` | The number of inflation iterations. Higher numbers create more complex patterns. |
| `rim`       | `String` | The style
