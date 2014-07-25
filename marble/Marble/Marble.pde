private int size_xy = 600;
private int margin = 10;
private int dark = 0;
private int light = 255;
  
void setup() {
  size(620, 620);
  noLoop();
}
  
void draw() {
  marble(margin, margin, size_xy, 8, mix(dark, light));
}

void marble(float x, float y, float sizeV, int depth, float colorV) {
  if (depth < 1) {
    fill(colorV);
    stroke(colorV);
    rect(x, y, sizeV, sizeV);
    return;
  }
    
  depth--;
  sizeV = sizeV/2;
  float x1 = x + sizeV;
  float y1 = y + sizeV;
  
  float c1 = mix(colorV, dark);
  float c2 = mix(colorV, light);
  
  marble(x, y, sizeV, depth, c1);
  marble(x1, y1, sizeV, depth, c1);
  marble(x, y1, sizeV, depth, c2);
  marble(x1, y, sizeV, depth, c2);
}
  
private float mix(float c1, float c2) {
  return 0.8f * c1 + 0.2f * c2;
}
