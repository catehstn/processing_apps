int[][] grid;
int food;
int dir;
boolean play;
ArrayList<Coord> snake;

int foodcolor = #FFA500;
int snakecolor = #32CD32;
int bg = 0;

int DIRECTION_D_up = 0;
int DIRECTION_D_down = 1;
int DIRECTION_D_left = 2;
int DIRECTION_D_right = 3;
int DIRECTION_NO_D = 4;

int STATE_NORMAL = 5;
int STATE_FOOD = 6;
int STATE_SNAKE = 7;

int size_xy;
int squaresize;
int numsquares;

int rate;
int count;

void setup() {
  size(495, 545);
  size_xy = 495;
  squaresize = 15;
  numsquares = size_xy/squaresize;

  initApp();
}

void initApp() {
  background(bg);
  rate = 5;
  count = 0;
  frameRate(rate);
  dir = DIRECTION_NO_D;
  play = true;
  grid = new int[numsquares][numsquares];
  for(int i = 0; i < numsquares; i++) {
    for (int j = 0; j < numsquares; j++) {
      grid[i][j] = STATE_NORMAL;
    }
  }

  snake = new ArrayList<Coord>();
  grid[numsquares-1][numsquares-1] = STATE_SNAKE;
  grid[numsquares-1][numsquares-2] = STATE_SNAKE;
  snake.add(new Coord(numsquares-1, numsquares-1));
  snake.add(new Coord(numsquares-2, numsquares-1));
  food = 0;

  int t = (int) (0.5 * squaresize);
  for(int i = 0; i < numsquares; i++) {
    for(int j = 0; j < numsquares; j++) {
      if(grid[i][j] == STATE_FOOD) {
        stroke(foodcolor);
        fill(foodcolor);
        ellipse(j*squaresize + t, (i*squaresize + t), squaresize-2, squaresize-2);
      }
      if(grid[i][j] == STATE_SNAKE) {
        stroke(snakecolor);
        fill(snakecolor);
        rect(j*squaresize, i*squaresize, squaresize, squaresize);
      }
    }
  }
  
  drawFood();
  drawScore();
}

void draw() {
  if (!play || dir == DIRECTION_NO_D) {
    return;
  }

  count++;

  Coord c = snake.get(snake.size() - 1).next(dir);
  if (c == null) {
    lose();
    return;
  }

  snake.add(c);
  snakeMove(c);

  int x = c.x;
  int y = c.y;

  if(grid[y][x] == STATE_FOOD) {
    food++;
    drawFood();
    rate+=1;
    frameRate(rate);
    drawScore();
  } else {
    c = snake.remove(0);
    clearCoord(c);
    grid[c.y][c.x] = STATE_NORMAL;
  }

  if (grid[y][x] == STATE_SNAKE) {
    lose();
  }

  grid[y][x] = STATE_SNAKE;
}

void snakeMove(Coord c) {
  stroke(snakecolor);
  fill(snakecolor);
  rect(c.x*squaresize, c.y*squaresize, squaresize, squaresize);
}

void clearCoord(Coord c) {
  stroke(bg);
  fill(bg);
  rect(c.x*squaresize, c.y*squaresize, squaresize, squaresize);
}

void drawFood() {
  while (true) {
    int tx = (int) random(numsquares);
    int ty = (int) random(numsquares);
    if (grid[ty][tx] == STATE_NORMAL) {
      grid[ty][tx] = STATE_FOOD;
      stroke(foodcolor);
      fill(foodcolor);
      ellipse(tx*squaresize + squaresize/2, ty*squaresize + squaresize/2, squaresize/2, squaresize/2);
      break;
    }
  }
}
  
void drawScore() {
  stroke(255);
  fill(0);
  rect(0, 496, 494, 50);
  stroke(255);
  fill(255);
  text("score: " + food, 15, 535);
}

void lose() {
  play = false;
  stroke(255);
  fill(0);
  rect(0, 496, 494, 50);
  stroke(255);
  fill(255);
  text("score: " + food + "                    lose", 15, 535);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (dir == DIRECTION_D_right) {
        return;
      }
      dir = DIRECTION_D_left;
      return;  
    }
    if (keyCode == RIGHT) {
      if (dir == DIRECTION_D_left) {
        return;
      }
      dir = DIRECTION_D_right;
      return;
    }
    if(keyCode == UP) {
      if (dir == DIRECTION_D_down) {
        return;
      }
      dir = DIRECTION_D_up;
      return;
    }
    if(keyCode == DOWN) {
      if (dir == DIRECTION_D_up) {
        return;
      }
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

class Coord {

  int x;
  int y;

  Coord(int x, int y) {
    this.x = x;
    this.y = y;
  }

  Coord next(int dir) {
    int newx = x;
    int newy = y;

    if (dir == DIRECTION_D_up) {
      newy--;
    } else if (dir == DIRECTION_D_down) {
      newy++;
    } else if (dir ==  DIRECTION_D_left) {
      newx--;
    } else if (dir ==  DIRECTION_D_right) {
      newx++;
    }

    if (newx < 0 || newx >= numsquares || newy < 0 || newy >= numsquares) {
      return null;
    }

    return new Coord(newx, newy);
  }
}

