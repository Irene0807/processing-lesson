let num = 500;
let particles = [];
let time = 0;

function setup() {
  createCanvas(1200, 800, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  noStroke();

  for (let i = 0; i < num; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  fill(0, 0, 0, 10); // 半透明黑色背景
  rect(0, 0, width, height);

  translate(width / 2, height / 2);

  for (let p of particles) {
    p.update();
    p.display();
  }

  time += 0.005;
}

class Particle {
  constructor() {
    this.baseR = random(100, 350);
    this.offsetA = random(TWO_PI);
    this.speed = random(0.001, 0.01);
    this.size = random(8, 20);
    this.phase = random(TWO_PI);
  }

  update() {
    this.offsetA += this.speed;
  }

  display() {
    let r = this.baseR + 30 * sin(time * 2 + this.phase);
    let angle = this.offsetA + sin(time + this.phase);
    let x = r * cos(angle);
    let y = r * sin(this.offsetA + cos(time + this.phase * 0.5));

    let dx = mouseX - width / 2 - x;
    let dy = mouseY - height / 2 - y;
    let distToMouse = dist(0, 0, dx, dy);
    let nearMouse = distToMouse < 100;

    let h = (this.offsetA * 180 / PI + frameCount * 0.5) % 360;
    let alpha = 40 + 30 * sin(this.phase + time * 3);

    if (nearMouse) {
      fill(0, 0, 100, 100); // 銀白色
      ellipse(x, y, this.size * 0.7, this.size * 0.7);
    } else {
      fill(h, 60, 100, alpha);
      ellipse(x, y, this.size, this.size);
    }
  }
}
