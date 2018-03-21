class Segment {
  int cornerTop, cornerBottom, stripeSide, w, h, r, g, b, sr, sg, sb;
  color mainColor, stripeColor, mainColorStroke;
  Segment() {
    this.w = (int)random(segments_minWidth, segments_maxWidth);
    this.h = (int)random(segments_minHeight, segments_maxHeight);
    this.r = (int)random(segments_minRed, segments_maxRed);
    this.g = (int)random(segments_minGreen, segments_maxGreen);
    this.b = (int)random(segments_minBlue, segments_maxBlue);
    this.sr = (int)random(segments_minStripeRed, segments_maxStripeRed);
    this.sg = (int)random(segments_minStripeGreen, segments_maxStripeGreen);
    this.sb = (int)random(segments_minStripeBlue, segments_maxStripeBlue);
    this.cornerTop = (int)random(segments_minCornerTop, segments_maxCornerTop);
    this.cornerBottom = (int)random(segments_minCornerBottom, segments_maxCornerBottom);
    this.stripeSide = (int)random(segments_minStripeSide, segments_maxStripeSide + 0.99);
    
    mainColor = color(r,g,b);
    stripeColor = color(sr,sg,sb);
    color b = color(0);
    mainColorStroke = lerpColor(mainColor, b, 0.33);
  }

  void display() {

    fill(mainColor);
    stroke(mainColorStroke);
    
    rect(-this.w/2, -this.h/2, this.w, this.h, this.cornerTop, this.cornerTop, this.cornerBottom, this.cornerBottom);
    
    fill(stripeColor);
    stroke(0);
    strokeWeight(1);
    if (this.stripeSide == 1) {
      // Left
      float nh = this.h * 0.66;
      float nw = this.w * 0.3;
      float nTop = this.cornerTop * 0.5;
      float nBot = this.cornerBottom * 0.5;
      rect(-this.w/3, -this.h/3, nw, nh, nTop, nTop, nBot, nBot);
      
    } else if (this.stripeSide == 2) {
      // Top
      float nh = this.h * 0.3;
      float nw = this.w * 0.66;
      float nTop = this.cornerTop * 0.5;
      float nBot = this.cornerBottom * 0.5;
      rect(-this.w/3, -this.h/3, nw, nh, nTop, nTop, nBot, nBot);
    } else if (this.stripeSide == 3) {
      // Right
      float nh = this.h * 0.66;
      float nw = this.w * 0.3;
      float nTop = this.cornerTop * 0.5;
      float nBot = this.cornerBottom * 0.5;
      rect(this.w/3-nw, -this.h/3, nw, nh, nTop, nTop, nBot, nBot);
    } else if (this.stripeSide == 4) {
      // Bottom
      float nh = this.h * 0.3;
      float nw = this.w * 0.66;
      float nTop = this.cornerTop * 0.5;
      float nBot = this.cornerBottom * 0.5;
      rect(-this.w/3, this.h/3-nh, nw, nh, nTop, nTop, nBot, nBot);
    } else if (this.stripeSide == 0) {
     // don't draw a stripe 
    }
    
  }
}







class SegmentSector extends Sector {
  Segment segment;
  SegmentSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }
  void rebuild() {
    segment = new Segment();
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.segment.display();
    popMatrix();
  }
}


