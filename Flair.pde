class Flair {
  int w, h, r, g, b;
  float shear, rot;
  PVector upperLeft, upperRight, lowerRight, lowerLeft;
  color mainColor;

  Flair() {
    this.w = (int)random(flair_minWidth, flair_maxWidth);
    this.h = (int)random(flair_minHeight, flair_maxHeight);
    this.r = (int)random(flair_minRed, flair_maxRed);
    this.g = (int)random(flair_minGreen, flair_maxGreen);
    this.b = (int)random(flair_minBlue, flair_maxBlue);
    this.rot = random(flair_minRotation, flair_maxRotation);
    this.shear = random(flair_minShear, flair_maxShear);

    this.mainColor = color(this.r, this.g, this.b);

    float offset = this.shear * this.w / 2;

    upperLeft = new PVector(0 - this.w/2 + offset, 0 - this.h/2);
    upperRight = new PVector(this.w/2 + offset, 0 - this.h/2);
    lowerRight = new PVector(this.w/2, this.h/2);
    lowerLeft = new PVector(0 - this.w/2, this.h/2);
  }

  void display() {
    fill(this.r, this.g, this.b);
    noStroke();
    pushMatrix();
    rotate(this.rot);
    beginShape();
    vertex(upperLeft.x, upperLeft.y);
    vertex(upperRight.x, upperRight.y);
    vertex(lowerRight.x, lowerRight.y);
    vertex(lowerLeft.x, lowerLeft.y);
    endShape(CLOSE);
    popMatrix();
  }
  
  // For when drawing on a wing that is on the bottom of a ship
  void displayReverse() {
    fill(this.r, this.g, this.b);
    noStroke();
    pushMatrix();
    rotate(-this.rot);
    beginShape();
    vertex(upperLeft.x, upperLeft.y);
    vertex(upperRight.x, upperRight.y);
    vertex(lowerRight.x, lowerRight.y);
    vertex(lowerLeft.x, lowerLeft.y);
    endShape(CLOSE);
    popMatrix();
  }
}


class FlairSector extends Sector {
  Flair flair;
  FlairSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }

  void rebuild() {
    flair = new Flair();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.flair.display();
    popMatrix();
  }
}

class FlairGrid extends Grid {
  FlairGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    flairWidthRange = cp5.addRange("flair width")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(FLAIR_MIN_DIM, FLAIR_MAX_DIM)
      .setRangeValues(FLAIR_MIN_DIM, FLAIR_MAX_DIM)
      .moveTo("default")
      .setBroadcast(true);

    flairHeightRange = cp5.addRange("flair height")
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(FLAIR_MIN_DIM, FLAIR_MAX_DIM)
      .setRangeValues(FLAIR_MIN_DIM, FLAIR_MAX_DIM)
      .moveTo("default")
      .setBroadcast(true);

    flairRotationRange = cp5.addRange("flair rotation")
      .setBroadcast(false) 
      .setPosition(10, 110)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(ROTATION_MIN, ROTATION_MAX)
      .setRangeValues(0, 0)
      .moveTo("default")
      .setBroadcast(true);

    flairShearRange = cp5.addRange("flair shear")
      .setBroadcast(false) 
      .setPosition(10, 150)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(FLAIR_SHEAR_MIN, FLAIR_SHEAR_MAX)
      .setRangeValues(0, 0)
      .moveTo("default")
      .setBroadcast(true);

    flairRedRange = cp5.addRange("flair red")
      .setBroadcast(false) 
      .setPosition(10, 190)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("default")
      .setBroadcast(true);

    flairGreenRange = cp5.addRange("flair green")
      .setBroadcast(false) 
      .setPosition(10, 230)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("default")
      .setBroadcast(true);

    flairBlueRange = cp5.addRange("flair blue")
      .setBroadcast(false) 
      .setPosition(10, 270)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("default")
      .setBroadcast(true);
  }

  void setRangeValues() {
    flair_minWidth  = FLAIR_MIN_DIM;
    flair_maxWidth  = FLAIR_MAX_DIM;
    flair_minHeight = FLAIR_MIN_DIM;
    flair_maxHeight = FLAIR_MAX_DIM;
    flair_minRotation = 0;
    flair_maxRotation = 0;
    flair_minShear = 0;
    flair_maxShear = 0;
    flair_minRed = MIN_COLOR;
    flair_maxRed = MAX_COLOR;
    flair_minGreen = MIN_COLOR;
    flair_maxGreen = MAX_COLOR;
    flair_minBlue = MIN_COLOR;
    flair_maxBlue = MAX_COLOR;

    try {
      flairWidthRange.setRangeValues(flair_minWidth, flair_maxWidth);
      flairHeightRange.setRangeValues(flair_minHeight, flair_maxHeight);
      flairRotationRange.setRangeValues(flair_minRotation, flair_maxRotation);
      flairShearRange.setRangeValues(flair_minShear, flair_maxShear);
      flairRedRange.setRangeValues(flair_minRed, flair_maxRed);
      flairGreenRange.setRangeValues(flair_minGreen, flair_maxGreen);
      flairBlueRange.setRangeValues(flair_minBlue, flair_maxBlue);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(flairWidthRange)) {
      // min and max values are stored in an array.
      // access this array with controller().arrayValue().
      // min is at index 0, max is at index 1.
      flair_minWidth = int(theControlEvent.getController().getArrayValue(0));
      flair_maxWidth = int(theControlEvent.getController().getArrayValue(1));
      println("flair_minWidth, flair_maxWidth: " + flair_minWidth + ", " + flair_maxWidth);
    }

    if (theControlEvent.isFrom(flairHeightRange)) {
      flair_minHeight = int(theControlEvent.getController().getArrayValue(0));
      flair_maxHeight = int(theControlEvent.getController().getArrayValue(1));
      println("flair_minHeight, flair_maxHeight: " + flair_minHeight + ", " + flair_maxHeight);
    }

    if (theControlEvent.isFrom(flairRotationRange)) {
      flair_minRotation = theControlEvent.getController().getArrayValue(0);
      flair_maxRotation = theControlEvent.getController().getArrayValue(1);
      println("flair_minRotation, flair_maxRotation: " + flair_minRotation + ", " + flair_maxRotation);
    }

    if (theControlEvent.isFrom(flairShearRange)) {
      flair_minShear = theControlEvent.getController().getArrayValue(0);
      flair_maxShear = theControlEvent.getController().getArrayValue(1);
      println("flair_minShear, flair_maxShear: " + flair_minShear + ", " + flair_maxShear);
    }


    if (theControlEvent.isFrom(flairRedRange)) {
      flair_minRed = int(theControlEvent.getController().getArrayValue(0));
      flair_maxRed = int(theControlEvent.getController().getArrayValue(1));
      println("flair_minRed, flair_maxRed: " + flair_minRed + ", " + flair_maxRed);
    }

    if (theControlEvent.isFrom(flairGreenRange)) {
      flair_minGreen = int(theControlEvent.getController().getArrayValue(0));
      flair_maxGreen = int(theControlEvent.getController().getArrayValue(1));
      println("flair_minGreen, flair_maxGreen: " + flair_minGreen + ", " + flair_maxGreen);
    }

    if (theControlEvent.isFrom(flairBlueRange)) {
      flair_minBlue = int(theControlEvent.getController().getArrayValue(0));
      flair_maxBlue = int(theControlEvent.getController().getArrayValue(1));
      println("flair_minBlue, flair_maxBlue: " + flair_minBlue + ", " + flair_maxBlue);
    }
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new FlairSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
