private final int radius = 10;
private final int scale = 7;

private final double goldenangle = Math.PI * (3 - Math.sqrt(5));

private final int wh = 400;

private int r = 0;
private int g = 0;
private int b = 0;

private int n = 0;
private double a = 0;

public void setup() {
  size(400, 400);
  background(255, 255, 0);
}

public void draw() {
  if (g >= 255) {
    noLoop();
    return;
  }
  else if (r < 255) {
    r++;
  }
  else if (b < 255) {
    b++;
  }
  else {
    g++;
  }

  double h = Math.sqrt(n)*scale;
  double x = wh/2 + Math.sin(a) * h;
  double y = wh/2 + Math.cos(a) * h;
  a+=goldenangle;
  stroke(r, g, b);
  fill(r, g, b);
  ellipse((float) x, (float) y, radius, radius);

  n++;
}

