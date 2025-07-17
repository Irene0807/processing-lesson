int numLines =1;     // 幾圈
float angleStep;
float time = 0;

void setup() {
  size(800, 800, P3D);
  angleStep = TWO_PI / numLines;
  frameRate(60);
  strokeWeight(1.5);
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2);
  rotateY(time * 0.3);
  rotateX(time * 0.2);

  for (int i = 0; i < numLines; i++) {
    float angle = i * angleStep;
    float dynamicR = 200 + 50 * sin(time + i * 0.2); // 半徑隨時間變化
    stroke(255);

    beginShape();
    for (float t = 0; t < TWO_PI * 2.5; t += 0.05) {
      float r = dynamicR * sin(t * 3 + angle + time);
      float x = r * cos(t);
      float y = r * sin(t);
      float z = 100 * cos(t + angle * 2 + time);
      vertex(x, y, z);
    }
    endShape();
  }

  time += 0.01;
}
