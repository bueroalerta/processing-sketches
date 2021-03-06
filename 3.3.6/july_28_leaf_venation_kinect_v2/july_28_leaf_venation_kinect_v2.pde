import java.util.*;
import KinectPV2.*;

KinectPV2 kinect;

enum ReasonStopped {
  Expensive, Crowded
};

Leaf leaf;

PShader personShader;

void setup() {
  size(displayWidth, displayHeight, P2D);
  //size(2400, 1350, P2D);
  pixelDensity(1);
  smooth(8);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  kinect = new KinectPV2(this);
  kinect.enableBodyTrackImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.init();
  noiseSeed(0);
  useLeafMatrix();
  initLeafSingle();
  personShader = loadShader("personShader.glsl");
}

void initLeafSingle() {
  leaf = new Leaf();
}

float wait = 0;

void draw() {
  background(0);
  PImage depth = kinect.getBodyTrackImage();
  image(depth, 0, 0, width, height);
  //color c = depth.get(depth.width / 2, depth.height / 2);
  //println(red(c), green(c), blue(c), brightness(c), alpha(c));
  filter(personShader);
  //textSize(16); 
  //stroke(0);
  //textAlign(LEFT, TOP);
  //fill(0); 
  //stroke(0);
  //text(frameRate, 20, 20);
  useLeafMatrix();

  depth.loadPixels();

  //  leaf.SECONDARY_BRANCH_SCALAR = 0.85;
  //  leaf.SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
  //  leaf.DEPTH_STEPS_BEFORE_BRANCHING = max(1, (int)map(mouseX, 0, width, 1, 6));

  if (leaf == null || leaf.finished) {
    if (wait <= 0) {
      initLeafSingle();
      leaf.depthImage = depth;
      //leaf.firstGrow();
      wait = 60;
    } else {
      wait -= 1;
    }
  }
  //initLeafSingle();

  leaf.depthImage = depth;
  //leaf.BASE_DISINCENTIVE = pow(10, map(cos(millis() / 450f), -1, 1, 0, 3));
  //leaf.BASE_DISINCENTIVE = pow(10, map(mouseX, 0, width, 0, 3));

  //leaf.SIDE_ANGLE = map(sin(millis() / 300f), -1, 1, PI / 6, PI/2);
  //leaf.SIDE_ANGLE = map(mouseY, 0, height, PI/6, PI/2);

  //leaf.SIDEWAYS_COST_RATIO = map(mouseX, 0, width, 0, 1);

  //leaf.COST_BEHIND_GROWTH = pow(10, map(mouseX, 0, width, -10, 3));

  //leaf.GROW_FORWARD_FACTOR = pow(map(mouseX, 0, width, 0, 5), 3);

  //leaf.MAX_PATH_COST = pow(10, map(mouseX, 0, width, 0, 3));

  //leaf.BRANCH_SCALAR = map(mouseX, 0, width, 0.5, 1.0);
  //leaf.SECONDARY_BRANCH_SCALAR = 0.85;
  // leaf.SECONDARY_BRANCH_PERIOD = max(1, (int)map(mouseY, 0, height, 1, 10));
  //leaf.DEPTH_STEPS_BEFORE_BRANCHING = 3; // max(1, (int)map(mouseX, 0, width, 1, 6));
  // leaf.COST_TO_TURN = map(mouseX, 0, width, -100, 100);
  for(int i = 0; i < 1; i++) {
    leaf.expandBoundary();
  }

  //println(screenX(0, 0));
  //println(screenY(0, 0));

  leaf.drawWorld();

  //List<PVector> vecs = new ArrayList();
  //for (Leaf.Small s : leaf.world) {
  //  float sx = screenX(s.position.x, s.position.y);
  //  float sy = screenY(s.position.x, s.position.y);
  //  vecs.add(new PVector(sx, sy));
  //}
  //resetMatrix();
  //for(PVector v : vecs) {
  //  stroke(255, 0, 0);
  //  strokeWeight(10);
  //  point(v.x, v.y);
  //  textSize(12);
  //  text(v.x+","+v.y, v.x, v.y);
  //}

  //fill(0);
  //textAlign(LEFT, TOP);
  //textSize(20);
  //text(leaf.COST_TO_TURN, 0, 0);
}

PMatrix2D mat;

void useLeafMatrix() {
  // translate leaf coordinates into screen coordinates
  // leaves are rooted at 0, 0, have their main axis growing towards +x
  // y is lateral "fatness".

  // on the screen we want the leaf to be rooted at width/2, height * 0.9
  // whose main axis growing towards -y

  // this will also affect processing's screenX/screenY which we use while growing the leaf!

  translate(width/2, height * 0.9);
  rotate(-PI / 2);
  scale(6);

  mat = new PMatrix2D();
  mat.translate(width/2, height * 0.9);
  mat.rotate(-PI / 2);
  mat.scale(6);
}

float leafToScreenX(float x, float y) {
  return mat.multX(x, y);
}

float leafToScreenY(float x, float y) {
  return mat.multY(x, y);
}

void keyPressed() {
}