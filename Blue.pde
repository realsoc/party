class BluePill  { 
  ControlP5 localCp5;
  BluePill(ControlP5 cp5) {
    this.localCp5 = cp5;
  }
  
  void setup() {
    println("Blue pill setup");
  }
  
  void draw() {
    background(150, 255, 255);
  }
}
