let bubbles = [];
let palette;
let colorThreshold = 50;

function setup() {
  createCanvas(800, 600);
  noStroke();

  palette = [
    color(247, 118, 141), // red
    color(247, 239, 90),  // yellow
    color(104, 250, 110), // green
    color(88, 222, 235),  // blue
  ];
}

function draw() {
  background(255);

  if (frameCount % 5 === 0) {
    let newBubble = createNonOverlappingBubble();
    if (newBubble !== null) {
      bubbles.push(newBubble);
    }
  }

  for (let i = 0; i < bubbles.length; i++) {
    for (let j = i + 1; j < bubbles.length; j++) {
      bubbles[i].collideWith(bubbles[j]);
    }
  }

  for (let i = bubbles.length - 1; i >= 0; i--) {
    let b = bubbles[i];
    b.update();
    b.display();
    if (b.isOffScreen()) {
      bubbles.splice(i, 1);
    }
  }
}

function createNonOverlappingBubble() {
  let maxTries = 50;
  for (let t = 0; t < maxTries; t++) {
    let r_p = random(100);
    let r;
    if (r_p < 1) r = 20;
    else if (r_p < 20) r = 50;
    else if (r_p < 80) r = 80;
    else r = 100;

    let x = random(r, width - r);
    let y = random(r, height - r);

    let newColor;
    let colorTry = 0;
    let colorOK = false;
    while (colorTry < 10) {
      newColor = random(palette);
      let clash = false;
      for (let other of bubbles) {
        let d = dist(x, y, other.x, other.y);
        if (d < r + other.r + 20 && isColorTooSimilar(newColor, other.c, colorThreshold)) {
          clash = true;
          break;
        }
      }
      if (!clash) {
        colorOK = true;
        break;
      }
      colorTry++;
    }
    if (!colorOK) continue;

    let test = new Bubble(x, y, r, newColor);

    let overlaps = false;
    for (let other of bubbles) {
      if (test.overlapsWith(other)) {
        overlaps = true;
        break;
      }
    }

    if (!overlaps) return test;
  }
  return null;
}

function isColorTooSimilar(c1, c2, threshold) {
  let r1 = red(c1), g1 = green(c1), b1 = blue(c1);
  let r2 = red(c2), g2 = green(c2), b2 = blue(c2);
  return dist(r1, g1, b1, r2, g2, b2) < threshold;
}

class Bubble {
  constructor(x, y, r, c) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.c = c;
    this.growthProgress = 0;
    this.growthSpeed = 0.05;

    if (random(1) < 0.7) {
      let centerX = width / 2.0;
      let centerY = height / 2.0;
      let dx = x - centerX;
      let dy = y - centerY;
      let distVal = sqrt(dx * dx + dy * dy);
      if (distVal !== 0) {
        dx /= distVal;
        dy /= distVal;
      }

      let angleOffset = radians(random(-30, 30));
      let cosA = cos(angleOffset);
      let sinA = sin(angleOffset);
      let outX = dx * cosA - dy * sinA;
      let outY = dx * sinA + dy * cosA;

      let speed = random(0.5, 2);
      this.vx = outX * speed;
      this.vy = outY * speed;
    } else {
      this.vx = random(-1.5, 1.5);
      this.vy = random(-1.5, 1.5);
    }
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;
    if (this.growthProgress < 1) {
      this.growthProgress += this.growthSpeed;
      this.growthProgress = min(this.growthProgress, 1);
    }
  }

  display() {
    fill(this.c);
    let currentRadius = this.r * this.growthProgress;
    ellipse(this.x, this.y, currentRadius * 1.97, currentRadius * 1.97);
    fill(255, 180);
    ellipse(this.x - this.r * 0.3, this.y - this.r * 0.3, this.r * 0.3, this.r * 0.3);
  }

  isOffScreen() {
    return (this.x + this.r < 0 || this.x - this.r > width || this.y + this.r < 0 || this.y - this.r > height);
  }

  overlapsWith(other) {
    return dist(this.x, this.y, other.x, other.y) < (this.r + other.r);
  }

  collideWith(other) {
    let dx = other.x - this.x;
    let dy = other.y - this.y;
    let distSq = dx * dx + dy * dy;
    let minDist = this.r + other.r;

    if (distSq < minDist * minDist && distSq > 0) {
      let distVal = sqrt(distSq);
      let overlap = 0.5 * (minDist - distVal);

      let nx = dx / distVal;
      let ny = dy / distVal;
      this.x -= nx * overlap;
      this.y -= ny * overlap;
      other.x += nx * overlap;
      other.y += ny * overlap;

      let dotProduct = (this.vx - other.vx) * nx + (this.vy - other.vy) * ny;
      if (dotProduct < 0) {
        let bounce = 1;
        let impulse = bounce * dotProduct;
        this.vx -= impulse * nx;
        this.vy -= impulse * ny;
        other.vx += impulse * nx;
        other.vy += impulse * ny;
      }
    }
  }
}
