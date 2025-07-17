let cols = 10;
let rows = 10;
let spacing = 60;
let t = 0;

let palette = [
  [247, 118, 141],  // 柔紅莓
  [255, 203, 92],   // 橘黃
  [144, 224, 239],  // 淺藍
  [120, 200, 150],  // 牛油果綠
  [255, 156, 187],  // 草莓牛奶
  [174, 152, 255]   // 薰衣草紫
];

let dotColors = [];
let isIndependent = [];
let phaseOffset = [];

function setup() {
  createCanvas(600, 600);
  ellipseMode(RADIUS);
  noStroke();

  for (let x = 0; x < cols; x++) {
    dotColors[x] = [];
    isIndependent[x] = [];
    phaseOffset[x] = [];
    for (let y = 0; y < rows; y++) {
      let index = int(random(palette.length));
      dotColors[x][y] = palette[index];

      if (random(1) < 0.3) {
        isIndependent[x][y] = true;
        phaseOffset[x][y] = random(TWO_PI);
      } else {
        isIndependent[x][y] = false;
      }
    }
  }
}

function draw() {
  background(255);
  t += 0.03;

  let globalRadius = 5 + 15 * abs(sin(t));

  for (let x = 0; x < cols; x++) {
    for (let y = 0; y < rows; y++) {
      let cx = x * spacing + spacing / 2;
      let cy = y * spacing + spacing / 2;

      let r;
      if (isIndependent[x][y]) {
        r = 5 + 10 * abs(sin(t * 1.5 + phaseOffset[x][y]));
      } else {
        r = globalRadius;
      }

      let c = dotColors[x][y];
      fill(c[0], c[1], c[2]);
      ellipse(cx, cy, r, r);
    }
  }
}
