static final String INSTRUCTIONS = "R: increase red filter\nE: reduce red filter\n"
      + "G: increase green filter\nF: reduce green filter\nB: increase blue filter\n"
      + "V: reduce blue filter\nI: increase hue tolerance\nU: reduce hue tolerance\n"
      + "S: show dominant hue\nH: hide dominant hue\nP: process image\n"
      + "C: choose a new file\nW: save file\nSPACE: reset image";

static final int FILTER_HEIGHT = 2;
static final int FILTER_INCREMENT = 5;
static final int HUE_INCREMENT = 2;
static final int HUE_RANGE = 100;
static final int IMAGE_MAX = 640;
static final int RGB_COLOR_RANGE = 100;
static final int SIDE_BAR_PADDING = 10;
static final int SIDE_BAR_WIDTH = RGB_COLOR_RANGE + 2 * SIDE_BAR_PADDING + 50;

int imgWidth = IMAGE_MAX + 1;
int imgHeight = IMAGE_MAX + 1;

private ImageState imageState;

boolean redrawImage = true;

public void setup() {
  noLoop();
  imageState = new ImageState();

  // Set up the view.
  size(760, 640);
  background(0);

  chooseFile();
}

public void draw() {
  if (imageState.image == null) {
    return;
  }
  
  // Draw image.
  else if (redrawImage) {
    background(0);
    drawImage();
  }

  colorMode(RGB, RGB_COLOR_RANGE);
  fill(0);
  rect(IMAGE_MAX, 0, SIDE_BAR_WIDTH, IMAGE_MAX);
  stroke(RGB_COLOR_RANGE);
  line(IMAGE_MAX, 0, IMAGE_MAX, IMAGE_MAX);

  // Draw red line
  int x = IMAGE_MAX + SIDE_BAR_PADDING;
  int y = 2 * SIDE_BAR_PADDING;
  stroke(RGB_COLOR_RANGE, 0, 0);
  line(x, y, x + RGB_COLOR_RANGE, y);
  line(x + imageState.redFilter(), y - FILTER_HEIGHT,
      x + imageState.redFilter(), y + FILTER_HEIGHT);
  // Draw green line
  y += 2 * SIDE_BAR_PADDING;
  stroke(0, RGB_COLOR_RANGE, 0);
  line(x, y, x + RGB_COLOR_RANGE, y);
  line(x + imageState.greenFilter(), y - FILTER_HEIGHT,
      x + imageState.greenFilter(), y + FILTER_HEIGHT);

  // Draw blue line
  y += 2 * SIDE_BAR_PADDING;
  stroke(0, 0, RGB_COLOR_RANGE);
  line(x, y, x + RGB_COLOR_RANGE, y);
  line(x + imageState.blueFilter(), y - FILTER_HEIGHT,
      x + imageState.blueFilter(), y + FILTER_HEIGHT);

  // Draw white line.
  y += 2 * SIDE_BAR_PADDING;
  stroke(HUE_RANGE);
  line(x, y, x + 100, y);
  line(x + imageState.hueTolerance(), y - FILTER_HEIGHT,
      x + imageState.hueTolerance(), y + FILTER_HEIGHT);

  y += 4 * SIDE_BAR_PADDING;
  fill(RGB_COLOR_RANGE);
  text(INSTRUCTIONS, x, y);

  updatePixels();
}

// Callback for selectInput(), has to be public to be found.
public void fileSelected(String url) {
  if (url == null) {
    println("User hit cancel.");
  } else {
    imageState.setUrl(url);
    imageState.setUpImage(IMAGE_MAX);
    redrawImage = true;
    redraw();
  }
}

private void drawImage() {
  imageMode(CENTER);
  imageState.updateImage(HUE_RANGE, RGB_COLOR_RANGE);
  image(imageState.image, IMAGE_MAX/2, IMAGE_MAX/2, imgWidth, imgHeight);
  redrawImage = false;
}

