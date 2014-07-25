void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  stroke(#ed0081); 
  frameRate(8);
  loop();
}

float v = 0;

void draw() {
  
    if (v < 25) {
       v+=1;
       return; 
    }
    
     if (v > 500) {
        background(0);
        v = 0; 
        return;
     }
  
    if (v >= 476) {
        v+=1;
        return;
     }
     
     line(25, v, v, 475);
     line(v, 25, 475, v);
     v+=10;
     

     
    
   
}
