class Cockpit {
  int w, h, r, g, b, bays;
  float window_diam;
  String cockpit_type, cockpit_window_style;
  color fillcolor, outlinecolor;
  Cockpit() {
    this.w = (int)random(cockpit_minWidth, cockpit_maxWidth);
    this.h = (int)random(cockpit_minHeight, cockpit_maxHeight);
    this.r = (int)random(cockpit_minRed, cockpit_maxRed);
    this.g = (int)random(cockpit_minGreen, cockpit_maxGreen);
    this.b = (int)random(cockpit_minBlue, cockpit_maxBlue);
    this.bays = (int)random(cockpit_minBays, cockpit_maxBays+0.99); // bump because otherwise we never see 4
    this.fillcolor = color(this.r, this.g, this.b);
    color black = color(0);
    this.outlinecolor = lerpColor(this.fillcolor, black, 0.33);

    if (this.bays == 0) {
      this.window_diam = 0;
    } else {
      if (this.w > this.h) {
        this.window_diam = (this.h / this.bays) * 0.7;
      } else {
        this.window_diam = (this.w / this.bays) * 0.7;
      }
    }

    ArrayList<String> types = new ArrayList<String>();
    if (cockpit_type1) types.add("type1");
    if (cockpit_type2) types.add("type2");
    if (cockpit_type3) types.add("type3");

    // Must always have one type
    if (types.size() == 0) types.add("type1");

    // Pick a random type from the list
    cockpit_type = types.get(new Random().nextInt(types.size()));

    ArrayList<String> windows = new ArrayList<String>();
    if (cockpit_window1) windows.add("window1");
    if (cockpit_window2) windows.add("window2");

    if (windows.size() == 0) windows.add("window1");

    cockpit_window_style = windows.get(new Random().nextInt(windows.size()));
  }

  void display() {
    ellipseMode(CENTER);
    rectMode(CENTER);
    if (cockpit_type == "type1") { 
      drawType1();
    } else if (cockpit_type == "type2") { 
      drawType2();
    } else if (cockpit_type == "type3") { 
      drawType3();
    }
    rectMode(CORNER);
  }

  void drawType1() {
    noStroke();
    fill(220, 220, 255);
    float radius = this.window_diam/2;

    // Square with a circle coming out the front
    for (int i = 0; i < this.bays; i++) {
      float yCenter = (this.bays * radius) - radius - (i*this.window_diam);
      if (cockpit_window_style == "window1") {
        ellipse(-this.w/2, yCenter, this.window_diam, this.window_diam*1.2);
      } else {
        // Square windows
        rect(-this.w/2, yCenter, this.window_diam*0.9, this.window_diam*0.9);
      }
    }


    // hull
    rectMode(CORNER);
    stroke(this.outlinecolor);
    strokeWeight(1);
    fill(this.fillcolor);
    rect(-this.w/2, -this.h/2, this.w, this.h);
  }

  void drawType2() {
    // Elongated arc
    noStroke();
    fill(220, 220, 255);
    float radius = this.window_diam/2;

    for (int i = 0; i < this.bays; i++) {
      float yCenter = (this.bays * radius) - radius - (i*this.window_diam);
      if (cockpit_window_style == "window1") {
        ellipse(-this.w/2, yCenter, this.window_diam, this.window_diam);
      } else {
        // Square windows
        rect(-this.w/2, yCenter, this.window_diam*0.9, this.window_diam*0.9);
      }
    }


    stroke(this.outlinecolor);
    strokeWeight(1);
    fill(this.fillcolor);
    arc(0, 0, this.w, this.h, HALF_PI, 3*PI/2, CHORD);
  }

  void drawType3() {
    // Triangle
    noStroke();
    fill(220, 220, 255);
    ArrayList<PVector> points = new ArrayList<PVector>();

    PVector tip = new PVector(-this.w/2, 0);
    PVector top = new PVector(this.w/2, -this.h/2);
    PVector bottom = new PVector(this.w/2, this.h/2);

    points.add(PVector.lerp(tip, top, 0.33));
    points.add(PVector.lerp(tip, top, 0.66));
    points.add(PVector.lerp(tip, bottom, 0.33));
    points.add(PVector.lerp(tip, bottom, 0.66));

    if (this.bays > 0) {
      if (this.w > this.h) {
        this.window_diam = (this.h / max(1.4, this.bays)) * 0.7;
      } else {
        this.window_diam = (this.w / max(1.4, this.bays)) * 0.7;
      }
    }

    for (int i = 0; i < this.bays; i++) {
      PVector pt = points.get(i);
      if (cockpit_window_style == "window1") {
        ellipse(pt.x, pt.y, this.window_diam, this.window_diam);
      } else {
        // Square windows
        rect(pt.x, pt.y, this.window_diam, this.window_diam);
      }
    }

    stroke(this.outlinecolor);
    strokeWeight(1);
    fill(this.fillcolor);
    triangle(-this.w/2, 0, this.w/2, -this.h/2, this.w/2, this.h/2);
  }
}


class CockpitSector extends Sector {
  Cockpit cockpit;
  CockpitSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }

  void rebuild() {
    cockpit = new Cockpit();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.cockpit.display();
    popMatrix();
  }
}