// @Override
public void keyPressed() {
  switch(key) {
  case 'c':
    chooseFile();
    break;
  case 'p':
    redrawImage = true;
    break;
  case 'w':
    imageState.image.save(day() + hour() + minute() + second() + "-new.png");
    break;
  case ' ':
    imageState.resetImage(IMAGE_MAX);
    redrawImage = true;
    break;
  }
  imageState.processKeyPress(key, FILTER_INCREMENT, RGB_COLOR_RANGE, HUE_INCREMENT, HUE_RANGE);
  redraw();
}

private void chooseFile() {
  // Choose the file.
 // selectInput("Select a file to process:", "fileSelected");
 String url = window.prompt("Enter an image URL", null);
 if (url != null) {
   fileSelected(url);
 }
}

public boolean hueInRange(float hue, int hueRange, float lower, float upper) {
  // Need to compensate for it being circular - can go around.
  if (lower < 0) {
    lower += hueRange;
  }
  if (upper > hueRange) {
    upper -= hueRange;
  }
  if (lower < upper) {
    return hue < upper && hue > lower;
  } else {
    return hue < upper || hue > lower;
  }
}

public HSBColor getDominantHue(PImage image, int hueRange) {
  image.loadPixels();
  int numberOfPixels = image.pixels.length;
  int[] hues = new int[hueRange];
  float[] saturations = new float[hueRange];
  float[] brightnesses = new float[hueRange];

  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = image.pixels[i];
    int hue = round(hue(pixel));
    float saturation = saturation(pixel);
    float brightness = brightness(pixel);
    hues[hue]++;
    saturations[hue] += saturation;
    brightnesses[hue] += brightness;
  }

  // Find the most common hue.
  int hueCount = hues[0];
  int hue = 0;
  for (int i = 1; i < hues.length; i++) {
    if (hues[i] > hueCount) {
      hueCount = hues[i];
      hue = i;
    }
  }

  // Return the color to display.
  float s = saturations[hue] / hueCount;
  float b = brightnesses[hue] / hueCount;
  return new HSBColor(hue, s, b);
}

public void processImageForHue(PImage image, int hueRange,
    int hueTolerance, boolean showHue) {
  colorMode(HSB, (hueRange - 1));
  image.loadPixels();
  int numberOfPixels = image.pixels.length;
  HSBColor dominantHue = getDominantHue(image, hueRange);
  // Manipulate photo, grayscale any pixel that isn't close to that hue.
  float lower = dominantHue.h - hueTolerance;
  float upper = dominantHue.h + hueTolerance;
  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = image.pixels[i];
    float hue = hue(pixel);
    if (hueInRange(hue, hueRange, lower, upper) == showHue) {
      float brightness = brightness(pixel);
      image.pixels[i] = color(brightness);
    }
  }
  image.updatePixels();
}

public void applyColorFilter(PImage image, int minRed,
    int minGreen, int minBlue, int colorRange) {
  colorMode(RGB, colorRange);
  image.loadPixels();
  int numberOfPixels = image.pixels.length;
  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = image.pixels[i];
    float alpha = alpha(pixel);
    float red = red(pixel);
    float green = green(pixel);
    float blue = blue(pixel);

    red = (red >= minRed) ? red : 0;
    green = (green >= minGreen) ? green : 0;
    blue = (blue >= minBlue) ? blue : 0;

    image.pixels[i] = color(red, green, blue, alpha);
  }
}

public class ImageState {

  int ColorMode_COLOR_FILTER = 0;
  int ColorMode_SHOW_DOMINANT_HUE = 1;
  int ColorMode_HIDE_DOMINANT_HUE = 2;

  PImage image;
  String url;

  public static final int INITIAL_HUE_TOLERANCE = 5;

  int colorModeState = ColorMode_COLOR_FILTER;
  int blueFilter = 0;
  int greenFilter = 0;
  int hueTolerance = 0;
  int redFilter = 0;

