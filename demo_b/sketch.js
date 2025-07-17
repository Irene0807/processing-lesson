let numLines = 1;     // 幾圈
let angleStep;
let time = 0;

function setup() {
  createCanvas(800, 800, WEBGL);
  angleStep = TWO_PI / numLines;
  frameRate(60);
  strokeWeight(1.5);
}

function draw() {
  background(0);
  lights();
  rotateY(time * 0.3);
  rotateX(time * 0.2);

  for (let i = 0; i < numLines; i++) {
    let angle = i * angleStep;
    let dynamicR = 200 + 50 * sin(time + i * 0.2); // 半徑隨時間變化
    stroke(255);
    noFill();

    beginShape();
    for (let t = 0; t < TWO_PI * 2.5; t += 0.05) {
      let r = dynamicR * sin(t * 3 + angle + time);
      let x = r * cos(t);
      let y = r * sin(t);
      let z = 100 * cos(t + angle * 2 + time);
      vertex(x, y, z);
    }
    endShape();
  }

  time += 0.01;
}