class CockpitGrid extends Grid {
  CockpitGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    cockpitWidthRange = cp5.addRange("cockpit width")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(COCKPIT_MIN_WIDTH, COCKPIT_MAX_WIDTH)
      .setRangeValues(COCKPIT_MIN_WIDTH, COCKPIT_MAX_WIDTH)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitHeightRange = cp5.addRange("cockpit height")
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(COCKPIT_MIN_HEIGHT, COCKPIT_MAX_HEIGHT)
      .setRangeValues(COCKPIT_MIN_HEIGHT, COCKPIT_MAX_HEIGHT)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitBaysRange = cp5.addRange("cockpit bays")
      .setBroadcast(false) 
      .setPosition(10, 110)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(COCKPIT_MIN_BAYS, COCKPIT_MAX_BAYS)
      .setRangeValues(COCKPIT_MIN_BAYS, COCKPIT_MAX_BAYS)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitRedRange = cp5.addRange("cockpit red")
      .setBroadcast(false) 
      .setPosition(10, 150)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitGreenRange = cp5.addRange("cockpit green")
      .setBroadcast(false) 
      .setPosition(10, 190)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitBlueRange = cp5.addRange("cockpit blue")
      .setBroadcast(false) 
      .setPosition(10, 230)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("cockpits")
      .setBroadcast(true);

    cockpitCheckbox = cp5.addCheckBox("cockpit checkBox")
      .setPosition(10, 300)
      .setSize(30, 30)
      .setItemsPerRow(3)
      .setSpacingColumn(50)
      .setSpacingRow(20)
      .addItem("type 1", 1)
      .addItem("type 2", 2)
      .addItem("type 3", 3)
      .addItem("window 1", 4)
      .addItem("window 2", 5)
      .moveTo("cockpits")
      .toggle(0)
      .toggle(1)
      .toggle(2)
      .toggle(3)
      .toggle(4)
      ;
  }

  void setRangeValues() {
    cockpit_minWidth = COCKPIT_MIN_WIDTH;
    cockpit_maxWidth = COCKPIT_MAX_WIDTH;
    cockpit_minHeight = COCKPIT_MIN_HEIGHT;
    cockpit_maxHeight = COCKPIT_MAX_HEIGHT;
    cockpit_minBays = COCKPIT_MIN_BAYS;
    cockpit_maxBays = COCKPIT_MAX_BAYS;
    cockpit_window1 = true;
    cockpit_window2 = true;
    cockpit_type1 = true;
    cockpit_type2 = true;
    cockpit_type3 = true;
    cockpit_minRed = MIN_COLOR;
    cockpit_maxRed = MAX_COLOR;
    cockpit_minGreen = MIN_COLOR;
    cockpit_maxGreen = MAX_COLOR;
    cockpit_minBlue = MIN_COLOR;
    cockpit_maxBlue = MAX_COLOR;

    try {
      cockpitWidthRange.setRangeValues(cockpit_minWidth, cockpit_maxWidth);
      cockpitHeightRange.setRangeValues(cockpit_minHeight, cockpit_maxHeight);
      cockpitBaysRange.setRangeValues(cockpit_minBays, cockpit_maxBays);
      cockpitRedRange.setRangeValues(cockpit_minRed, cockpit_maxRed);
      cockpitGreenRange.setRangeValues(cockpit_minGreen, cockpit_maxGreen);
      cockpitBlueRange.setRangeValues(cockpit_minBlue, cockpit_maxBlue);

      float[] v = {1, 1, 1, 1, 1};
      cockpitCheckbox.setArrayValue(v);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(cockpitRedRange)) {
      cockpit_minRed = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxRed = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minRed, cockpit_maxRed: " + cockpit_minRed + ", " + cockpit_maxRed);
    }

    if (theControlEvent.isFrom(cockpitGreenRange)) {
      cockpit_minGreen = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxGreen = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minGreen, cockpit_maxGreen: " + cockpit_minGreen + ", " + cockpit_maxGreen);
    }

    if (theControlEvent.isFrom(cockpitBlueRange)) {
      cockpit_minBlue = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxBlue = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minBlue, cockpit_maxBlue: " + cockpit_minBlue + ", " + cockpit_maxBlue);
    }

    if (theControlEvent.isFrom(cockpitWidthRange)) {
      cockpit_minWidth = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxWidth = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minWidth, cockpit_maxWidth: " + cockpit_minWidth + ", " + cockpit_maxWidth);
    }  

    if (theControlEvent.isFrom(cockpitHeightRange)) {
      cockpit_minHeight = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxHeight = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minHeight, cockpit_maxHeight: " + cockpit_minHeight + ", " + cockpit_maxHeight);
    }  

    if (theControlEvent.isFrom(cockpitBaysRange)) {
      cockpit_minBays = int(theControlEvent.getController().getArrayValue(0));
      cockpit_maxBays = int(theControlEvent.getController().getArrayValue(1));
      println("cockpit_minBays, cockpit_maxBays: " + cockpit_minBays + ", " + cockpit_maxBays);
    }  

    if (theControlEvent.isFrom(cockpitCheckbox)) {
      cockpit_type1 = int(cockpitCheckbox.getArrayValue()[0]) == 1 ? true : false;
      cockpit_type2 = int(cockpitCheckbox.getArrayValue()[1]) == 1 ? true : false;
      cockpit_type3 = int(cockpitCheckbox.getArrayValue()[2]) == 1 ? true : false;
      cockpit_window1 = int(cockpitCheckbox.getArrayValue()[3]) == 1 ? true : false;
      cockpit_window2 = int(cockpitCheckbox.getArrayValue()[4]) == 1 ? true : false;
      println("cockpitCheckbox: ");
      println(cockpitCheckbox.getArrayValue());
    }
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new CockpitSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
