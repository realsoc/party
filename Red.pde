class RedPill  { 
  ControlP5 localCp5;
  RedPill(ControlP5 cp5) {
    this.localCp5 = cp5;
  }
  
  void setup() {
    println("Red pill setup");
  }
  
  void draw() {
    background(0, 255, 255);
  }
}
