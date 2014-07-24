/*  TULIP Algorithm Implementation 
    
    Copyright (C) 2014  scubAssist
    -------------------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
    ------------------------------------------------------------------------- 
    
    FAST position calculation based on 3 known points and the distance to those points 
    Implemented for processing (2.0+) by J. Tigchelaar for use in buddyAssist project 
*/


PVector p1, p2, p3;            // Holds the positions of the buoys
float d1, d2, d3;              // The distances measured to the buoys
PVector position;              // The calculated position of the diver

int selectedBoei = 1;          // For UI purposes, the currently selected buoy

/* Setup */
void setup() {
  size(800,600);               // Change to a suitable size
 
  p1 = new PVector(0, 0);      // Position of buoy 1
  p2 = new PVector(200, 1);    // Position of buoy 2
  p3 = new PVector(100, 250);  // Position of buoy 3
  
  position = new PVector(0,0); // Initial diver position
 
  d1 = 150;                    // Initial distance to buoy 1
  d2 = 150;                    // Initial distance to buoy 2
  d3 = 250;                    // Initial distance to buoy 3
}

/* Using the TULIP Algorithm, calculate the diver's position */
void calculatePosition(){
  float i1=p1.x;               // X Position of buoy 1
  float i2=p2.x;               // X Position of buoy 2
  float i3=p3.x;               // X Position of buoy 3
  
  float j1=p1.y;               // Y Position of buoy 1
  float j2=p2.y;               // Y Position of buoy 2
  float j3=p3.y;               // Y Position of buoy 3
  
  /* TULIP for X */
  position.x = ((((pow(d1,2)-pow(d2,2)) + (pow(i2,2)-pow(i1,2)) + (pow(j2,2)-pow(j1,2))) * (2*j3-2*j2) - ((pow(d2,2)-pow(d3,2)) + (pow(i3,2)-pow(i2,2)) + (pow(j3,2)-pow(j2,2))) * (2*j2-2*j1)) / ((2*i2-2*i3) * (2*j2-2*j1) - (2*i1-2*i2) * (2*j3-2*j2)));

  /* TULIP for Y */
  position.y = ( (pow(d1,2)-pow(d2,2)) + (pow(i2,2)-pow(i1,2)) + (pow(j2,2)-pow(j1,2)) + position.x * (2*i1-2*i2) ) / (2*j2-2*j1);
}

/* Draw the background reference grid */
void drawGrid(){
  stroke(255, 255, 255, 50);
  for (int xg = 0; xg < width; xg += 10) {
    line(xg,0,xg,height);
  }
  for (int yg = 0; yg < height; yg += 10) {
    line(0,yg,width,yg);
  }  
}

/* UI Key handling routine */
void keyPressed(){
  if (keyPressed) {
    if (key == '1') {
      selectedBoei = 1;
    }
    if (key == '2') {
      selectedBoei = 2;
    }
    if (key == '3') {
      selectedBoei = 3;
    }
    if (key == CODED) {
      if (keyCode == UP) {
        if (selectedBoei == 1) {
          d1 += 1;
        }
        if (selectedBoei == 2) {
          d2 += 1;
        }
        if (selectedBoei == 3) {
          d3 += 1;
        }
      } else if (keyCode == DOWN) {
        if (selectedBoei == 1) {
          d1 -= 1;
        }
        if (selectedBoei == 2) {
          d2 -= 1;
        }
        if (selectedBoei == 3) {
          d3 -= 1;
        }
      } 
    } 
  }
}

/* Main draw routine */
void draw() {
  background(0);                                        // Clear the background
  drawGrid();                                           // Draw the grid
  
  calculatePosition();                                  // Perform TULIP Calculation
  
  text("x = " + position.x, 10, 10);                    // Display Diver X position
  text("y = " + position.y, 10, 20);                    // Display Diver Y position
  
  translate(300,200);                                   // Translate the actual positions
  
  noFill();                                             // Do not fill the circles
  
  stroke(255, 0, 0);                                    // Red
  ellipse(p1.x, p1.y, d1 * 2, d1 * 2);                  // Circle P1
  text("p1 (" + p1.x + ", " + p1.y + ")", p1.x, p1.y);  // Coordinate
  
  stroke(0, 255, 0);                                    // Green
  ellipse(p2.x, p2.y, d2 * 2, d2 * 2);                  // Circle P2
  text("p2 (" + p2.x + ", " + p2.y + ")", p2.x, p2.y);  // Coordinate
  
  stroke(0, 0, 255);                                    // Blue
  ellipse(p3.x, p3.y, d3 * 2, d3 * 2);                  // Circle P3
  text("p3 (" + p3.x + ", " + p3.y + ")", p3.x, p3.y);  // Coordinate
  
  stroke(128, 0, 0);                                    // Brown
  ellipse(position.x, position.y, 2, 2);                // Diver point
  text("d (" + position.x + ", " + position.y + ")", 
            position.x, position.y);                    // Diver coordinate
}
