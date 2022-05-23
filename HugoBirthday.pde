import controlP5.*;
import java.util.*;

ControlP5 cp5;
boolean displayMenu = true;
List<String> l = Arrays.asList("Field", "Red pill", "Blue pill");
String currentProgram = l.get(0);
BluePill bluePill = new BluePill();
RedPill redPill = new RedPill();
FlowField flowField = new FlowField();

void setup() {
  size(700, 400);
  colorMode(HSB);
  background(240);
  cp5 = new ControlP5(this);
  cp5.addScrollableList("dropdown")
     .setPosition(100, 100)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(l)
     .setValue(0);
   
   setupProgram();
}

void draw() {
  switch(currentProgram) {
    case("Red pill"):
      redPill.draw();
      break;
    case("Blue pill"):
      bluePill.draw();
      break;
    case("Field"):
      flowField.draw();
      break;
  }
}

void setupProgram() {
  removeAllControls();
  switch(currentProgram) {
    case("Red pill"):
      redPill.setup();
      break;
    case("Blue pill"):
      bluePill.setup();
      break;
    case("Field"):
      flowField.setControls();
      flowField.setup();
      break;
  }
}

void removeAllControls() {
   cp5.remove("Field");
}

void dropdown(int n) {
  /* request the selected item based on index n */
  Map item = cp5.get(ScrollableList.class, "dropdown").getItem(n);  
  currentProgram = (String) item.get("name");
  setupProgram();
}

void keyPressed() {
  switch(key) {
    case(' '):
      if (displayMenu) {
        cp5.hide();
      } else {
        cp5.show();
      }
      displayMenu = !displayMenu;
      break;
  }
}

    
