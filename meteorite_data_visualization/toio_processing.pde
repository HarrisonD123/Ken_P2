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

//void settings() {
//  size(1000, 1000);
//}

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
  
  // ------------------- SCREEN SETUP
  smooth();
  size(900, 900, P3D);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(700, 700, 20);
  offscreen = createGraphics(700, 700, P3D);
  
  for (int i = 0; i < 24; i++){
    fire[i] = loadImage( "fire/fire" + i + ".gif" );
  }
  
  crater = loadImage("crater.png");

  // ------------------- SETUP FOR METEORITES
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);
  
  // Initializing meteorite variables
  atStarts = new Boolean[nCubes];
  for (int i = 0; i < nCubes; i++) {
    atStarts[i] = false;
  }
  targets = new int[nCubes][2];
  currMeteor = new Meteor[nCubes];
  status = new Status[nCubes];
  waitTimes = new int[nCubes];
  waitStarts = new int[nCubes];
  returnPath = new int[nCubes];
  
  for (int i = 0; i < nCubes; i++) {
    waitTimes[i] = 800 * i;
  }
  
  ends = (int[][])reverse(ends);
  waitTimes = (int[])reverse(waitTimes);
  
  // ------------------- DATA PARSING
  table = loadTable("meteors.csv", "header");
  
  scopedTable.addColumn("name", Table.STRING);
  scopedTable.addColumn("year", Table.INT);
  scopedTable.addColumn("mass", Table.FLOAT);
  scopedTable.addColumn("GeoLocation", Table.STRING);
  
  scopedTable = filter_table(year, minMass, maxMass);//name year location mass
  meteorites = tableToArray(scopedTable);
  
  //meteorites.add(0f);
  //meteorites.add(0.5f);
  //meteorites.add(5f);
  //meteorites.add(10f);
  //meteorites.add(30f);
  //meteorites.add(50f);
  //meteorites.add(100f);
  //meteorites.add(0f);
  //meteorites.add(0.5f);
  //meteorites.add(5f);
  //meteorites.add(10f);
  //meteorites.add(30f);
  //meteorites.add(50f);
  //meteorites.add(100f);
}

void draw() {
  //START TEMPLATE/DEBUG VIEW
  //background(255);
  //stroke(0);
  
  // ----------------- RENDER SCENE
  PVector surfaceMouse = surface.getTransformedMouse();
  offscreen.beginDraw();
  
  offscreen.background(0 ,0);
  offscreen.fill(#7CECED);
  offscreen.rect(72, 72, 700-72, 700-72-72);
  offscreen.fill(#11CC2B);
  offscreen.rect(72, 700-72-72, 700-72, 72);
  offscreen.fill(0, 0, 0);
  // ------------------

  ////draw the "mat"
  //fill(255);
  //rect(matDimension[0] - xOffset, matDimension[1] - yOffset, matDimension[2] - matDimension[0], matDimension[3] - matDimension[1]);

  ////draw the cubes
  //for (int i = 0; i < nCubes; i++) {
  //  cubes[i].checkActive(now);
    
  //  if (cubes[i].isActive) {
  //    pushMatrix();
  //    translate(cubes[i].x - xOffset, cubes[i].y - yOffset);
  //    fill(0);
  //    textSize(15);
  //    text(i, 0, -20);
  //    noFill();
  //    rotate(cubes[i].theta * PI/180);
  //    rect(-10, -10, 20, 20);
  //    line(0, 0, 20, 0);
  //    popMatrix();
  //  }
  //}
  
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
        delay(200);
        if (!meteorites.isEmpty()) {
          currMeteor[i] = meteorites.remove(0);
          meteor_fall(i, currMeteor[i].mass);
        }
      }
      
      else if (status[i] == Status.FALLING) {
        //print("Toio ");
        //print(i);
        //print(": ");
        //println("What???");
        meteor_fall(i, currMeteor[i].mass);
      }
      
      else if (Arrays.stream(status).allMatch(s -> (s == Status.AT_BOTTOM))) {
        starts = (int[][])reverse(starts);
        ends = (int[][])reverse(ends);
        waitTimes = (int[])reverse(waitTimes);
        landingsEndsReversed = false;
        for (int k = 0; k < nCubes; k++) {
          drawRock(cubes[i].x, cubes[i].y, rockRad);
          drawCrater(cubes[i].x, cubes[i].y - 2 * rockRad, map(currMeteor[i].mass, minMass, maxMass, 10, 255));
        }
        delay(1000);
        for (int j = 0; j < nCubes; j++) {
          status[j] = Status.RETURNING;
          waitStarts[j] = -1; // Ready to wait
          returnPath[j] = 0; // 0th position of return path
        }
      }
      else if (status[i] == Status.AT_BOTTOM) {
        drawRock(cubes[i].x, cubes[i].y, rockRad);
        drawCrater(cubes[i].x, cubes[i].y - 2 * rockRad, map(currMeteor[i].mass, minMass, maxMass, 10, 255));
      }
    }
  }
  //print(cubes[0].x);
  //print(", ");
  //println(cubes[0].y);
  
  // cubes[0].target(3, 5, 2, 80, 2, ends[0][0], ends[0][1], 180);
  // cubes[0].target(ends[0][0], ends[0][1], 180);
  
  //int size = 40;
  //for (int i = 0; i < nCubes; i++) {
  //  // drawMeteor(cubes[i].x, cubes[i].y, rockRad);
  //  rect(cubes[i].x - 20, cubes[i].y - 20, 40, 40);
  //  offscreen.image(crater, cubes[i].x-size/2, cubes[i].y-(size/4), size, size/2);
  //}
  
  offscreen.endDraw();
  background(0);
  surface.render(offscreen);

}
