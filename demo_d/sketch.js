let points = [];
let velocities = [];

function setup() {
  createCanvas(800, 600);
  strokeWeight(0.8);
  noFill();

  for (let i = 0; i < 80; i++) {
    points.push(createVector(random(width), random(height)));
    velocities.push(p5.Vector.random2D().mult(random(0.5, 1.0)));
  }
}

function draw() {
  background(10, 20, 40); // 深藍背景

  // 更新點的位置與邊界反彈
  for (let i = 0; i < points.length; i++) {
    let p = points[i];
    let v = velocities[i];

    p.add(v);

    if (p.x < 0 || p.x > width) v.x *= -1;
    if (p.y < 0 || p.y > height) v.y *= -1;
  }

  // 畫線與三角形
  for (let i = 0; i < points.length; i++) {
    let p1 = points[i];
    for (let j = i + 1; j < points.length; j++) {
      let p2 = points[j];
      let d1 = dist(p1.x, p1.y, p2.x, p2.y);
      if (d1 < 100) {
        for (let k = j + 1; k < points.length; k++) {
          let p3 = points[k];
          let d2 = dist(p2.x, p2.y, p3.x, p3.y);
          let d3 = dist(p3.x, p3.y, p1.x, p1.y);
          if (d2 < 100 && d3 < 100) {
            stroke(100, 200, 255, 40); // 淺藍透明三角形
            triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
          }
        }
        stroke(180, 220, 255, 60); // 白藍連線
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }
  }

  // 畫圓點
  noStroke();
  fill(255);
  for (let p of points) {
    ellipse(p.x, p.y, 3.5, 3.5);
  }
}
