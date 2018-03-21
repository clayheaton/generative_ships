class Wing {
  int wTop, wBottom, h, r, g, b;
  float shear, rotation;
  color fill_color, outline_color;
  PVector upperLeft, upperRight, lowerRight, lowerLeft;
  PVector iUpperLeft, iUpperRight, iLowerRight, iLowerLeft; // inverted
  PVector midBottom, midTop, midPoint, lowerThird, upperThird;
  PVector iMidBottom, iMidTop, iMidPoint, iLowerThird, iUpperThird; // inverted
  Flair flair;
  Wing() {
    this.wTop = (int)random(wings_minWidthTop, wings_maxWidthTop);
    this.wBottom = (int)random(wings_minWidthBottom, wings_maxWidthBottom);
    this.h = (int)random(wings_minHeight, wings_maxHeight);
    this.r = (int)random(wings_minRed, wings_maxRed);
    this.g = (int)random(wings_minGreen, wings_maxGreen);
    this.b = (int)random(wings_minBlue, wings_maxBlue);
    this.shear = random(wings_minShear, wings_maxShear);
    this.rotation = random(wings_minRotation, wings_maxRotation);

    this.fill_color = color(this.r, this.g, this.b);
    color c = color(0);
    this.outline_color = lerpColor(fill_color, c, 0.33);

    float offsetTop = this.shear * this.wTop / 2;

    // wing on top
    upperLeft = new PVector(-this.wTop/2 + offsetTop, -this.h/2);
    upperRight = new PVector(this.wTop/2 + offsetTop, -this.h/2);
    lowerRight = new PVector(this.wBottom/2, this.h/2);
    lowerLeft = new PVector(-this.wBottom/2, this.h/2);

    midBottom = PVector.lerp(lowerLeft, lowerRight, 0.5);
    midTop = PVector.lerp(upperLeft, upperRight, 0.5);
    midPoint = PVector.lerp(midBottom, midTop, 0.5);
    lowerThird = PVector.lerp(midBottom, midTop, 0.25);
    upperThird = PVector.lerp(midBottom, midTop, 0.75);

    // wing on bottom
    iUpperLeft = new PVector(-this.wBottom/2, -this.h/2);
    iUpperRight = new PVector(this.wBottom/2, -this.h/2);
    iLowerRight = new PVector(this.wTop/2 + offsetTop, this.h/2);
    iLowerLeft = new PVector(-this.wTop/2 + offsetTop, this.h/2);

    iMidBottom = PVector.lerp(iUpperLeft, iUpperRight, 0.5);
    iMidTop = PVector.lerp(iLowerLeft, iLowerRight, 0.5);
    iMidPoint = PVector.lerp(iMidBottom, iMidTop, 0.5);
    iLowerThird = PVector.lerp(iMidBottom, iMidTop, 0.25);
    iUpperThird = PVector.lerp(iMidBottom, iMidTop, 0.75);

    flair = new Flair();
  }

  void display() {
    fill(this.fill_color);
    stroke(this.outline_color);

    pushMatrix();
    rotate(this.rotation);
    beginShape();
    vertex(upperLeft.x, upperLeft.y);
    vertex(upperRight.x, upperRight.y);
    vertex(lowerRight.x, lowerRight.y);
    vertex(lowerLeft.x, lowerLeft.y);
    endShape(CLOSE);

    pushMatrix();
    translate(midPoint.x, midPoint.y);
    flair.display();
    popMatrix();

    pushMatrix();
    translate(lowerThird.x, lowerThird.y);
    flair.display();
    popMatrix();

    pushMatrix();
    translate(upperThird.x, upperThird.y);
    flair.display();
    popMatrix();

    popMatrix();
  }
  
  // For drawing on the bottom of a ship
  void displayInverted() {
    fill(this.fill_color);
    stroke(this.outline_color);
    
    pushMatrix();
      rotate(-this.rotation);
      beginShape();
      vertex(iUpperLeft.x, iUpperLeft.y);
      vertex(iUpperRight.x, iUpperRight.y);
      vertex(iLowerRight.x, iLowerRight.y);
      vertex(iLowerLeft.x, iLowerLeft.y);
      endShape(CLOSE);
      
      pushMatrix();
      translate(iMidPoint.x, iMidPoint.y);
      flair.displayReverse();
      popMatrix();
  
      pushMatrix();
      translate(iLowerThird.x, iLowerThird.y);
      flair.displayReverse();
      popMatrix();
  
      pushMatrix();
      translate(iUpperThird.x, iUpperThird.y);
      flair.displayReverse();
      popMatrix();
    popMatrix();
  }
}




class WingSector extends Sector {
  Wing wing;
  WingSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }

  void rebuild() {
    wing = new Wing();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.wing.display();
    popMatrix();
  }
}





class WingGrid extends Grid {
  WingGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    wingsWidthTopRange = cp5.addRange("wing top")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(WINGS_MIN_WIDTH, WINGS_MAX_WIDTH)
      .setRangeValues(WINGS_MIN_WIDTH, WINGS_MAX_WIDTH)
      .moveTo("wings")
      .setBroadcast(true);

    wingsWidthBottomRange = cp5.addRange("wing base")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(WINGS_MIN_WIDTH, WINGS_MAX_WIDTH)
      .setRangeValues(WINGS_MIN_WIDTH, WINGS_MAX_WIDTH)
      .moveTo("wings")
      .setBroadcast(true);

