class Tail {
  int w, h, r, g, b, engines;
  color mainColor, mainColorStroke;
  float engineWidth, engineHeight;
  Tail() {
    this.w = (int)random(tails_minWidth, tails_maxWidth);
    this.h = (int)random(tails_minHeight, tails_maxHeight);
    this.r = (int)random(tails_minRed, tails_maxRed);
    this.g = (int)random(tails_minGreen, tails_maxGreen);
    this.b = (int)random(tails_minBlue, tails_maxBlue);
    this.engines = (int)random(tails_minEngines, tails_maxEngines + 0.99);
    
    this.mainColor = color(this.r, this.g, this.b);
    color b = color(0);
    this.mainColorStroke = lerpColor(this.mainColor, b, 0.33);
    this.engineWidth = max(this.w/3,75);
    this.engineHeight = this.h/max(this.engines,2);
  }

  void display() {
    // Engine triangles are dark grey
    fill(80);
    stroke(110);
    
    float x1, y1, x2, y2, x3, y3, yCenter;
    
    // TODO: Fix this logic so that the for loop handles all of it
    // use lerp against the height
    if (this.engines == 1) {
      yCenter = 0;
      x1 = this.w/2 - 20;
      y1 = yCenter;
      x2 = x1 + engineWidth;
      y2 = yCenter - engineHeight/2;
      x3 = x2;
      y3 = yCenter + engineHeight/2;
      triangle(x1,y1,x2,y2,x3,y3);
    } else {
      for (int i = 0; i < this.engines; i++) {
         yCenter = (this.engines * engineHeight*0.7) - engineHeight - (i * engineHeight*1.1); 
         x1 = this.w/2 - 20;
         y1 = yCenter;
         x2 = x1 + engineWidth;
         y2 = yCenter - engineHeight/2;
         x3 = x2;
         y3 = yCenter + engineHeight/2;
         triangle(x1,y1,x2,y2,x3,y3);
      }
    }
    
    fill(mainColor);
    stroke(mainColorStroke);
    
    beginShape();
    vertex(-this.w/2,-this.h/2 * 0.8);
    vertex(this.w/2, -this.h/2);
    vertex(this.w/2, this.h/2);
    vertex(-this.w/2, this.h/2 * 0.8);
    endShape(CLOSE);
  }
}




class TailSector extends Sector {
  Tail tail;
  TailSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }
  void rebuild() {
    tail = new Tail();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.tail.display();
    popMatrix();
  }
}




class TailGrid extends Grid {
  TailGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    tailsWidthRange = cp5.addRange("tail width")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(TAILS_MIN_WIDTH, TAILS_MAX_WIDTH)
      .setRangeValues(TAILS_MIN_WIDTH, TAILS_MAX_WIDTH)
      .moveTo("tails")
      .setBroadcast(true);

    tailsHeightRange = cp5.addRange("tail height")
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(TAILS_MIN_HEIGHT, TAILS_MAX_HEIGHT)
      .setRangeValues(TAILS_MIN_HEIGHT, TAILS_MAX_HEIGHT)
      .moveTo("tails")
      .setBroadcast(true);

    tailsEnginesRange = cp5.addRange("engines")
      .setBroadcast(false) 
      .setPosition(10, 150)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(TAILS_MIN_ENGINES, TAILS_MAX_ENGINES)
      .setRangeValues(TAILS_MIN_ENGINES, TAILS_MAX_ENGINES)
      .moveTo("tails")
      .setBroadcast(true);

    tailsRedRange = cp5.addRange("tail red")
      .setBroadcast(false) 
      .setPosition(10, 230)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("tails")
      .setBroadcast(true);

    tailsGreenRange = cp5.addRange("tail green")
      .setBroadcast(false) 
      .setPosition(10, 270)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("tails")
      .setBroadcast(true);

    tailsBlueRange = cp5.addRange("tail blue")
      .setBroadcast(false) 
      .setPosition(10, 310)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("tails")
      .setBroadcast(true);
  }

  void setRangeValues() {
    tails_minWidth = TAILS_MIN_WIDTH;
    tails_maxWidth = TAILS_MAX_WIDTH;
    tails_minHeight = TAILS_MIN_HEIGHT;
    tails_maxHeight = TAILS_MAX_HEIGHT;
    tails_minEngines = TAILS_MIN_ENGINES;
    tails_maxEngines = TAILS_MAX_ENGINES;
    tails_minRed = MIN_COLOR;
    tails_maxRed = MAX_COLOR;
    tails_minGreen = MIN_COLOR;
    tails_maxGreen = MAX_COLOR;
    tails_minBlue = MIN_COLOR;
    tails_maxBlue = MAX_COLOR;

    try {
      tailsWidthRange.setRangeValues(tails_minWidth, tails_maxWidth);
      tailsHeightRange.setRangeValues(tails_minHeight, tails_maxHeight);
      tailsEnginesRange.setRangeValues(tails_minEngines, tails_maxEngines);
      tailsRedRange.setRangeValues(tails_minRed, tails_maxRed);
      tailsGreenRange.setRangeValues(tails_minGreen, tails_maxGreen);
      tailsBlueRange.setRangeValues(tails_minBlue, tails_maxBlue);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(tailsRedRange)) {
      tails_minRed = int(theControlEvent.getController().getArrayValue(0));
      tails_maxRed = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minRed, tails_maxRed: " + tails_minRed + ", " + tails_maxRed);
    }

    if (theControlEvent.isFrom(tailsGreenRange)) {
      tails_minGreen = int(theControlEvent.getController().getArrayValue(0));
      tails_maxGreen = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minGreen, tails_maxGreen: " + tails_minGreen + ", " + tails_maxGreen);
    }

    if (theControlEvent.isFrom(tailsBlueRange)) {
      tails_minBlue = int(theControlEvent.getController().getArrayValue(0));
      tails_maxBlue = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minBlue, tails_maxBlue: " + tails_minBlue + ", " + tails_maxBlue);
    }

    if (theControlEvent.isFrom(tailsWidthRange)) {
      tails_minWidth = int(theControlEvent.getController().getArrayValue(0));
      tails_maxWidth = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minWidth, tails_maxWidth: " + tails_minWidth + ", " + tails_maxWidth);
    }  

    if (theControlEvent.isFrom(tailsHeightRange)) {
      tails_minHeight = int(theControlEvent.getController().getArrayValue(0));
      tails_maxHeight = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minHeight, tails_maxHeight: " + tails_minHeight + ", " + tails_maxHeight);
    }  

    if (theControlEvent.isFrom(tailsEnginesRange)) {
      tails_minEngines = int(theControlEvent.getController().getArrayValue(0));
      tails_maxEngines = int(theControlEvent.getController().getArrayValue(1));
      println("tails_minEngines, tails_maxEngines: " + tails_minEngines + ", " + tails_maxEngines);
    }  
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new TailSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
