import processing.opengl.*;

float ang;
float p=1;
int l = 0;

void setup()
{
  size(640, 480, OPENGL);

}


void draw()
{
  background(00);
  colorMode(RGB, 1); 
  noStroke();

  //set up some different colored lights
  pointLight(51, 102, 255, 65, 60, 100); 
  pointLight(200, 40, 60, -65, -60, -150);

 //raise overall light in scene 
  ambientLight(70, 70, 10); 
  
  translate(width/2, height/2, -200+mouseX);
  
  //rotate around y and x axes
  rotateY(radians(ang));
  rotateX(radians(ang));
  
  scale(30);
  
  beginShape(QUADS);

  fill(0, 1, 1); vertex(-1,  1,  1);
  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(1, 0, 1); vertex( 1, -1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);

  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);
  fill(1, 0, 1); vertex( 1, -1,  1);

  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(0, 0, 0); vertex(-1, -1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);

  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(0, 1, 1); vertex(-1,  1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);
  fill(0, 0, 0); vertex(-1, -1, -1);

  fill(0, 1, 0); vertex(-1,  1, -1);
  fill(1, 1, 0); vertex( 1,  1, -1);
  fill(1, 1, 1); vertex( 1,  1,  1);
  fill(0, 1, 1); vertex(-1,  1,  1);

  fill(0, 0, 0); vertex(-1, -1, -1);
  fill(1, 0, 0); vertex( 1, -1, -1);
  fill(1, 0, 1); vertex( 1, -1,  1);
  fill(0, 0, 1); vertex(-1, -1,  1);

  endShape();
  

  stroke(200);

  beginShape(QUADS);
  int j = 3; int k=3; int z=3;
  fill(0, 1, 1); vertex(-j,  k,  z);
  fill(1, 1, 1); vertex( j,  k,  z);
  fill(1, 0, 1); vertex( j, -k,  z);
  fill(0, 0, 1); vertex(-j, -k,  z);

  fill(1, 1, 1); vertex( j,  k,  z);
  fill(1, 1, 0); vertex( j,  k, -z);
  fill(1, 0, 0); vertex( j, -k, -z);
  fill(1, 0, 1); vertex( j, -k,  z);

  fill(1, 1, 0); vertex( j,  k, -z);
  fill(0, 1, 0); vertex(-j,  k, -z);
  fill(0, 0, 0); vertex(-j, -k, -z);
  fill(1, 0, 0); vertex( j, -k, -z);

  fill(0, 1, 0); vertex(-j,  k, -z);
  fill(0, 1, 1); vertex(-j,  k,  z);
  fill(0, 0, 1); vertex(-j, -k,  z);
  fill(0, 0, 0); vertex(-j, -k, -z);

  fill(0, 1, 0); vertex(-j,  k, -z);
  fill(1, 1, 0); vertex( j,  k, -z);
  fill(1, 1, 1); vertex( j,  k,  z);
  fill(0, 1, 1); vertex(-j,  k,  z);

  fill(0, 0, 0); vertex(-j, -k, -z);
  fill(1, 0, 0); vertex( j, -k, -z);
  fill(1, 0, 1); vertex( j, -k,  z);
  fill(0, 0, 1); vertex(-j, -k,  z);

  endShape();
  

  
  if(l==0){
    ang= ang + p;}
  else{
    ang=ang - p;
  }
}

  void mouseReleased() {
  if(l==0){l=1;}
  else{l=0;}
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      p++;
    } else if (keyCode == DOWN) {
      p--;
    } 
  } else {
   
  }
}


