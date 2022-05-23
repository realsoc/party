// Daniel Shiffman
// Kinect Point Cloud example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
BeatDetect beat;

// Kinect Library object
Kinect kinect;

// Angle for rotation
float a = 0;
int beatCounter = 0;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];
float eRadius;
int currentColor = 255;

void setup() {
  // Rendering in P3D
  fullScreen(P3D);
  colorMode(HSB, 255, 255, 255);
  kinect = new Kinect(this);
  kinect.initDepth();
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO);
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  beat.setSensitivity(100);
  eRadius = 4;

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

void draw() {

  background(0);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  beat.detect(in.mix);
  if ( beat.isOnset() ) {
    beatCounter += 1;
    eRadius = 10;
    if(beatCounter > 4
    ) {
      currentColor = randomColor();
      beatCounter = 0;
    }
  }

  eRadius *= 0.98;
  if ( eRadius < 4 ) eRadius = 4;
  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;

  // Translate and rotate
  translate(width/2, height/2, -50);
  rotateY(a);
  
  int skip2 = (int) eRadius;

  for (int x = 0; x < kinect.width; x += skip2) {
    for (int y = 0; y < kinect.height; y += skip2) {
      int offset = x + y*kinect.width;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);

      stroke(currentColor, 200, 200);
      pushMatrix();
      // Scale up by 200
      float factor = 200;
      translate(v.x*factor, v.y*factor, factor-v.z*factor);
      // Draw a point
      point(0, 0);
      popMatrix();
    }
  }

  // Rotate
  a += 0.005f;
}

int randomColor() {
  return (int) random(0, 255);
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}
