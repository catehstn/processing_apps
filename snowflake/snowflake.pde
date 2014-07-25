void setup() 
{
  size(500, 500);  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  background(0);
  
  noLoop();
}

float xmin = 20;
float ymin = 20;

void draw() {
      snowflake(250, 250, 230, 210, 2);    
}

void snowflake(float x, float y, float h, float a, int depth) {
   float x0 = x + polarX(h, a);
   float x1 = x + polarX(h, a + 120);
   float x2 = x + polarX(h, a  + 240);
   float y0 = y + polarY(h, a);
   float y1 = y + polarY(h, a + 120);
   float y2 = y + polarY(h, a + 240);
   
   depth--;
   line(x0, y0, x1, y1, h, a - 60, depth);
   line(x0, y0, x2, y2, h, a + 60, depth);
   line(x1, y1, x2, y2, h, a, depth);
}

void line(float x, float y, float x1, float y1, float h, float a, int depth) {
   if (depth < 1) {
     stroke(#ed0081);
      triangle(x, y, x1, y1, x + polarX(h, 120), y + polarY(h, 120));
      return;
   } 
   
   stroke(255);
   line(x, y, x1, y1);
   snowflake(x, y, h/3, a, depth);
}

float polarX(float distance, float angle) {
        return cos(angle*PI/180)*distance;
}

float polarY(float distance, float angle) {
        return (float) sin(angle*PI/180)*distance;
}
 
