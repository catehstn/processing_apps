void setup() 
{
  size(500, 500);  // Size should be the first statement
  
  xcoords = new float[numblobs];
  ycoords = new float[numblobs];
  totalblobs = numblobs;
  
  for (int i = 0; i < numblobs; i++) {
     xcoords[i] = random(width);
     ycoords[i] = random(height);  
  }
  
  loop();
}

float x = 250;
float y = 250;
float xsize = 10;
float ysize = 10;

int numblobs = 150;
int totalblobs;
int blobseaten = 0;
float[] xcoords;
float[] ycoords;
float smallblob = 2.5;

void draw() 
{ 
  
 if (numblobs < 1) {
     noLoop(); 
  }
  
  background(15);   // Set the background to black
  
  float xc = random(5);
  float yc = random(5);
 
  if (xc < 2) { x++; }
  else if (xc > 3) { x--; }
  if (yc < 2) { y++; }
  else if (yc > 3) { y--; }

  if (x >= width) { x = height-1; }  
  if (x <= 0 ) { x = 1; }
  if (y >= width) { y = width-1; }
  if (y <= 0 ) { y = 1; }
  
  stroke(#FF0066);
  fill(#FF0066);
  ellipse(x, y, xsize, ysize);
  
  // draw other blobs
  for (int i = 0; i < numblobs; i++) {
      float bx = xcoords[i];
      float by = ycoords[i];
      
      xc = random(5);
      yc = random(5);
 
      if (xc < 2) { bx+=2; }
      else if (xc > 3) { bx-=2; }
      if (yc < 2) { by+=2; }
      else if (yc > 3) { by-=2; }
      
      if (bx >= width) { bx = height-1; }  
      if (bx <= 0 ) { bx = 1; }
      if (by >= width) { by = width-1; }
      if (by <= 0 ) { by = 1; }
      
      xcoords[i] = bx;
      ycoords[i] = by;
      
      // make the color random
     
      float col = random(10);
      if (col < 2) {
         stroke(#FFFF00);
         fill(#FFFF00);
      }
      else if (col < 4) {
         stroke(#00CC33);
         fill(#00CC33);
      }
      else if (col < 6) {
         stroke(#6666FF);
         fill(#6666FF);
      }
      else if (col < 8) {
         stroke(#FF6600);
         fill(#FF6600);
      }
      else {
         stroke(#FFFFFF);
          fill(#FFFFFF);
      }
      
      ellipse(bx, by, smallblob, smallblob);
  }
  
  // check if any are overlapping
  int counter = 0;
  for (int i = 0; i < numblobs; i++) {
    // calculate the distance between that circle and the main one
    float dx = xcoords[i] - x;
    float dy = ycoords[i] - y;
    float py = sqrt(sq(dx) + sq(dy));

    float change = (1 - (totalblobs - numblobs) / totalblobs) * 2.5;
    if (py < (min(xsize, ysize)/2f) + smallblob) {
       if (dx < dy) {
          xsize += change; 
       }
       else {
          ysize += change; 
       }
       numblobs--;
    }
    else {
       xcoords[counter] = xcoords[i];
       ycoords[counter] = ycoords[i];
       counter++;
    }
  }
}



