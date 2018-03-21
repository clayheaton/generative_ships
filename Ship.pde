class Ship {
  int numWings, numSegments, segmentSpacing, backboneWidth, backboneHeight;
  boolean topWings, bottomWings;
  ArrayList<PVector> wingLocations;
  float bendiness, centerOffset;
  PVector p1, p2, p3, p4, p5, p6, w1, w2, w3, w4, w5, w6;
  float shipLength, shipHeight;

  Flair flair;
  Cockpit cockpit;
  Segment segment;
  Tail tail;
  Wing wing;
  Ship() {
    this.numWings = (int)random(ships_minWings, ships_maxWings + 0.99);
    this.numSegments = (int)random(ships_minSegments, ships_maxSegments + 0.99);
    this.bendiness = random(ships_minAmplitude, ships_maxAmplitude);
    this.segmentSpacing = 2; // TODO: parameterize
    this.topWings = ships_wingsTop;
    this.bottomWings = ships_wingsBottom;

    flair = new Flair();
    cockpit = new Cockpit();
    segment = new Segment();
    tail = new Tail();
    wing = new Wing();

    this.backboneWidth = (this.numSegments * segment.w) + (this.segmentSpacing * (this.numSegments - 1));
    this.backboneHeight = 60;

    // Constraint to prevent it from being too bendy
    this.centerOffset = max(0, min(50, (segment.h/2) * this.bendiness));

    // These define the backbone
    p1 = new PVector(-this.backboneWidth/2, -this.backboneHeight/2);
    p2 = new PVector(0, -this.backboneHeight/2 - this.centerOffset);
    p3 = new PVector(this.backboneWidth/2, -this.backboneHeight/2);
    p4 = new PVector(this.backboneWidth/2, this.backboneHeight/2);
    p5 = new PVector(0, this.backboneHeight/2 - this.centerOffset);
    p6 = new PVector(-this.backboneWidth/2, this.backboneHeight/2);

    // Candidate wing positions
    // Use z value to store upright or inverted.
    w1 = PVector.lerp(p1, p2, 0.33);
    w1.z = 0;
    w2 = p2;
    w2.z = 0;
    w3 = PVector.lerp(p3, p2, 0.33);
    w3.z = 0;
    w4 = PVector.lerp(p6, p5, 0.33);
    w4.z = 1;
    w5 = p5;
    w5.z = 1;
    w6 = PVector.lerp(p4, p5, 0.33);
    w6.z = 1;

    wingLocations = new ArrayList<PVector>();

    ArrayList<PVector> candidateSpots = new ArrayList<PVector>();
    if (this.topWings) {
      candidateSpots.add(w1);
      candidateSpots.add(w2);
      candidateSpots.add(w3);
    }
    if (this.bottomWings) {
      candidateSpots.add(w4);
      candidateSpots.add(w5);
      candidateSpots.add(w6);
    }

    // Constraint
    // We can only draw as many wings as we have spots for...
    numWings = min(numWings, candidateSpots.size());

    for (int i = 0; i < numWings; i++) {
      int idx = (int)random(0, candidateSpots.size());
      wingLocations.add(candidateSpots.get(idx));
      candidateSpots.remove(idx);
    }

    // If you want wings but have both boxes unchecked, you get top wings
    if (!this.topWings && !this.bottomWings) {
      if (this.numWings > 0) this.topWings = true;
    }

    shipLength = this.backboneWidth + this.cockpit.w + this.tail.w + this.tail.engineWidth;
    shipHeight = max(this.cockpit.h/2, max(this.segment.h/2, this.tail.h/2)) + this.tail.h*2;
  }

  void display() {
    // wings
    if (debug) {
      // Mark the "attachment" points
      ellipseMode(CENTER);
      fill(flair.mainColor);
      noStroke();
      ellipse(w1.x, w1.y, 10, 10);
      ellipse(w2.x, w2.y, 10, 10);
      ellipse(w3.x, w3.y, 10, 10);
      ellipse(w4.x, w4.y, 10, 10);
      ellipse(w5.x, w5.y, 10, 10);
      ellipse(w6.x, w6.y, 10, 10);
    }

    for (PVector p : wingLocations) {
      if (p.z == 0) {
        // top
        pushMatrix();
        translate(p.x, p.y - wing.h/2 + this.backboneHeight/2);
        wing.display();
        popMatrix();
      } else {
        // bottom
        pushMatrix();
        translate(p.x, p.y + wing.h/2 - this.backboneHeight/2);
        wing.displayInverted();
        popMatrix();
      }
    }

    // backbone - add center joint for bendiness
    // Also, don't quite make it as long as it should be so that segments cover most
    fill(0);
    noStroke();

    beginShape();
    vertex(p1.x+10, p1.y);
    vertex(p2.x, p2.y);
    vertex(p3.x-10, p3.y);
    vertex(p4.x-10, p4.y);
    vertex(p5.x, p5.y);
    vertex(p6.x+10, p6.y);
    endShape(CLOSE);

    // segments
    float segCenterX = -this.backboneWidth/2 + this.segment.w/2;

    for (int i = 0; i < this.numSegments; i++) {

      // Calculate y position
      float yOffsetLerpPercent, segCenterY;
      if (segCenterX == 0) {
        segCenterX += 0.01;
      }
      if (segCenterX < 0) {
        yOffsetLerpPercent = (this.backboneWidth/2 - abs(segCenterX)) / (this.backboneWidth/2);
        PVector topAnchor = PVector.lerp(p1, p2, yOffsetLerpPercent);
        PVector bottomAnchor = PVector.lerp(p6, p5, yOffsetLerpPercent);
        PVector midAnchor = PVector.lerp(topAnchor, bottomAnchor, 0.5);
        segCenterY = midAnchor.y;
      } else {
        yOffsetLerpPercent = abs(segCenterX) / (this.backboneWidth/2);
        PVector topAnchor = PVector.lerp(p2, p3, yOffsetLerpPercent);
        PVector bottomAnchor = PVector.lerp(p5, p4, yOffsetLerpPercent);
        PVector midAnchor = PVector.lerp(topAnchor, bottomAnchor, 0.5);
        segCenterY = midAnchor.y;
      }


      pushMatrix();
      translate(segCenterX, segCenterY); // handle y
      segment.display();
      segCenterX += segment.w + segmentSpacing;
      popMatrix();
    }

    // cockpit
    float additionalXOffset = 0;
    if (cockpit.cockpit_type == "type2") {
      additionalXOffset = cockpit.w/2 * 0.9;
    }
    noStroke();
    noFill();
    pushMatrix();
    translate(-this.backboneWidth/2 - cockpit.w/2 + 5 + additionalXOffset, 0);
    cockpit.display();
    popMatrix();

    // tail
    noStroke();
    noFill();
    pushMatrix();
    translate(this.backboneWidth/2 + tail.w/2 - 10, 0);
    tail.display();
    popMatrix();
  }
}



