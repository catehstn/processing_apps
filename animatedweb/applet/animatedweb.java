import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class animatedweb extends PApplet {

public void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  stroke(0xffed0081); 
  frameRate(8);
  loop();
}

float v = 0;

public void draw() {
  
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

  static public void main(String args[]) {
    PApplet.main(new String[] { "animatedweb" });
  }
}
