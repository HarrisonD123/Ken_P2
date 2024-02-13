import processing.serial.*;
import grafica.*;
void setup()
{
  size(700,700);
  
  printArray(Serial.list());
}
void draw()
{
  drawBack();
  drawMeteor(mouseX, mouseY);
}

void drawBack(){
  fill(153);
  rect(0, 0, 700, 700);
  fill(#7CECED);
  rect(100, 100, 500, 500);
  fill(#11CC2B);
  rect(100, 500, 500, 100);
}

void drawMeteor(int mouseX, int mouseY){
  fill(0);
  circle(mouseX, mouseY, 30);
}
