import processing.serial.*;
import grafica.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

Table table;
Table scopedTable;

void setup() {
  table = loadTable("meteors.csv", "header");
  
  scopedTable.addColumn("name", Table.STRING);
  scopedTable.addColumn("year", Table.INT);
  scopedTable.addColumn("reclat", Table.INT);
  scopedTable.addColumn("reclong", Table.INT);
  scopedTable.addColumn("mass", Table.STRING);
  
  scopedTable = scrawlYear(1990);//name year location mass
  
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
//name  id  nametype  recclass  mass (g)  fall  year  reclat  reclong  GeoLocation
Table scrawlYear(int meteorYear){
  scopedTable.clearRows();
  int i = 0;
  for (TableRow row : table.rows()) {
    if (row.getFloat("year") == meteorYear){
      newRow = scopedTable.addRow();
      
    } else {
    }
  }
  saveTable(scopedTable, "data/" + meteorYear + ".csv");
  return null;
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