class ShipSector extends Sector {
  Ship ship;
  ShipSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }
  void rebuild() {
    ship = new Ship();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.ship.display();
    popMatrix();
  }
}


class ShipGrid extends Grid {
  ShipGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    shipsSegmentsRange = cp5.addRange("segments")
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SHIPS_MIN_SEGMENTS, SHIPS_MAX_SEGMENTS)
      .setRangeValues(SHIPS_MIN_SEGMENTS, SHIPS_MAX_SEGMENTS)
      .moveTo("ships")
      .setBroadcast(true);

    shipsAmplitudeRange = cp5.addRange("bendiness")
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SHIPS_MIN_AMPLITUDE, SHIPS_MAX_AMPLITUDE)
      .setRangeValues(SHIPS_MIN_AMPLITUDE, SHIPS_MAX_AMPLITUDE)
      .moveTo("ships")
      .setBroadcast(true);

    shipsWingsRange = cp5.addRange("num. wings")
      .setBroadcast(false) 
      .setPosition(10, 110)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SHIPS_MIN_WINGS, SHIPS_MAX_WINGS)
      .setRangeValues(SHIPS_MIN_WINGS, SHIPS_MAX_WINGS)
      .moveTo("ships")
      .setBroadcast(true);

    shipsWingPositions = cp5.addCheckBox("wing positions")
      .setPosition(10, 190)
      .setSize(30, 30)
      .setItemsPerRow(2)
      .setSpacingColumn(70)
      .setSpacingRow(20)
      .addItem("top wings", 1)
      .addItem("bottom wings", 2)
      .moveTo("ships")
      .toggle(0)
      .toggle(1)
      ;
  }

  void setRangeValues() {
    ships_minSegments = SHIPS_MIN_SEGMENTS;
    ships_maxSegments = SHIPS_MAX_SEGMENTS;
    ships_minAmplitude = SHIPS_MIN_AMPLITUDE;
    ships_maxAmplitude = SHIPS_MAX_AMPLITUDE;
    ships_minWings = SHIPS_MIN_WINGS;
    ships_maxWings = SHIPS_MAX_WINGS;

    ships_wingsTop = true;
    ships_wingsBottom = true;


    try {
      shipsSegmentsRange.setRangeValues(ships_minSegments, ships_maxSegments);
      shipsAmplitudeRange.setRangeValues(ships_minAmplitude, ships_maxAmplitude);
      shipsWingsRange.setRangeValues(ships_minWings, ships_maxWings);

      float[] v = {1, 1};
      shipsWingPositions.setArrayValue(v);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(shipsSegmentsRange)) {
      ships_minSegments = int(theControlEvent.getController().getArrayValue(0));
      ships_maxSegments = int(theControlEvent.getController().getArrayValue(1));
      println("ships_minSegments, ships_maxSegments: " + ships_minSegments + ", " + ships_maxSegments);
    }

    if (theControlEvent.isFrom(shipsAmplitudeRange)) {
      ships_minAmplitude = theControlEvent.getController().getArrayValue(0);
      ships_maxAmplitude = theControlEvent.getController().getArrayValue(1);
      println("ships_minAmplitude, ships_maxAmplitude: " + ships_minAmplitude + ", " + ships_maxAmplitude);
    }

    if (theControlEvent.isFrom(shipsWingsRange)) {
      ships_minWings = (int)theControlEvent.getController().getArrayValue(0);
      ships_maxWings = (int)theControlEvent.getController().getArrayValue(1);
      println("ships_minWings, ships_maxWings: " + ships_minWings + ", " + ships_maxWings);
    }

    if (theControlEvent.isFrom(shipsWingPositions)) {
      ships_wingsTop = int(shipsWingPositions.getArrayValue()[0]) == 1 ? true : false;
      ships_wingsBottom = int(shipsWingPositions.getArrayValue()[1]) == 1 ? true : false;
      println("shipsWingPositions: top, bottom: " + ships_wingsTop + ", " + ships_wingsBottom);
    }
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new ShipSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
