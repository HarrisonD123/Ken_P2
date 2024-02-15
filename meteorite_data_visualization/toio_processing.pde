import oscP5.*;
import netP5.*;
import java.util.*;

//constants
//The soft limit on how many toios a laptop can handle is in the 10-12 range
//the more toios you connect to, the more difficult it becomes to sustain the connection
int nCubes = 7;
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

boolean started = false;

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
  atStarts = new Boolean[nCubes];
  for (int i = 0; i < nCubes; i++) {
    atStarts[i] = false;
  }
  targets = new int[nCubes][2];
  currMeteor = new Float[nCubes];
  status = new Status[nCubes];
  waitTimes = new int[nCubes];
  waitStarts = new int[nCubes];
  returnPath = new int[nCubes];
  
  for (int i = 0; i < nCubes; i++) {
    waitTimes[i] = 1100 * i;
  }
  
  ends = (int[][])reverse(ends);
  waitTimes = (int[])reverse(waitTimes);
  
  meteorites.add(0f);
  meteorites.add(0.5f);
  meteorites.add(5f);
  meteorites.add(10f);
  meteorites.add(30f);
  meteorites.add(50f);
  meteorites.add(100f);
  meteorites.add(0f);
  meteorites.add(0.5f);
  meteorites.add(5f);
  meteorites.add(10f);
  meteorites.add(30f);
  meteorites.add(50f);
  meteorites.add(100f);
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
  
  // ------------------------------------------- MY CODE
  
  if (!started) { // Starting sequence to get toios into the start positions
    // Send toios to initial starting locations
    if (!Arrays.stream(atStarts).allMatch(b -> b)) {
      for (int i = 0; i < nCubes; i++) {
        if (abs(starts[i][0] - cubes[i].x) < 10 && abs(starts[i][1] - cubes[i].y) < 10) {
          atStarts[i] = true;
        }
        else {
          cubes[i].target(0, starts[i][0], starts[i][1], 90);
        }
      }
      //println(Arrays.toString(atStarts));
    }
    else {
      println("Started!");
      started = true;
      for (int i = 0; i < nCubes; i++) {
        status[i] = Status.AT_TOP;
      }
    }
  }
  
  //else if (dial toio moved) {
      // TODO
  //}
  
  else {
    //print("Toio ");
    //print(0);
    //print(": ");
    //println(status[0]);
    //print(starts[0][0]);
    //print(", ");
    //println(starts[0][1]);
    
    //print("Toio ");
    //print(1);
    //print(": ");
    //println(status[1]);
    //print(starts[1][0]);
    //print(", ");
    //println(starts[1][1]);
    
    for (int i = 0; i < nCubes; i++) {
      // If target is start position, 
      //print("Toio ");
      //print(i);
      //print(": ");
      //println(status[i]);
      if (status[i] == Status.RETURNING) { // If target for a toio is start position, don't call meteor_fall()
        //print("Toio ");
        //print(i);
        //print(": ");
        //println("What?");
        if (abs(starts[i][0] - cubes[i].x) < 10 && abs(starts[i][1] - cubes[i].y) < 10) { // If back to start
          returnPath[i] = -1; // Not returning
          status[i] = Status.AT_TOP;
        }
        else {
          return_to_sender(i);
          //cubes[i].target(0, starts[i][0], starts[i][1], 90); // Else go to start TODO TO_START FUNCTION
        }
      }
      
      else if (status[i] == Status.AT_TOP) { // If waiting at top
        //print("Toio ");
        //print(i);
        //print(": ");
        //println("What??");
        if (!meteorites.isEmpty()) {
          println("Calling fall");
          currMeteor[i] = meteorites.remove(0);
          print("Removed: ");
          println(currMeteor[i]);
          meteor_fall(i, currMeteor[i]);
        }
      }
      
      else if (status[i] == Status.FALLING) {
        //print("Toio ");
        //print(i);
        //print(": ");
        //println("What???");
        meteor_fall(i, currMeteor[i]);
      }
      
      else if (Arrays.stream(status).allMatch(s -> (s == Status.AT_BOTTOM))) {
        starts = (int[][])reverse(starts);
        ends = (int[][])reverse(ends);
        waitTimes = (int[])reverse(waitTimes);
        landingsEndsReversed = false;
        delay(1000);
        for (int j = 0; j < nCubes; j++) {
          status[j] = Status.RETURNING;
          waitStarts[j] = -1; // Ready to wait
          returnPath[j] = 0; // 0th position of return path
        }
      }
    }
  }
  //print(cubes[0].x);
  //print(", ");
  //println(cubes[0].y);
  
  // cubes[0].target(3, 5, 2, 80, 2, ends[0][0], ends[0][1], 180);
  // cubes[0].target(ends[0][0], ends[0][1], 180);

}