class SegmentGrid extends Grid {
  SegmentGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }
  void createUIComponents() {
    segmentsCornerBottomRange = cp5.addRange("bot. corners")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 30)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SEGMENTS_MIN_CORNER_RADIUS, SEGMENTS_MAX_CORNER_RADIUS) // CHANGE?
      .setRangeValues(SEGMENTS_MIN_CORNER_RADIUS, SEGMENTS_MAX_CORNER_RADIUS)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsCornerTopRange = cp5.addRange("top corners")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 70)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SEGMENTS_MIN_CORNER_RADIUS, SEGMENTS_MAX_CORNER_RADIUS)
      .setRangeValues(SEGMENTS_MIN_CORNER_RADIUS, SEGMENTS_MAX_CORNER_RADIUS)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsHeightRange = cp5.addRange("seg. height")
      .setBroadcast(false) 
      .setPosition(10, 110)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SEGMENTS_MIN_HEIGHT, SEGMENTS_MAX_HEIGHT)
      .setRangeValues(SEGMENTS_MIN_HEIGHT, SEGMENTS_MAX_HEIGHT)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsWidthRange = cp5.addRange("seg. width")
      .setBroadcast(false) 
      .setPosition(10, 150)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SEGMENTS_MIN_WIDTH, SEGMENTS_MAX_WIDTH)
      .setRangeValues(SEGMENTS_MIN_WIDTH, SEGMENTS_MAX_WIDTH)
      .moveTo("segments")
      .setBroadcast(true);

    // colors
    segmentsRedRange = cp5.addRange("seg. red")
      .setBroadcast(false) 
      .setPosition(10, 230)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsGreenRange = cp5.addRange("seg. green")
      .setBroadcast(false) 
      .setPosition(10, 270)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsBlueRange = cp5.addRange("seg. blue")
      .setBroadcast(false) 
      .setPosition(10, 310)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);


    // Stripe Colors
    segmentsStripeRedRange = cp5.addRange("stripe red")
      .setBroadcast(false) 
      .setPosition(10, 390)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsStripeGreenRange = cp5.addRange("stripe green")
      .setBroadcast(false) 
      .setPosition(10, 430)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsStripeBlueRange = cp5.addRange("stripe blue")
      .setBroadcast(false) 
      .setPosition(10, 470)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(MIN_COLOR, MAX_COLOR)
      .setRangeValues(MIN_COLOR, MAX_COLOR)
      .moveTo("segments")
      .setBroadcast(true);

    segmentsStripeSideRange = cp5.addRange("stripe side")
      .setBroadcast(false) 
      .setPosition(10, 510)
      .setSize(180, 30)
      .setHandleSize(20)
      .setRange(SEGMENTS_MIN_SIDE, SEGMENTS_MAX_SIDE)
      .setRangeValues(SEGMENTS_MIN_SIDE, SEGMENTS_MAX_SIDE)
      .moveTo("segments")
      .setBroadcast(true);
  }

  void setRangeValues() {
    segments_minWidth = SEGMENTS_MIN_WIDTH;
    segments_maxWidth = SEGMENTS_MAX_WIDTH;
    segments_minHeight = SEGMENTS_MIN_HEIGHT;
    segments_maxHeight = SEGMENTS_MAX_HEIGHT;

    segments_minCornerBottom = SEGMENTS_MIN_WIDTH;
    segments_maxCornerBottom = SEGMENTS_MAX_WIDTH;
    segments_minCornerTop = SEGMENTS_MIN_WIDTH;
    segments_maxCornerTop = SEGMENTS_MAX_WIDTH;

    segments_minRed = MIN_COLOR;
    segments_maxRed = MAX_COLOR;
    segments_minGreen = MIN_COLOR;
    segments_maxGreen = MAX_COLOR;
    segments_minBlue = MIN_COLOR;
    segments_maxBlue = MAX_COLOR;

    segments_minStripeRed = MIN_COLOR;
    segments_maxStripeRed = MAX_COLOR;
    segments_minStripeGreen = MIN_COLOR;
    segments_maxStripeGreen = MAX_COLOR;
    segments_minStripeBlue = MIN_COLOR;
    segments_maxStripeBlue = MAX_COLOR;

    segments_minStripeSide = SEGMENTS_MIN_SIDE;
    segments_maxStripeSide = SEGMENTS_MAX_SIDE;

    try {
      segmentsWidthRange.setRangeValues(segments_minWidth, segments_maxWidth);
      segmentsHeightRange.setRangeValues(segments_minHeight, segments_maxHeight);

      segmentsCornerTopRange.setRangeValues(segments_minCornerTop, segments_maxCornerTop);
      segmentsCornerBottomRange.setRangeValues(segments_minCornerBottom, segments_maxCornerBottom);

      segmentsRedRange.setRangeValues(segments_minRed, segments_maxRed);
      segmentsGreenRange.setRangeValues(segments_minGreen, segments_maxGreen);
      segmentsBlueRange.setRangeValues(segments_minBlue, segments_maxBlue);

      segmentsStripeRedRange.setRangeValues(segments_minStripeRed, segments_maxStripeRed);
      segmentsStripeGreenRange.setRangeValues(segments_minStripeGreen, segments_maxStripeGreen);
      segmentsStripeBlueRange.setRangeValues(segments_minStripeBlue, segments_maxStripeBlue);
    }
    catch(NullPointerException e) {
    }
    finally {
    }
  }

  void handleEvents(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(segmentsRedRange)) {
      segments_minRed = int(theControlEvent.getController().getArrayValue(0));
      segments_maxRed = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minRed, segments_maxRed: " + segments_minRed + ", " + segments_maxRed);
    }

    if (theControlEvent.isFrom(segmentsGreenRange)) {
      segments_minGreen = int(theControlEvent.getController().getArrayValue(0));
      segments_maxGreen = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minGreen, segments_maxGreen: " + segments_minGreen + ", " + segments_maxGreen);
    }

    if (theControlEvent.isFrom(segmentsBlueRange)) {
      segments_minBlue = int(theControlEvent.getController().getArrayValue(0));
      segments_maxBlue = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minBlue, segments_maxBlue: " + segments_minBlue + ", " + segments_maxBlue);
    }

    if (theControlEvent.isFrom(segmentsCornerBottomRange)) {
      segments_minCornerBottom = int(theControlEvent.getController().getArrayValue(0));
      segments_maxCornerBottom = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minCornerBottom, segments_maxCornerBottom: " + segments_minCornerBottom + ", " + segments_maxCornerBottom);
    }  

    if (theControlEvent.isFrom(segmentsCornerTopRange)) {
      segments_minCornerTop = int(theControlEvent.getController().getArrayValue(0));
      segments_maxCornerTop = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minCornerTop, segments_maxCornerTop: " + segments_minCornerTop + ", " + segments_maxCornerTop);
    }  

    if (theControlEvent.isFrom(segmentsWidthRange)) {
      segments_minWidth = int(theControlEvent.getController().getArrayValue(0));
      segments_maxWidth = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minWidth, segments_maxWidth: " + segments_minWidth + ", " + segments_maxWidth);
    }  

    if (theControlEvent.isFrom(segmentsHeightRange)) {
      segments_minHeight = int(theControlEvent.getController().getArrayValue(0));
      segments_maxHeight = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minHeight, segments_maxHeight: " + segments_minHeight + ", " + segments_maxHeight);
    }  



    // Segment Stripes
    if (theControlEvent.isFrom(segmentsStripeRedRange)) {
      segments_minStripeRed = int(theControlEvent.getController().getArrayValue(0));
      segments_maxStripeRed = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minStripeRed, segments_maxStripeRed: " + segments_minStripeRed + ", " + segments_maxStripeRed);
    }

    if (theControlEvent.isFrom(segmentsStripeGreenRange)) {
      segments_minStripeGreen = int(theControlEvent.getController().getArrayValue(0));
      segments_maxStripeGreen = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minStripeGreen, segments_maxStripeGreen: " + segments_minStripeGreen + ", " + segments_maxStripeGreen);
    }

    if (theControlEvent.isFrom(segmentsStripeBlueRange)) {
      segments_minStripeBlue = int(theControlEvent.getController().getArrayValue(0));
      segments_maxStripeBlue = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minStripeBlue, segments_maxStripeBlue: " + segments_minStripeBlue + ", " + segments_maxStripeBlue);
    }

    if (theControlEvent.isFrom(segmentsStripeSideRange)) {
      segments_minStripeSide = int(theControlEvent.getController().getArrayValue(0));
      segments_maxStripeSide = int(theControlEvent.getController().getArrayValue(1));
      println("segments_minStripeSide, segments_maxStripeSide: " + segments_minStripeSide + ", " + segments_maxStripeSide);
    }
  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new SegmentSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
