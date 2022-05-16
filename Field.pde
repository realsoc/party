float inc = 0.1;
int scl = 10;
float zoff = 0;
float particleHue = 10000;

int cols;
int rows;

int noOfPoints = 5000;

FieldParticle[] particles = new FieldParticle[noOfPoints];
PVector[] flowField;

void setup() {
  size(1000, 760, P2D);
  orientation(LANDSCAPE);
  colorMode(HSB);
  
  background(0);
  hint(DISABLE_DEPTH_MASK);
  
  cols = floor(width/scl);
  rows = floor(height/scl);
  
  flowField = new PVector[(cols*rows)];
  
  for(int i = 0; i < noOfPoints; i++) {
    particles[i] = new FieldParticle();
  }
}

void draw() {
 fill(0,7);
 rect(0,0,width,height);
 noFill();
  
  float yoff = 0;
  for(int y = 0; y < rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      int index = (x + y * cols);

      float angle = noise(xoff, yoff, zoff) * TWO_PI;
      PVector v = PVector.fromAngle(angle);
      v.setMag(0.01);
      
      flowField[index] = v;

      stroke(0, 50);
      
      xoff = xoff + inc;
    }
    yoff = yoff + inc;
  }
  zoff = zoff + (inc / 50);
  
  int hue = int(map(noise(particleHue), 0, 1, 0, 360));
  particleHue += inc / 100;
  for(int i = 0; i < particles.length; i++) {
    particles[i].follow(flowField);
    particles[i].update();
    particles[i].edges();
    particles[i].show(hue);
  }
}
