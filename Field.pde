import controlP5.*;
import java.util.*;

public class FlowField implements ControlListener {    
  float inc = 0.1;
  int scl = 10;
  float zoff = 0;
  float particleHue = 10000;
  int cols = height / scl;
  int rows = width / scl;
  int nbParticles = 1000;
  int particleSize = 1;
  int particleOpacity = 50;
  float fieldMagnitude = 0.1;
  int backgroundOpacity = 7;
  int colored = -1;
  Group cp5Group;
  
  FieldParticle[] particles;
  PVector[] flowField;
 
  void setControls() {
    cp5Group = cp5.addGroup("Field");
    cp5.addSlider("nbParticles")
     .setPosition(350,100)
     .setValue(this.nbParticles)
     .setRange(0,5000)
     .setGroup(cp5Group)
     ;
    cp5.addSlider("particleSize")
     .setPosition(350,115)
     .setValue(this.particleSize)
     .setRange(0,20)
     .setGroup(cp5Group)
     ;
    cp5.addSlider("particleOpacity")
     .setPosition(350,130)
     .setValue(this.particleOpacity)
     .setRange(0,100)
     .setGroup(cp5Group)
     ;
    cp5.addSlider("fieldMagnitude")
     .setPosition(350,145)
     .setValue(this.fieldMagnitude)
     .setRange(0, 0.1)
     .setGroup(cp5Group)
     ;
    cp5.addSlider("backgroundOpacity")
     .setPosition(350,160)
     .setValue(this.backgroundOpacity)
     .setRange(0, 100)
     .setGroup(cp5Group)
     ;
    cp5.addRadioButton("colored")
    .setPosition(350,175)
    .setSize(20, 20)
    .addItem("Colors", 1)
    .setGroup(cp5Group);
    cp5.addListener(this);
  }
  
  void controlEvent(ControlEvent theEvent) {
    println(theEvent);
    switch(theEvent.getName()) {
      case "nbParticles":
        nbParticles = int(theEvent.getValue());
        setup();
        break;
      case "particleSize":
        particleSize = int(theEvent.getValue());
        setup();
        break; 
      case "particleOpacity":
        particleOpacity = int(theEvent.getValue());
        setup();
        break; 
      case "fieldMagnitude":
        fieldMagnitude = theEvent.getValue();
        setup();
        break;
      case "backgroundOpacity":
        backgroundOpacity = int(theEvent.getValue());
        setup();
        break; 
      case "colored":
        colored = int(theEvent.getValue());
        setup();
        break; 
    }
  } 
  
  void setup() {
    background(0);
    hint(DISABLE_DEPTH_MASK);
    
    cols = floor(width/scl);
    rows = floor(height/scl);
    
    flowField = new PVector[(cols*rows)];
    particles = new FieldParticle[nbParticles];
    for(int i = 0; i < nbParticles; i++) {
      particles[i] = new FieldParticle();
    }
  }

  void draw() {
   fill(0,backgroundOpacity);
   rect(0,0,width,height);
   noFill();
    
    float yoff = 0;
    for(int y = 0; y < rows; y++) {
      float xoff = 0;
      for(int x = 0; x < cols; x++) {
        int index = (x + y * cols);
  
        float angle = noise(xoff, yoff, zoff) * TWO_PI;
        PVector v = PVector.fromAngle(angle);
        v.setMag(0.1);
        flowField[index] = v;
        stroke(0, 50);
        
        xoff = xoff + inc;
      }
      yoff = yoff + inc;
    }
    zoff = zoff + (inc / 50);
    int contrast = 255;
    if (colored < 0) {
      contrast = 0;
    }
    int hue = int(map(noise(particleHue), 0, 1, 0, 360));
    particleHue += inc / 100;
    for(int i = 0; i < particles.length; i++) {
      particles[i].follow(flowField);
      particles[i].update();
      particles[i].edges();
      particles[i].show(particleSize, hue, contrast, particleOpacity);
    }
  }
}
