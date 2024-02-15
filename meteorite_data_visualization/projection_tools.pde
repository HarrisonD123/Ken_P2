import processing.serial.*;
import grafica.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

Table table;
Table scopedTable = new Table();

PImage[] fire = new PImage[24];
PImage crater;

void drawRock(int x, int y, int z){
  offscreen.fill(135);
  offscreen.circle(x, y, z);
}

//assume width 30, as its the meteor width
void drawMeteor(int x, int y, int z){
  offscreen.image(fire[frameCount%24], x-30, y-70, 60, 80);
  drawRock(x, y, z);
}

//would recommend 40 for small, scale up as needed :3
void drawCrater(int x, int y, float size){
  offscreen.image(crater, x-size/2, y-(size/4), size, size/2);
}

void drawLabel(float x, float y, Meteor met){
  offscreen.fill(255);
  offscreen.rect(x + 10, y - 60, 200, 50);
  offscreen.fill(0);
  textSize(128);
  offscreen.text(met.name, x + 15, y - 45);
  textSize(96);
  offscreen.text(met.mass, x + 15, y - 30);
  offscreen.text(met.geoLoc, x + 15, y - 18);
}

//name  id  nametype  recclass  mass (g)  fall  year  reclat  reclong  GeoLocation
//name year reclat reclong mass
Table filter_table(int meteorYear, float minMass, float maxMass){
  scopedTable.clearRows();
  for (TableRow row : table.rows()) {
    float mass = row.getFloat("mass (g)");
    if (row.getFloat("year") == meteorYear && mass >= minMass && mass <= maxMass ){
      TableRow newRow = scopedTable.addRow();
      newRow.setString("name", row.getString("name"));
      newRow.setInt("year", row.getInt("year"));
      newRow.setString("GeoLocation", row.getString("GeoLocation"));
      newRow.setFloat("mass", row.getFloat("mass (g)"));
    } else {
    }
  }
  println(table.getRowCount());
  println(scopedTable.getRowCount());
  //saveTable(scopedTable, "data/" + meteorYear + ".csv");
  return scopedTable;
}

float convToProj(int toioCoord){
  return map(toioCoord, 45, 455, 0, 700);
}

//convert any table to arraylist of tables
ArrayList<Meteor> tableToArray(Table scrawl){
  ArrayList<Meteor> meteorites = new ArrayList<Meteor>();
  for (TableRow row : scrawl.rows()) {
    Meteor met = new Meteor();
    met.name = row.getString("name");
    met.year = row.getInt("year");
    met.mass = row.getFloat("mass");
    met.geoLoc = row.getString("GeoLocation");
    meteorites.add(met);
  }
  return meteorites;
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
