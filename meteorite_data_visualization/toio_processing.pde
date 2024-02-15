import oscP5.*;
import netP5.*;
import java.util.*;

//constants
//The soft limit on how many toios a laptop can handle is in the 10-12 range
//the more toios you connect to, the more difficult it becomes to sustain the connection
int nCubes = 1;
int cubesPerHost = 12;
int maxMotorSpeed = 115;
int xOffset;
int yOffset;

int[] matDimension = {45, 45, 455, 455};


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;

//we'll keep the cubes here
Cube[] cubes;

void settings() {
  size(1000, 1000);
}


void setup() {
  //launch OSC sercer
  oscP5 = new OscP5(this, 3333);
  server = new NetAddress[1];
  server[0] = new NetAddress("127.0.0.1", 3334);

  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< nCubes; ++i) {
    cubes[i] = new Cube(i);
  }

  xOffset = matDimension[0] - 45;
  yOffset = matDimension[1] - 45;

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);
  
  // Initializing meteorite variables
  falling = new boolean[nCubes];
  for (int i = 0; i < nCubes; i++) {
    falling[i] = false;
  }
  meteorites.add(0f);
  meteorites.add(0.5f);
  meteorites.add(5f);
  meteorites.add(10f);
  meteorites.add(30f);
  meteorites.add(50f);
  meteorites.add(100f);
  
  for (int i = 0; i < nCubes; i++) {
    cubes[i].target(i, targets[i][0], targets[i][1], 90); 
  }
}

void draw() {
  //START TEMPLATE/DEBUG VIEW
  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  fill(255);
  rect(matDimension[0] - xOffset, matDimension[1] - yOffset, matDimension[2] - matDimension[0], matDimension[3] - matDimension[1]);

  //draw the cubes
  for (int i = 0; i < nCubes; i++) {
    cubes[i].checkActive(now);
    
    if (cubes[i].isActive) {
      pushMatrix();
      translate(cubes[i].x - xOffset, cubes[i].y - yOffset);
      fill(0);
      textSize(15);
      text(i, 0, -20);
      noFill();
      rotate(cubes[i].theta * PI/180);
      rect(-10, -10, 20, 20);
      line(0, 0, 20, 0);
      popMatrix();
    }
  }
  
  // If target is start position, 
  //if (Arrays.equals(targets[0], starts[0])) { // If target for a toio is start position, don't call meteor_fall()
  //  if (abs(targets[0][0] - cubes[0].x) < 10 && abs(targets[0][1] - cubes[0].y) < 10) { // If back to start
  //    targets[0][0] = -1;
  //    targets[0][1] = -1;
  //    delay(2000);
  //  }
  //  else {
  //    cubes[0].target(0, targets[0][0], targets[0][1], 90); // Else go to start
  //  }
  //}
  //else { // Otherwise meteor_fall()
  //  if (!meteorites.isEmpty()) { // 
  //    meteor_fall(0, meteorites.get(0));
  //  }
  //}
  print(cubes[0].x);
  print(", ");
  println(cubes[0].y);

}
