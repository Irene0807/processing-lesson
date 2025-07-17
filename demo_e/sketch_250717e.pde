int num = 500;
Particle[] particles = new Particle[num];
float time = 0;

void setup() {
  size(1200, 800, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  noStroke();

  for (int i = 0; i < num; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);

  translate(width / 2, height / 2);

  for (Particle p : particles) {
    p.update();
    p.display();
  }

  time += 0.005;
}

class Particle {
  float baseR, offsetA, speed, size;
  float phase;

  Particle() {
    baseR = random(100, 350);
    offsetA = random(TWO_PI);
    speed = random(0.001, 0.01);
    size = random(8, 20);
    phase = random(TWO_PI);
  }

  void update() {
    offsetA += speed;
  }

  void display() {
    float r = baseR + 30 * sin(time * 2 + phase);
    float x = r * cos(offsetA + sin(time + phase));
    float y = r * sin(offsetA + cos(time + phase * 0.5));

    // 滑鼠與此粒子的距離（畫面為中心原點）
    float dx = mouseX - width / 2 - x;
    float dy = mouseY - height / 2 - y;
    float distToMouse = dist(0, 0, dx, dy);

    // 是否靠近滑鼠
    boolean nearMouse = distToMouse < 100;

    float h = (offsetA * 180 / PI + frameCount * 0.5) % 360;
    float alpha = 40 + 30 * sin(phase + time * 3);

    if (nearMouse) {
      fill(0, 0, 100, 100);  // 銀白色閃光（HSB模式下 H=0, S=0, B=100）
      ellipse(x, y, size * 0.7, size * 0.7); // 小一點，像閃一下
    } else {
      fill(h, 60, 100, alpha);
      ellipse(x, y, size, size);
    }
  }
}
