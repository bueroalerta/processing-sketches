void setup() {
  size(500, 500);
  noFill();
}

void draw() {
  background(210, 160, 0);
  long before = System.currentTimeMillis();
  for(int i = 0; i < 10000; i++) {
    ellipse(random(width), random(height), 50, 50);
  }
  long after = System.currentTimeMillis();
  println(""+(after-before));
  if(frameCount > 100) exit();
}
