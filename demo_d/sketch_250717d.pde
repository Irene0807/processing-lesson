ArrayList<PVector> points;
ArrayList<PVector> velocities;

void setup() {
  size(800, 600);
  points = new ArrayList<PVector>();
  velocities = new ArrayList<PVector>();

  for (int i = 0; i < 80; i++) {
    points.add(new PVector(random(width), random(height)));
    velocities.add(PVector.random2D().mult(random(0.5, 1.0)));
  }

  strokeWeight(0.8);
  noFill();
}

void draw() {
  background(10, 20, 40);  // 深藍背景（乾淨）

  // 更新每個點的位置與邊界反彈
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    PVector v = velocities.get(i);

    p.add(v);

    if (p.x < 0 || p.x > width) v.x *= -1;
    if (p.y < 0 || p.y > height) v.y *= -1;
  }

  // 畫線與三角形
  for (int i = 0; i < points.size(); i++) {
    PVector p1 = points.get(i);
    for (int j = i + 1; j < points.size(); j++) {
      PVector p2 = points.get(j);
      float d1 = dist(p1.x, p1.y, p2.x, p2.y);
      if (d1 < 100) {
        for (int k = j + 1; k < points.size(); k++) {
          PVector p3 = points.get(k);
          float d2 = dist(p2.x, p2.y, p3.x, p3.y);
          float d3 = dist(p3.x, p3.y, p1.x, p1.y);
          if (d2 < 100 && d3 < 100) {
            stroke(100, 200, 255, 40); // 淺藍透明線
            triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
          }
        }
        stroke(180, 220, 255, 60); // 白藍線條
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }
  }

  // 畫圓點
  noStroke();
  fill(255);
  for (PVector p : points) {
    ellipse(p.x, p.y, 3.5, 3.5);
  }
}
