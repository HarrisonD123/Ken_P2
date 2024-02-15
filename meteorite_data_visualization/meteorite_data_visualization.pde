class Meteor {
  String name;
  int year;
  float mass;
  String geoLoc;
}

ArrayList<Meteor> meteorites; // List of meteorites implemented as a queue.

int prevLoc[][] = {{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}; // 2D Array per toio as well ------------------------- TODO

int timeOfLastUpdate = millis();

int[][] starts = {{120, 70}, {170, 70}, {220, 70}, {270, 70}, {320, 70}, {370, 70}, {420, 70}}; // top dark strip
int[][] landings = {{120, 400}, {170, 400}, {220, 400}, {270, 400}, {320, 400}, {370, 400}, {420, 400}}; // End of animation
enum Status {
  AT_TOP,
  AT_BOTTOM,
  FALLING,
  RETURNING
}

int[][] ends = {{120, 430}, {170, 430}, {220, 430}, {270, 430}, {320, 430}, {370, 430}, {420, 430}}; // Bottom dark strip
int[] bottomLeft = {70, 430}; // Bottom of left dark strip
int[] topLeft = {70, 70}; // Top of left dark strip

Boolean[] atStarts;
boolean landingsEndsReversed = false;

int[][] targets;
Meteor[] currMeteor;
Status[] status;

int[] waitTimes;
int[] waitStarts;
int[] returnPath;

int rockRad = 30;

// -------------------- USER CHOOSES VALUES -----------------------
float minMass = 0;
float maxMass = 100;
int year = 1990;
// ----------------------------------------------------------------

void meteor_fall(int cubeIndex, float meteoriteMass) {
  int massSpeed = (int)map(meteoriteMass, minMass, maxMass, 10, 255);
  if (status[cubeIndex] != Status.FALLING) { // On first call of a meteor's fall
    targets[cubeIndex][0] = landings[cubeIndex][0];
    targets[cubeIndex][1] = landings[cubeIndex][1];
    //cubes[cubeIndex].target(3, 20, 2, 50, 0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
    cubes[cubeIndex].target(0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
    timeOfLastUpdate = millis();
    prevLoc[cubeIndex][0] = cubes[cubeIndex].x;
    prevLoc[cubeIndex][1] = cubes[cubeIndex].y;
    status[cubeIndex] = Status.FALLING;
    
    drawMeteor(cubes[cubeIndex].x, cubes[cubeIndex].y, rockRad);
  }
  
  else { // Subsequent calls while falling
    if (millis() - timeOfLastUpdate > 100) {
      if (abs(prevLoc[cubeIndex][0] - cubes[cubeIndex].x) < 2 && abs(prevLoc[cubeIndex][1] - cubes[cubeIndex].y) < 2) {
        cubes[cubeIndex].motor(-massSpeed, -massSpeed, 50);
        
        drawRock(cubes[cubeIndex].x, cubes[cubeIndex].y, rockRad);
        drawLabel(cubes[cubeIndex].x, cubes[cubeIndex].y, currMeteor[cubeIndex]);
        //print("Pushing: ");
        //println(massSpeed);
        //print("Prev: ");
        //print(prevLoc[0]);
        //print(", ");
        //println(prevLoc[1]);
        //print("Cube: ");
        //print(cubes[0].x);
        //print(", ");
        //println(cubes[0].y);
      }
      else {
        timeOfLastUpdate = millis();
        prevLoc[cubeIndex][0] = cubes[cubeIndex].x;
        prevLoc[cubeIndex][1] = cubes[cubeIndex].y;
        
        drawMeteor(cubes[cubeIndex].x, cubes[cubeIndex].y, rockRad);
        //print("Prev: ");
        //print(prevLoc[0]);
        //print(", ");
        //println(prevLoc[1]);
        //print("Cube: ");
        //print(cubes[0].x);
        //print(", ");
        //println(cubes[0].y);
      }
    }
    else {
      if (abs(landings[cubeIndex][0] - cubes[cubeIndex].x) > 20 || abs(landings[cubeIndex][1] - cubes[cubeIndex].y) > 20) {
        //println("Targeting");
        //cubes[cubeIndex].target(3, 20, 2, 50, 0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
        cubes[cubeIndex].target(0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
        
        drawMeteor(cubes[cubeIndex].x, cubes[cubeIndex].y, rockRad);
      }
      else {
        // println("Delay start");
        // delay(2000);
        // println("Delay end");
        targets[cubeIndex][0] = starts[cubeIndex][0];
        targets[cubeIndex][1] = starts[cubeIndex][1];
        status[cubeIndex] = Status.AT_BOTTOM;
        
        drawRock(cubes[cubeIndex].x, cubes[cubeIndex].y, rockRad);
        drawCrater(cubes[cubeIndex].x, cubes[cubeIndex].y - 2* rockRad, massSpeed);
      }
    }
  }
  
}

void return_to_sender(int cubeIndex) { // Return all toios to their starting position
    //print(cubeIndex);
    //print(cubes[cubeIndex].x);
    //print(", ");
    //println(cubes[cubeIndex].y);
    if (returnPath[cubeIndex] == 0 && abs(landings[cubeIndex][0] - cubes[cubeIndex].x) < 10 && abs(landings[cubeIndex][1] - cubes[cubeIndex].y) < 10) {
      returnPath[cubeIndex] = 1;
      //cubes[cubeIndex].target(2, ends[cubeIndex][0], ends[cubeIndex][1], 180);
      cubes[cubeIndex].target(3, 20, 2, 50, 0, ends[cubeIndex][0], ends[cubeIndex][1], 180);
    }
    else if (returnPath[cubeIndex] == 1 && abs(ends[cubeIndex][0] - cubes[cubeIndex].x) < 10 && abs(ends[cubeIndex][1] - cubes[cubeIndex].y) < 10) {
      if (waitStarts[cubeIndex] == -1) waitStarts[cubeIndex] = millis();
      if (millis() - waitStarts[cubeIndex] >= waitTimes[cubeIndex]) {
        returnPath[cubeIndex] = 2;
        //cubes[cubeIndex].target(2, bottomLeft[0], bottomLeft[1], 270);
        cubes[cubeIndex].target(3, 20, 2, 50, 0, bottomLeft[0], bottomLeft[1], 270);
        waitStarts[cubeIndex] = -2; // Inactive
      }
      //else {
      //  print(cubeIndex);
      //  print(" waiting: ");
      //  println(millis() - waitStarts[cubeIndex]);
      //}
    }
    else if (returnPath[cubeIndex] == 2 && abs(bottomLeft[0] - cubes[cubeIndex].x) < 10 && abs(bottomLeft[1] - cubes[cubeIndex].y) < 10) {
      returnPath[cubeIndex] = 3;
      //cubes[cubeIndex].target(2, topLeft[0], topLeft[1], 0);
      cubes[cubeIndex].target(3, 20, 2, 50, 0, topLeft[0], topLeft[1], 0);
      if (!landingsEndsReversed) {
        landings = (int[][])reverse(landings);
        landingsEndsReversed = true;
      }
    }
    else if (returnPath[cubeIndex] == 3 && abs(topLeft[0] - cubes[cubeIndex].x) < 10 && abs(topLeft[1] - cubes[cubeIndex].y) < 10) {
      returnPath[cubeIndex] = 4;
      //cubes[cubeIndex].target(2, starts[cubeIndex][0], starts[cubeIndex][1], 90);
      cubes[cubeIndex].target(3, 20, 2, 50, 0, starts[cubeIndex][0], starts[cubeIndex][1], 90);
    }
    //else {
    //  print(cubeIndex);
    //  print(": ");
    //  print(landings[0][0]);
    //  print(", ");
    //  println(landings[0][1]);
    //  print(cubes[cubeIndex].x);
    //  print(", ");
    //  println(cubes[cubeIndex].y);
    //}
  }
