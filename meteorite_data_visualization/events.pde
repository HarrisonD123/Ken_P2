//execute code when mouse is pressed
void mousePressed() {
  if (mouseX > 45 && mouseX < matDimension[2] - xOffset && mouseY > 45 && mouseY < matDimension[2] - yOffset) {
    cubes[0].target(mouseX, mouseY, 0);
  }
  
  //insert code here;
}

//execute code when mouse is released
void mouseReleased() {
  //insert code here;
}

//execute code when button on toio is pressed
void buttonDown(int id) {
    println("Button Pressed!");
    
    //insert code here
}

//execute code when button on toio is released
void buttonUp(int id) {
    println("Button Released!");
    
    //insert code here
}

//execute code when toio detects collision
void collision(int id) {
    println("Collision Detected!");
    //insert code here
}

//execute code when toio detects double tap
void doubleTap(int id) {
    println("Double Tap Detected!");
    
    //insert code here
}
