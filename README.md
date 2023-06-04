# Moyo

geometric pattern extension for [SVG.js](http://svgjs.com)

## Usage

```html
<div id=svg></div>
<script type="module">
import SVG from "https://code4fukui.github.io/svg-es/SVG@2.7.1.js";
import moyo from "https://code4fukui.github.io/moyo/penrose.js";

moyo(SVG);

const draw = SVG("svg").size(600, 500); // svgjs 2.7 style
draw.penrose(600, { type: "rhombus" });  // type only "rhombus" now

// with options
//draw.penrose(600, { type: "rhombus", inflation: 5, rim: "clip" }, { fill: "hsl(30 90% 30%)" }, { fill: "hsl(80 90% 30%)" });
</script>
```
- [edit on ES-Jam](https://ss.sabae.cc/#504)

## src

- forked [yucho/moyo](https://github.com/yucho/moyo)
