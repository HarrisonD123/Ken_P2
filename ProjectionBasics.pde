import processing.serial.*;
import grafica.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

//loadTable

void setup() {
  size(900, 900, P3D);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(700, 700, 20);
  offscreen = createGraphics(700, 700, P3D);
}

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
  offscreen.beginDraw();
  offscreen.background(255);
  offscreen.fill(#7CECED);
  offscreen.rect(100, 100, 500, 500);
  offscreen.fill(#11CC2B);
  offscreen.rect(100, 500, 500, 100);
  offscreen.fill(0, 0, 0);
  drawMeteor(surfaceMouse.x, surfaceMouse.y, 30);
  offscreen.circle(surfaceMouse.x, surfaceMouse.y, 30);
  offscreen.endDraw();
  background(0);
  surface.render(offscreen);
}

void drawMeteor(float x, float y, int z){
  offscreen.circle(x, y, z);
}

void keyPressed() {
  switch(key) {
  case 'c':
    ks.toggleCalibration();
    break;

  case 'l':
    ks.load();
    break;

  case 's':
    ks.save();
    break;
  }
}
