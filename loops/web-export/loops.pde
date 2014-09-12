int width = 500;
int height = 500;

void setup() {
   size(500, 500);
   background(236, 0 , 128);
   noLoop();
}

void draw() {
  stroke(140, 9, 214);
  int inc = 50;
  int radius = width - inc;
  int n = radius/inc;
  int x = width/2;
  int y = width/2;

 for(int i = 0; i < n; i++) {
    if (i%2 == 0) {
      fill(255, 126, 0);
     }
     else {
       fill(238);
     }

     ellipse(x, y, radius, radius);
     radius = radius - inc;
  }
}

