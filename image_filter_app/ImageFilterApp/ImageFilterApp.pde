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
static final int SIDE_BAR_WIDTH = RGB_COLOR_RANGE + 2 * SIDE_BAR_PADDING + 100;

int imgWidth = IMAGE_MAX + 1;
int imgHeight = IMAGE_MAX + 1;

private ImageState imageState;

boolean redrawImage = true;

public void setup() {
  noLoop();
  imageState = new ImageState();

  // Set up the view.
  size(810, 640);
  background(0);

  chooseFile();
}

public void draw() {
  if (imageState.pimage == null) {
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
  line(x + imageState.getRedFilter(), y - FILTER_HEIGHT,
      x + imageState.getRedFilter(), y + FILTER_HEIGHT);
  // Draw green line
  y += 2 * SIDE_BAR_PADDING;
  stroke(0, RGB_COLOR_RANGE, 0);
  line(x, y, x + RGB_COLOR_RANGE, y);
  line(x + imageState.getGreenFilter(), y - FILTER_HEIGHT,
      x + imageState.getGreenFilter(), y + FILTER_HEIGHT);

  // Draw blue line
  y += 2 * SIDE_BAR_PADDING;
  stroke(0, 0, RGB_COLOR_RANGE);
  line(x, y, x + RGB_COLOR_RANGE, y);
  line(x + imageState.getBlueFilter(), y - FILTER_HEIGHT,
      x + imageState.getBlueFilter(), y + FILTER_HEIGHT);

  // Draw white line.
  y += 2 * SIDE_BAR_PADDING;
  stroke(HUE_RANGE);
  line(x, y, x + 100, y);
  line(x + imageState.getHueTolerance(), y - FILTER_HEIGHT,
      x + imageState.getHueTolerance(), y + FILTER_HEIGHT);

  y += 4 * SIDE_BAR_PADDING;
  fill(RGB_COLOR_RANGE);
  text(INSTRUCTIONS, x, y);
  
 // updatePixels();
}

// Called with image URL.
public void fileSelected(String url) {
  if (url == null) {
    println("User hit cancel.");
  } else {
    println("loading image from: " + url);
    imageState.setUrl(url);
    imageState.setUpImage(IMAGE_MAX);
    redrawImage = true;
    redraw();
  }
}

private void drawImage() {
  println("starting redraw");
  imageMode(CENTER);
  imageState.updateImage(HUE_RANGE, RGB_COLOR_RANGE);
  image(imageState.pimage, int(IMAGE_MAX/2), int(IMAGE_MAX/2), imgWidth, imgHeight);
  redrawImage = false;
  println("ending redraw");
}

public void keyPressed() {
  switch(key) {
    case 'c':
      chooseFile();
      break;
    case 'p':
      redrawImage = true;
      break;
    case 'w':
      imageState.pimage.save(day() + hour() + minute() + second() + "-new.png");
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
 String url = "https://c2.staticflickr.com/8/7060/6983342195_3492a66098_z.jpg";
 prompt("Enter an image URL", null);
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

public HSBColor getDominantHue(PImage pimage, int hueRange) {
  pimage.loadPixels();
  int numberOfPixels = pimage.pixels.length;
  int[] hues = new int[hueRange];
  float[] saturations = new float[hueRange];
  float[] brightnesses = new float[hueRange];

  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = pimage.pixels[i];
    int hueVal = round(hue(pixel));
    float saturationVal = saturation(pixel);
    float brightnessVal = brightness(pixel);
    hues[hueVal]++;
    saturations[hueVal] += saturationVal;
    brightnesses[hueVal] += brightnessVal;
  }

  // Find the most common hue.
  int hueCount = hues[0];
  int hueVal = 0;
  for (int i = 1; i < hues.length; i++) {
    if (hues[i] > hueCount) {
      hueCount = hues[i];
      hueVal = i;
    }
  }

  // Return the color to display.
  float s = saturations[hueVal] / hueCount;
  float b = brightnesses[hueVal] / hueCount;
  return new HSBColor(hueVal, s, b);
}

public void processImageForHue(PImage pimage, int hueRange,
    int hueTolerance, boolean showHue) {
  colorMode(HSB, (hueRange - 1));
  pimage.loadPixels();
  int numberOfPixels = pimage.pixels.length;
  HSBColor dominantHue = getDominantHue(pimage, hueRange);
  // Manipulate photo, grayscale any pixel that isn't close to that hue.
  float lower = dominantHue.h - hueTolerance;
  float upper = dominantHue.h + hueTolerance;
  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = pimage.pixels[i];
    float hueVal = hue(pixel);
    if (hueInRange(hueVal, hueRange, lower, upper) == showHue) {
      float brightnessVal = brightness(pixel);
      pimage.pixels[i] = color(brightnessVal);
    }
  }
  pimage.updatePixels();
}

public void applyColorFilter(PImage pimage, int minRed,
    int minGreen, int minBlue, int colorRange) {
  colorMode(RGB, colorRange);
  pimage.loadPixels();
  int numberOfPixels = pimage.pixels.length;
  
  for (int i = 0; i < numberOfPixels; i++) {
    int pixel = pimage.pixels[i];
    float alphaVal = alpha(pixel);
    float redVal = red(pixel);
    float greenVal = green(pixel);
    float blueVal = blue(pixel);

    redVal = (redVal >= minRed) ? redVal : 0;
    greenVal = (greenVal >= minGreen) ? greenVal : 0;
    blueVal = (blueVal >= minBlue) ? blueVal : 0;

    pimage.pixels[i] = color(redVal, greenVal, blueVal, alphaVal);
  }
}

public class ImageState {

  int ColorMode_COLOR_FILTER = 0;
  int ColorMode_SHOW_DOMINANT_HUE = 1;
  int ColorMode_HIDE_DOMINANT_HUE = 2;

  PImage pimage;
  String url;

  public static final int INITIAL_HUE_TOLERANCE = 5;

  int colorModeState = ColorMode_COLOR_FILTER;
  int blueFilter = 0;
  int greenFilter = 0;
  int hueTolerance = 0;
  int redFilter = 0;

  public ImageState() {
    pimage = null;
    hueTolerance = INITIAL_HUE_TOLERANCE;
  }

  public int getBlueFilter() {
    return blueFilter;
  }

  public int getGreenFilter() {
    return greenFilter;
  }

  public int getRedFilter() {
    return redFilter;
  }

  public int getHueTolerance() {
    return hueTolerance;
  }

  public int getColorMode() {
    return colorModeState;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getUrl() {
    return url;
  }

  public void updateImage(int hueRange, int rgbColorRange) {
    pimage = null;
    pimage = loadImage("testImg.jpg");
    alert("loading image");
    if (colorModeState == ColorMode_SHOW_DOMINANT_HUE) {
      processImageForHue(pimage, hueRange, hueTolerance, true);
    } else if (colorModeState == ColorMode_HIDE_DOMINANT_HUE) {
      processImageForHue(pimage, hueRange, hueTolerance, false);
    }
    applyColorFilter(pimage, redFilter, greenFilter, blueFilter, rgbColorRange);
    pimage.updatePixels();
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
    pimage = null;
    pimage = loadImage("testImg.jpg");
    if (pimage == null) {
      println("image null");
    } else {
      println("wh: " + pimage.width + ", " + pimage.height);
    }
    // Fix the size.
    if (imgWidth > imageMax || imgHeight > imageMax) {
      imgWidth = imageMax;
      imgHeight = imageMax;
      if (pimage.width > pimage.height) {
        imgHeight = int( (imgHeight * pimage.height) / pimage.width );
      } else {
        imgWidth = int( (imgWidth * pimage.width) / pimage.height );
      }
      
      println("image size: " + imgWidth + ", " + imgHeight);
      pimage.resize(imgWidth, imgHeight);
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
