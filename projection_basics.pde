/*
Created by:
  Jay Weeks
On Date:
  26-Oct-2018
Purpose:
  This program will graph coordinate pairs, sent from the
  microcontroller, through Serial.

Function:
  Accept Serial string and print to terminal.
  Tokenize string, save as coordinate pair, print to terminal.
  Plot coordinate pairs.
  Formatted and cleaned up.
Plan:
*/

//~~~~~~~~
//~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Libraries
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Serial library
import processing.serial.*;
import grafica.*;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Variables and Objects
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Serial
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Serial myPort;  // The Serial port
String inBuffer;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Data
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
String[] token;
int x, y;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Graph
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GPlot plot1;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Setup
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void setup()
{
  size(700,700);
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Initialize Serial Port
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want
  myPort = new Serial(this, Serial.list()[1],9600);
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Set Up Plot
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  plot1 = new GPlot(this);
  plot1.setPos(0,0);
  plot1.setDim(600, 600);
  //plot1.getTitle().setText("Title");
  //plot1.getXAxis().getAxisLabel().setText("XLabel");
  //plot1.getYAxis().getAxisLabel().setText("YLabel");
  plot1.setPointColor(color(0,0,0,255));
  plot1.setPointSize(2);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Draw
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void draw()
{
  background (0);
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Read Port
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Is there a string in the port to read?
  while (myPort.available() > 0)
  {
    // Read a string in
    inBuffer = myPort.readString();
    // Did we actually read anything in?
    if (inBuffer != null)
    { // We did
      // Split that string into tokens
      token = splitTokens(inBuffer);
      // Convert those strings to integers
      x = Integer.parseInt(token[0]);
      y = Integer.parseInt(token[1]);
      // Print the point to terminal
      print(x);
      print("\t");
      println(y);
      // Add the new point to the graph
      plot1.addPoint(x, y);
    }
  }
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Draw Plot
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  plot1.beginDraw();
  plot1.drawBackground();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.drawGridLines(GPlot.BOTH);
  plot1.drawPoints();
  plot1.endDraw();
}
