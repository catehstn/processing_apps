public static final int DIRECTION_D_up = 0;
public static final int DIRECTION_D_down = 1;
public static final int DIRECTION_D_left = 2;
public static final int DIRECTION_D_right = 3;
public static final int DIRECTION_NO_D = 4;
  
private boolean play;
private int px;
private int py;
private int psize;
private int dir;
private int size_xy;
private int velocity;
private int change;
private int count;
private int playercolor;
private int freq;
private ArrayList<Thing> things;
private int thingsize;
private int score;
private int rate;
private int time;
  
void setup() {
  size(400, 450);
  size_xy = 400;
  psize = 50;
  freq = 10;
  velocity = 8;
  change = 5;
  thingsize = 25;
  rate = 10;
  frameRate(rate);
  
  playercolor = 255;
  
  initApp();
}
  
void initApp() {
  play = false;
  dir = DIRECTION_NO_D;
  background(0);
    
  px = (size_xy - psize) / 2;
  py = size_xy - 2*psize;
    
  drawplayer();
  things = new ArrayList<Thing>();
  drawScore();
}
  
void draw() {
  if (! play) {
    return;
  }
    
  count++;
    
  int newx = px;
  int newy = py;
    
  switch(dir) {
    case DIRECTION_D_up:
      newy-=velocity;
      break;
    case DIRECTION_D_down:
      newy+=velocity;
      break;
    case DIRECTION_D_right:
      newx+=velocity;
      break;
    case DIRECTION_D_left:
      newx-=velocity;
  }
    
  if (newx < 0 || newx > size_xy-psize || newy < (psize*2/3) || newy > size_xy) {
    return;
  }
    
  clearplayer();
  px = newx;
  py = newy;
  drawplayer();
    
  for(int i = 0; i < things.size(); i++) {
    Thing t = things.get(i);
    t.clear();
    t.move(change);
    if (t.y > size_xy) {
      things.remove(i);
    }
    else {
      t.drawThing();
    }
  }
   
  for(int i = 0; i < things.size(); i++) {
    Thing t = things.get(i);
    if (t.collide(px, py, psize)) {
      score+=t.getScore();
      t.clear();
      things.remove(i);
      drawScore();
    }
  }
    
  if (count%freq == 0) {
    count = 0;
    boolean sq = ((int) random(2) == 0) ? true : false;
    int red = (int) random(255);
    int green = (int) random(255);
    int blue = (int) random(255);
    int c = color(red, green, blue);
    int x = (int) random(size_xy);
    Thing t;
    if (sq) {
      t = new Square(x, 0, thingsize, c);
    }
    else {
      t = new Circle(x, 0, thingsize, c);
    }
    
    things.add(t);
    t.drawThing();
  }
    
  if (count%rate == 0) {
    time++;
    drawScore();
  }
    
  if (time%60 == 0 && time > 0) {
    rate++;
    frameRate(rate);
  }
}
  
void clearplayer() {
  stroke(0);
  fill(0);
  dp();
}
  
void drawplayer() {
  stroke(playercolor);
  fill(playercolor);
  dp();
}
  
void dp() {
  int x1 = px + psize;
  int x2 = px + psize/2;
  int y1 = py;
  int y2 = py - (psize*2/3);
  triangle(px, py, x1, y1, x2, y2);
}
  
void drawScore() {
  stroke(255);
  fill(0);
  rect(0, 402, 398, 50);
  stroke(255);
  fill(255);
  text("score: " + score + "                      time: " + time, 15, 440);
}
  
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      dir = DIRECTION_D_left;
      return;  
    }
    if (keyCode == RIGHT) {
      dir = DIRECTION_D_right;
      return;
    }
    if(keyCode == UP) {
      dir = DIRECTION_D_up;
      return;
    }
    if(keyCode == DOWN) {
      dir = DIRECTION_D_down;
      return;
    }
  }

  if (key == 'p') {
    if (play == true) {
      play = false;
    }
    else {
      play = true;
    }
  }
  if (key == 'r') {
    initApp();
  }
}
  
void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      dir = DIRECTION_NO_D;
      return;  
    }
    if (keyCode == RIGHT) {
      dir = DIRECTION_NO_D;
      return;
    }
    if(keyCode == UP) {
      dir = DIRECTION_NO_D;
      return;
    }
    if(keyCode == DOWN) {
      dir = DIRECTION_NO_D;
      return;
    }
  }  
}
  
class Thing {
  int x;
  int y;
  int size_xy;
  int colorV;

  public Thing(int x, int y, int size_xy, int colorV) {
    this.x = x;
    this.y = y;
    this.size_xy = size_xy;
    this.colorV = colorV;
  }
    
  private void move(int change) {
    y+=change;
  }
  
  // Must override in subclasses
  boolean collide(int px, int py, int psize) { return false; };  
  void clear() {}
  void drawThing() {}
  int getScore() { return 0; }
}
  
class Square extends Thing {
    
  int score = -2;
  
  private Square(int x, int y, int size_xy, int colorV) {
    super(x, y, size_xy, colorV);
  }
    
  public boolean collide(int px, int py, int psize) {
    if (y > py || py - y > size_xy + psize*2/3) {
      return false;
    }
    if (x < px || x - px > psize) {
      return false;
    }
    return true;
  }

  public void clear() {
    stroke(0);
    fill(0);
    rect(x, y, size_xy, size_xy);
  }

  public void drawThing() {
    stroke(colorV);
    fill(colorV);
    rect(x, y, size_xy, size_xy);
  }    
    
  public int getScore() {
    return score;
  }
}
  
class Circle extends Thing {
    
  int score = 1;
  
  private Circle(int x, int y, int size_xy, int colorV) {
    super(x, y, size_xy, colorV);
  }
    
  public boolean collide(int px, int py, int psize) {
    if (y - py > size_xy/2 || py - y > psize*2/3 + size_xy/2) {
      return false;
    }
      
    if (px - x > size_xy/2 || x - px > psize + size_xy/2) {
      return false;
    }
      
    return true;
  }

  public void clear() {
    stroke(0);
    fill(0);
    ellipse(x, y, size_xy, size_xy);
  }

  public void drawThing() {
    stroke(colorV);
    fill(colorV);
    ellipse(x, y, size_xy, size_xy);
  }
    
  public int getScore() {
    return score;
  }
}