    wingsHeightRange = cp5.addRange("wing height")
      .setBroadcast(false) 
      .setPosition(10, 110)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(WINGS_MIN_HEIGHT, WINGS_MAX_HEIGHT)
      .setRangeValues(WINGS_MIN_HEIGHT, WINGS_MAX_HEIGHT)
      .moveTo("wings")
      .setBroadcast(true);

    wingsRotationRange = cp5.addRange("wing rotation")
      .setBroadcast(false) 
      .setPosition(10, 150)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(ROTATION_MIN, ROTATION_MAX)
      .setRangeValues(ROTATION_MIN, ROTATION_MIN)
      .moveTo("wings")
      .setBroadcast(true);

    wingsShearRange = cp5.addRange("wing shear")
      .setBroadcast(false) 
      .setPosition(10, 190)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SHEAR_MIN, SHEAR_MAX)
      .setRangeValues(SHEAR_MIN, SHEAR_MIN)
      .moveTo("wings")
      .setBroadcast(true);

    // colors
    wingsRedRange = cp5.addRange("wing red")
      .setBroadcast(false) 
      .setPosition(10, 230)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("wings")
      .setBroadcast(true);

    wingsGreenRange = cp5.addRange("wing green")
      .setBroadcast(false) 
      .setPosition(10, 270)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("wings")
      .setBroadcast(true);

    wingsBlueRange = cp5.addRange("wing blue")
      .setBroadcast(false) 
      .setPosition(10, 310)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("wings")
      .setBroadcast(true);
  }

  void setRangeValues() {
    wings_minWidthTop = WINGS_MIN_WIDTH;
    wings_maxWidthTop = WINGS_MAX_WIDTH;
    wings_minWidthBottom = WINGS_MIN_WIDTH;
    wings_maxWidthBottom = WINGS_MAX_WIDTH;
    wings_minHeight = WINGS_MIN_HEIGHT;
    wings_maxHeight = WINGS_MAX_HEIGHT;
    wings_minRotation = ROTATION_MIN;
    wings_maxRotation = ROTATION_MIN;
    wings_minShear = SHEAR_MIN;
    wings_maxShear = SHEAR_MIN;

    wings_minRed = MIN_COLOR;
    wings_maxRed = MAX_COLOR;
    wings_minGreen = MIN_COLOR;
    wings_maxGreen = MAX_COLOR;
    wings_minBlue = MIN_COLOR;
    wings_maxBlue = MAX_COLOR;

    try {
      wingsWidthTopRange.setRangeValues(wings_minWidthTop, wings_maxWidthTop);
      wingsWidthBottomRange.setRangeValues(wings_minWidthBottom, wings_maxWidthBottom);
      wingsHeightRange.setRangeValues(wings_minHeight, wings_maxHeight);
      wingsShearRange.setRangeValues(wings_minShear, wings_maxShear);
      wingsRotationRange.setRangeValues(wings_minRotation, wings_maxRotation);

      wingsRedRange.setRangeValues(wings_minRed, wings_maxRed);
      wingsGreenRange.setRangeValues(wings_minGreen, wings_maxGreen);
      wingsBlueRange.setRangeValues(wings_minBlue, wings_maxBlue);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(wingsRedRange)) {
      wings_minRed = int(theControlEvent.getController().getArrayValue(0));
      wings_maxRed = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minRed, wings_maxRed: " + wings_minRed + ", " + wings_maxRed);
    }

    if (theControlEvent.isFrom(wingsGreenRange)) {
      wings_minGreen = int(theControlEvent.getController().getArrayValue(0));
      wings_maxGreen = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minGreen, cockpit_maxGreen: " + wings_minGreen + ", " + cockpit_maxGreen);
    }

    if (theControlEvent.isFrom(wingsBlueRange)) {
      wings_minBlue = int(theControlEvent.getController().getArrayValue(0));
      wings_maxBlue = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minBlue, wings_maxBlue: " + wings_minBlue + ", " + wings_maxBlue);
    }

    if (theControlEvent.isFrom(wingsWidthTopRange)) {
      wings_minWidthTop = int(theControlEvent.getController().getArrayValue(0));
      wings_maxWidthTop = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minWidthTop, wings_maxWidthTop: " + wings_minWidthTop + ", " + wings_maxWidthTop);
    }  

    if (theControlEvent.isFrom(wingsWidthBottomRange)) {
      wings_minWidthBottom = int(theControlEvent.getController().getArrayValue(0));
      wings_maxWidthBottom = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minWidthBottom, wings_maxWidthBottom: " + wings_minWidthBottom + ", " + wings_maxWidthBottom);
    }  

    if (theControlEvent.isFrom(wingsHeightRange)) {
      wings_minHeight = int(theControlEvent.getController().getArrayValue(0));
      wings_maxHeight = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minHeight, wings_maxHeight: " + wings_minHeight + ", " + wings_maxHeight);
    }  

    if (theControlEvent.isFrom(wingsRotationRange)) {
      wings_minRotation = theControlEvent.getController().getArrayValue(0);
      wings_maxRotation = theControlEvent.getController().getArrayValue(1);
      println("wings_minRotation, wings_maxRotation: " + wings_minRotation + ", " + wings_maxRotation);
    }  

    if (theControlEvent.isFrom(wingsShearRange)) {
      wings_minShear = int(theControlEvent.getController().getArrayValue(0));
      wings_maxShear = int(theControlEvent.getController().getArrayValue(1));
      println("wings_minShear, wings_maxShear: " + wings_minShear + ", " + wings_maxShear);
    }
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new WingSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
