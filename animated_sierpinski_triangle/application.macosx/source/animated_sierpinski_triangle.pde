void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  frameRate(3);
  loop();
}


int depth = 1;

void draw() {
  
     if (depth > 20) {
       depth = 1; 
    }
  
    if (depth > 10) {
       depth++;
       return;
    }
  
      striangle(250, 20, 460, depth); 
   
     depth++;   
}


void striangle(float x, float y, float h, int depth) {
    if (depth < 1) {
       return; 
    }
    
    // set the color
    if (depth % 2 == 0) {
          stroke(#ed0081);
          fill(#ed0081); 
      }
      else {
         stroke(#FFFFFF);
         fill(#FFFFFF);
      }
    
    // draw the triangle
    float a = sqrt((3 * h * h) / 4);
    triangle(x, y, x - h/2, y + a, x + h/2, y + a);
    
    // divide
    float nh = h / 2;
    depth--;
    a = sqrt((3 * h * h) / 16);
    striangle(x, y, nh, depth);
    striangle(x - h/4, y + a, nh, depth);
    striangle(x + h/4, y + a, nh, depth);
}