  public ImageState() {
    image = null;
    hueTolerance = INITIAL_HUE_TOLERANCE;
  }

  public int blueFilter() {
    return blueFilter;
  }

  public int greenFilter() {
    return greenFilter;
  }

  public int redFilter() {
    return redFilter;
  }

  public int hueTolerance() {
    return hueTolerance;
  }

  public int getColorMode() {
    return colorModeState;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String url() {
    return url;
  }

  public void updateImage(int hueRange, int rgbColorRange) {
    image = null;
    image = loadImage(url);
    if (colorModeState == ColorMode_SHOW_DOMINANT_HUE) {
      processImageForHue(image, hueRange, hueTolerance, true);
    } else if (colorModeState == ColorMode_HIDE_DOMINANT_HUE) {
      processImageForHue(image, hueRange, hueTolerance, false);
    }
    applyColorFilter(image, redFilter, greenFilter,
        blueFilter, rgbColorRange);
    image.updatePixels();
  }

  public void processKeyPress(char key, int inc, int rgbColorRange, int hueIncrement, int hueRange) {
    switch (key) {
    case 'r':
      redFilter += inc;
      redFilter = Math.min(redFilter, rgbColorRange);
      break;
    case 'e':
      redFilter -= inc;
      redFilter = Math.max(redFilter, 0);
      break;
    case 'g':
      greenFilter += inc;
      greenFilter = Math.min(greenFilter, rgbColorRange);
      break;
    case 'f':
      greenFilter -= inc;
      greenFilter = Math.max(greenFilter, 0);
      break;
    case 'b':
      blueFilter += inc;
      blueFilter = Math.min(blueFilter, rgbColorRange);
      break;
    case 'v':
      blueFilter -= inc;
      blueFilter = Math.max(blueFilter, 0);
      break;
    case 'i':
      hueTolerance += hueIncrement;
      hueTolerance = Math.min(hueTolerance, hueRange);
      break;
    case 'u':
      hueTolerance -= hueIncrement;
      hueTolerance = Math.max(hueTolerance, 0);
      break;
    case 'h':
      if (colorModeState == ColorMode_HIDE_DOMINANT_HUE) {
        colorModeState = ColorMode_COLOR_FILTER;
      } else {
        colorModeState = ColorMode_HIDE_DOMINANT_HUE;
      }
      break;
    case 's':
      if (colorModeState == ColorMode_SHOW_DOMINANT_HUE) {
        colorModeState = ColorMode_COLOR_FILTER;
      } else {
        colorModeState = ColorMode_SHOW_DOMINANT_HUE;
      }
      break;
    }
  }

  public void setUpImage(int imageMax) {
    imgWidth = IMAGE_MAX + 1;
    imgHeight = IMAGE_MAX + 1;
    image = null;
    image = loadImage(url);
    // Fix the size.
    if (imgWidth > imageMax || imgHeight > imageMax) {
      imgWidth = imageMax;
      imgHeight = imageMax;
      if (image.width > image.height) {
        imgHeight = (imgHeight * image.height) / image.width;
      } else {
        imgWidth = (imgWidth * image.width) / image.height;
      }
      
      print("wh: " + imgWidth + ", " + imgHeight);
      image.resize(imgWidth, imgHeight);
    }
  }

  public void resetImage(int imageMax) {
    redFilter = 0;
    greenFilter = 0;
    blueFilter = 0;
    hueTolerance = INITIAL_HUE_TOLERANCE;
    colorModeState = ColorMode_COLOR_FILTER;
    imgWidth = IMAGE_MAX + 1;
    imgHeight = IMAGE_MAX + 1;
    setUpImage(imageMax);
  }
}

public class HSBColor {

  public final float h;
  public final float s;
  public final float b;

  public HSBColor(float h, float s, float b) {
    this.h = h;
    this.s = s;
    this.b = b;
  }
}
