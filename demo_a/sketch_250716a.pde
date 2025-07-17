ArrayList<Bubble> bubbles;
color[] palette;
float colorThreshold = 50; // 顏色相近的容忍距離

void setup() {
  size(800, 600);
  noStroke();

  palette = new color[] {
    //color(253,39,18),
    //color(253,83,8),
    //color(253,253,51),
    //color(207,234,43),
    //color(6,214,160),
    //color(2,144,205),
    //color(134,1,174),
    //color(245,99,224), //pink
    color(247,118,141), //red
    //color(245,151,107),
    color(247,239,90), //yellow
    color(104,250,110), //green
    color(88,222,235), //blue
    //color(92,161,234),
    //color(187,97,249), //purple
  };

  bubbles = new ArrayList<Bubble>();
}

void draw() {
  background(255);

  // 每 10 幀嘗試產生一顆不重疊的新泡泡
  if (frameCount % 5 == 0) {
    Bubble newBubble = createNonOverlappingBubble();
    if (newBubble != null) {
      bubbles.add(newBubble);
    }
  }

  // 處理碰撞反彈
  for (int i = 0; i < bubbles.size(); i++) {
    for (int j = i + 1; j < bubbles.size(); j++) {
      bubbles.get(i).collideWith(bubbles.get(j));
    }
  }

  // 更新與繪製
  for (int i = bubbles.size() - 1; i >= 0; i--) {
    Bubble b = bubbles.get(i);
    b.update();
    b.display();
    if (b.isOffScreen()) {
      bubbles.remove(i);
    }
  }
}

Bubble createNonOverlappingBubble() {
  int maxTries = 50;
  for (int t = 0; t < maxTries; t++) {
    float r_p = random(100);
    float r;
    if (r_p < 1) r = 20;
    else if (r_p < 20) r = 50;
    else if (r_p < 80) r = 80;
    else r = 100;

    float x = random(r, width - r);
    float y = random(r, height - r);

    // 嘗試找一個不與鄰近顏色撞色的顏色
    color newColor = color(0);;
    int colorTry = 0;
    boolean colorOK = false;
    while (colorTry < 10) {
      newColor = palette[int(random(palette.length))];
      boolean clash = false;
      for (Bubble other : bubbles) {
        float d = dist(x, y, other.x, other.y);
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

    Bubble test = new Bubble(x, y, r, newColor);

    boolean overlaps = false;
    for (Bubble other : bubbles) {
      if (test.overlapsWith(other)) {
        overlaps = true;
        break;
      }
    }

    if (!overlaps) return test;
  }
  return null;
}

boolean isColorTooSimilar(color c1, color c2, float threshold) {
  float r1 = red(c1);
  float g1 = green(c1);
  float b1 = blue(c1);
  float r2 = red(c2);
  float g2 = green(c2);
  float b2 = blue(c2);
  float dist = dist(r1, g1, b1, r2, g2, b2);
  return dist < threshold;
}

class Bubble {
  float x, y, r;
  float vx, vy;
  color c;
  float growthProgress = 0;
  float growthSpeed = 0.05;

  Bubble(float x_, float y_, float r_, color c_) {
    x = x_;
    y = y_;
    r = r_;
    c = c_;

    if (random(1) < 0.7) {
      float centerX = width / 2.0;
      float centerY = height / 2.0;
      float dx = x_ - centerX;
      float dy = y_ - centerY;
      float dist = sqrt(dx * dx + dy * dy);

      if (dist != 0) {
        dx /= dist;
        dy /= dist;
      }

      float angleOffset = radians(random(-30, 30));
      float cosA = cos(angleOffset);
      float sinA = sin(angleOffset);
      float outX = dx * cosA - dy * sinA;
      float outY = dx * sinA + dy * cosA;

      float speed = random(0.5, 2);
      vx = outX * speed;
      vy = outY * speed;

    } else {
      vx = random(-1.5, 1.5);
      vy = random(-1.5, 1.5);
    }
  }

  void update() {
    x += vx;
    y += vy;
    if (growthProgress < 1) {
      growthProgress += growthSpeed;
      growthProgress = min(growthProgress, 1);
    }
  }

  void display() {
    fill(c);
    float currentRadius = r * growthProgress;
    ellipse(x, y, currentRadius * 1.97, currentRadius * 1.97);

    fill(255, 180);
    ellipse(x - r * 0.3, y - r * 0.3, r * 0.3, r * 0.3);
  }

  boolean isOffScreen() {
    return (x + r < 0 || x - r > width || y + r < 0 || y - r > height);
  }

  boolean overlapsWith(Bubble other) {
    float d = dist(x, y, other.x, other.y);
    return d < (r + other.r);
  }

  void collideWith(Bubble other) {
    float dx = other.x - x;
    float dy = other.y - y;
    float distSq = dx * dx + dy * dy;
    float minDist = r + other.r;

    if (distSq < minDist * minDist && distSq > 0) {
      float dist = sqrt(distSq);
      float overlap = 0.5 * (minDist - dist);

      float nx = dx / dist;
      float ny = dy / dist;
      x -= nx * overlap;
      y -= ny * overlap;
      other.x += nx * overlap;
      other.y += ny * overlap;

      float dotProduct = (vx - other.vx) * nx + (vy - other.vy) * ny;
      if (dotProduct < 0) {
        float bounce = 1;
        float impulse = bounce * dotProduct;

        vx -= impulse * nx;
        vy -= impulse * ny;
        other.vx += impulse * nx;
        other.vy += impulse * ny;
      }
    }
  }
}
