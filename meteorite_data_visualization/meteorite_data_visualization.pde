ArrayList<Float> meteorites = new ArrayList<Float>(); // List of meteorites implemented as a queue.

//int meteoriteMass = meteoriteMasses[0];
float minMass = 0;
float maxMass = 100;

boolean falling[];

int prevLoc[] = {0, 0}; // 2D Array per toio as well ------------------------- TODO

int timeOfLastUpdate = millis();

int[][] starts = {{120, 70}, {170, 70}, {220, 70}, {270, 70}, {320, 70}, {370, 70}, {420, 70}}; // top dark strip
int[][] targets = {{120, 400}, {170, 400}, {220, 400}, {270, 400}, {320, 400}, {370, 400}, {420, 400}}; // End of animation
int[][] ends = {{120, 430}, {170, 430}, {220, 430}, {270, 430}, {320, 430}, {370, 430}, {420, 430}}; // Bottom dark strip
int[] bottom_left = {70, 430}; // Bottom of left dark strip
int[] top_left = {70, 70}; // Top of left dark strip

void meteor_fall(int cubeIndex, float meteoriteMass) {
  int massSpeed = (int)map(meteoriteMass, minMass, maxMass, 10, 255);
  if (!falling[cubeIndex]) { // On first call of a meteor's fall
    targets[cubeIndex][0] = 250;
    targets[cubeIndex][1] = 400;
    cubes[cubeIndex].target(0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
    timeOfLastUpdate = millis();
    prevLoc[0] = cubes[cubeIndex].x;
    prevLoc[1] = cubes[cubeIndex].y;
    falling[cubeIndex] = true;
  }
  
  else { // Subsequent calls while falling
    if (millis() - timeOfLastUpdate > 100) {
      if (abs(prevLoc[0] - cubes[cubeIndex].x) < 2 && abs(prevLoc[1] - cubes[cubeIndex].y) < 2) {
        cubes[0].motor(-massSpeed, -massSpeed, 50);
        print("Pushing: ");
        println(massSpeed);
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
        prevLoc[0] = cubes[cubeIndex].x;
        prevLoc[1] = cubes[cubeIndex].y;
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
      if (abs(250 - cubes[cubeIndex].x) > 20 || abs(400 - cubes[cubeIndex].y) > 20) {
        println("Targeting");
        cubes[cubeIndex].target(0, targets[cubeIndex][0], targets[cubeIndex][1], 90);
      }
      else {
        falling[cubeIndex] = false;
        Float removed = meteorites.remove(0);
        print("Removed:");
        println(removed);
        println("Delay start");
        delay(2000);
        println("Delay end");
        targets[cubeIndex][0] = starts[cubeIndex][0];
        targets[cubeIndex][1] = starts[cubeIndex][1];
      }
    }
  }
  
}
