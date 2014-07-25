void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  stroke(#ed0081);
}



void draw() {
  
  for (float v = 25f; v < 476; v+=10) {
     line(25, v, v, 475);
     line(v, 25, 475, v);
  }
   
}


