int cols = 10;
int rows = 10;
float spacing = 60;
float t = 0;

color[] palette = {
  color(247, 118, 141),  // 柔紅莓（可愛）
  color(255, 203, 92),   // 橘黃（元氣感）
  color(144, 224, 239),  // 淺藍（清新）
  color(120, 200, 150),  // 牛油果綠（自然）
  color(255, 156, 187),  // 草莓牛奶（少女感）
  color(174, 152, 255)   // 薰衣草紫（魔法感）
};

color[][] dotColors;
boolean[][] isIndependent;   // 哪些球不跟大部隊
float[][] phaseOffset;       // 每個叛逆球的時間偏移

void setup() {
  size(600, 600);
  ellipseMode(RADIUS);
  noStroke();

  dotColors = new color[cols][rows];
  isIndependent = new boolean[cols][rows];
  phaseOffset = new float[cols][rows];

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      // 隨機指定顏色
      int index = int(random(palette.length));
      dotColors[x][y] = palette[index];

      // 10% 的球會變成不規律（亂跳）
      if (random(1) < 0.3) {
        isIndependent[x][y] = true;
        phaseOffset[x][y] = random(TWO_PI); // 給它一個獨特的 phase
      } else {
        isIndependent[x][y] = false;
      }
    }
  }
}

void draw() {
  background(255);
  t += 0.03;

  float globalRadius = 5 + 15 * abs(sin(t)); // 同步呼吸

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float cx = x * spacing + spacing / 2;
      float cy = y * spacing + spacing / 2;

      float r;
      if (isIndependent[x][y]) {
        // 自己亂跳的球
        r = 5 + 10 * abs(sin(t * 1.5 + phaseOffset[x][y]));
      } else {
        // 同步呼吸的球
        r = globalRadius;
      }

      fill(dotColors[x][y]);
      ellipse(cx, cy, r, r);
    }
  }
}
