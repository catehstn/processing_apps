private int size_xy = 600;
private int margin = 10;
private int dark;
private int light;
  
public void setup() {
  size(620, 620);
  noLoop();
}
  
public void draw() {
  dark = #FF1493;
  light = #FFFF00;
  marble(margin, margin, size_xy, 9, mix(dark, light));
}

private void marble(float x, float y, float sizeV, int depth, int colorV) {
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
    
  int c1 = mix(colorV, dark);
  int c2 = mix(colorV, light);
    
  marble(x, y, sizeV, depth, c1);
  marble(x1, y1, sizeV, depth, c1);
  marble(x, y1, sizeV, depth, c2);
  marble(x1, y, sizeV, depth, c2);
}
  
private int mix(int c1, int c2) {
  return (int) (0.6f * c1 + 0.4f * c2);
}
