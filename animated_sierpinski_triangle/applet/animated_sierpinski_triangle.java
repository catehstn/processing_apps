import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import java.util.regex.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class animated_sierpinski_triangle extends PApplet {public void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  frameRate(3);
  loop();
}


int depth = 1;

public void draw() {
  
     if (depth > 15) {
       depth = 1; 
    }
  
    if (depth > 10) {
       depth++;
       return;
    }
    
   
      
  
      striangle(250, 20, 460, depth); 
   
     depth++;   
}


public void striangle(float x, float y, float h, int depth) {
    if (depth < 1) {
       return; 
    }
    
    // set the color
    if (depth % 2 == 0) {
          stroke(0xffed0081);
          fill(0xffed0081); 
      }
      else {
         stroke(0xffFFFFFF);
         fill(0xffFFFFFF);
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


  static public void main(String args[]) {     PApplet.main(new String[] { "animated_sierpinski_triangle" });  }}