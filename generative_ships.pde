/*

Generative Ships, by Clay Heaton, March 2018

This Processing sketch is a simple prototype of composition-based
procedural content generation. If the code base looks complicated,
note that over 80% of it is related to showing the UI widgets that
expose the various parameters to make it interactive. 

The parameters that users can tweak are listed just below this comment,
above the setup() function. Most of the drawing code is in the files for
the individual components: Flair, Segment, Wing, Tail, Cockpit, Ship, Armada,
near the top of those files. Most of the code below the classes at the top is
related to drawing the UI and reading values from it. Normally, you probably
wouldn't put this much effort into UI code; I simply did it for this example.

Flair is an example of a sub-component. It is drawn on the Wing objects. The
other components should be relatively straight forward. 

While this bears little resemblance to his work, it was inspired in part
by the lovely spaceship drawings of Rob Turpin, @thisnorthernboy on Twitter.

*/

import java.util.Random;

// Good UI library for Processing
// https://github.com/sojamo/controlp5/tree/master/examples/controllers
import controlP5.*;

boolean debug = true;

static int UI_PANEL_WIDTH = 255;
static int GRID_OUTER_MARGIN = 20;
static int GRID_INNER_MARGIN = 20;

static float SCALE_MIN = 0;
static float SCALE_MAX = 1.0;

static float SHEAR_MIN = 0;
static float SHEAR_MAX = 10.0;

static float ROTATION_MIN = 0;
static float ROTATION_MAX = TWO_PI;

static int MIN_COLOR = 0;
static int MAX_COLOR = 255;

/*
Background Color
 */
CheckBox bgCheckbox;
boolean dark_background = false;
color bg_dark = color(15, 40, 61);
color bg_white = color(255);


/*
FLAIR
 */
static int FLAIR_MIN_DIM = 0;
static int FLAIR_MAX_DIM = 100;
static float FLAIR_SHEAR_MIN = 0;
static float FLAIR_SHEAR_MAX = 1.0;

Range flairWidthRange, flairHeightRange, flairRotationRange, flairShearRange;
int flair_minWidth, flair_maxWidth;
int flair_minHeight, flair_maxHeight;
float flair_minRotation, flair_maxRotation;
float flair_minShear, flair_maxShear;

Range flairRedRange, flairGreenRange, flairBlueRange;
int flair_minRed, flair_maxRed;
int flair_minGreen, flair_maxGreen;
int flair_minBlue, flair_maxBlue;
/*
END FLAIR
 */

/*
COCKPITS
 */
static int COCKPIT_MIN_WIDTH = 50;
static int COCKPIT_MAX_WIDTH = 200;
static int COCKPIT_MIN_HEIGHT = 50;
static int COCKPIT_MAX_HEIGHT = 250;
static int COCKPIT_MIN_BAYS = 0;
static int COCKPIT_MAX_BAYS = 4;

Range cockpitWidthRange, cockpitHeightRange, cockpitBaysRange;
CheckBox cockpitCheckbox;
int cockpit_minWidth, cockpit_maxWidth;
int cockpit_minHeight, cockpit_maxHeight;
int cockpit_minBays, cockpit_maxBays;
boolean cockpit_window1, cockpit_window2;
boolean cockpit_type1, cockpit_type2, cockpit_type3;

Range cockpitRedRange, cockpitGreenRange, cockpitBlueRange;
int cockpit_minRed, cockpit_maxRed;
int cockpit_minGreen, cockpit_maxGreen;
int cockpit_minBlue, cockpit_maxBlue;

/*
END COCKPITS
 */

/*
WINGS
 */
static int WINGS_MIN_WIDTH = 20;
static int WINGS_MAX_WIDTH = 150;
static int WINGS_MIN_HEIGHT = 150;
static int WINGS_MAX_HEIGHT = 300;

Range wingsRedRange, wingsGreenRange, wingsBlueRange;
int wings_minRed, wings_maxRed;
int wings_minGreen, wings_maxGreen;
int wings_minBlue, wings_maxBlue;

Range wingsWidthTopRange, wingsWidthBottomRange, wingsHeightRange, wingsShearRange, wingsRotationRange;
int wings_minWidthTop, wings_maxWidthTop;
int wings_minWidthBottom, wings_maxWidthBottom;
int wings_minHeight, wings_maxHeight;
float wings_minShear, wings_maxShear;
float wings_minRotation, wings_maxRotation;

/*
END WINGS
 */

/*
SEGMENTS
 */
static int SEGMENTS_MIN_WIDTH = 50;
static int SEGMENTS_MAX_WIDTH = 200;
static int SEGMENTS_MIN_HEIGHT = 150;
static int SEGMENTS_MAX_HEIGHT = 250;
static int SEGMENTS_MIN_CORNER_RADIUS = 0;
static int SEGMENTS_MAX_CORNER_RADIUS = 100;
static int SEGMENTS_MIN_SIDE = 0;
static int SEGMENTS_MAX_SIDE = 4;

Range segmentsRedRange, segmentsGreenRange, segmentsBlueRange;
int segments_minRed, segments_maxRed;
int segments_minGreen, segments_maxGreen;
int segments_minBlue, segments_maxBlue;

Range segmentsWidthRange, segmentsHeightRange;
int segments_minWidth, segments_maxWidth;
int segments_minHeight, segments_maxHeight;

Range segmentsCornerTopRange, segmentsCornerBottomRange;
int segments_minCornerTop, segments_maxCornerTop;
int segments_minCornerBottom, segments_maxCornerBottom;

Range segmentsStripeRedRange, segmentsStripeGreenRange, segmentsStripeBlueRange, segmentsStripeSideRange;
int segments_minStripeRed, segments_maxStripeRed;
int segments_minStripeGreen, segments_maxStripeGreen;
int segments_minStripeBlue, segments_maxStripeBlue;
int segments_minStripeSide, segments_maxStripeSide;
/*
END SEGMENTS
 */

/*
TAILS
 */
static int TAILS_MIN_WIDTH = 40;
static int TAILS_MAX_WIDTH = 150;
static int TAILS_MIN_HEIGHT = 100;
static int TAILS_MAX_HEIGHT = 200;
static int TAILS_MIN_ENGINES = 1;
static int TAILS_MAX_ENGINES = 4;

Range tailsRedRange, tailsGreenRange, tailsBlueRange;
int tails_minRed, tails_maxRed;
int tails_minGreen, tails_maxGreen;
int tails_minBlue, tails_maxBlue;

Range tailsWidthRange, tailsHeightRange;
int tails_minWidth, tails_maxWidth;
int tails_minHeight, tails_maxHeight;

Range tailsEnginesRange;
int tails_minEngines, tails_maxEngines;
/*
END TAILS
 */



/*
 SHIPS
 */
static int SHIPS_MIN_SEGMENTS = 0;
static int SHIPS_MAX_SEGMENTS = 6;
static float SHIPS_MIN_AMPLITUDE = 0;
static float SHIPS_MAX_AMPLITUDE = 1;
static int SHIPS_MIN_WINGS = 0;
static int SHIPS_MAX_WINGS = 4;
static boolean SHIPS_WINGS_TOP = true;
static boolean SHIPS_WINGS_BOTTOM = true;

Range shipsSegmentsRange, shipsAmplitudeRange, shipsWingsRange;
int ships_minSegments, ships_maxSegments;
float ships_minAmplitude, ships_maxAmplitude;
int ships_minWings, ships_maxWings;

CheckBox shipsWingPositions;
boolean ships_wingsTop, ships_wingsBottom;
/*
 END SHIPS
 */


/*
ARMADAS
 */
static float ARMADAS_MIN_SCALE = 0.5;
static float ARMADAS_MAX_SCALE = 1.5;
Range armadasScaleRange;
float armadas_minScale, armadas_maxScale;
/*
END ARMADAS
 */


ControlP5 cp5;
Grid activeGrid, flairGrid, cockpitGrid, wingsGrid, segmentsGrid, tailsGrid, shipsGrid, armadasGrid;
ArrayList<Grid> grids;

void setup() {
  size(1280, 720); 

  grids = new ArrayList<Grid>();

  // Set up the Grids
  flairGrid = new FlairGrid(5, 3, "flair");  
  activeGrid = flairGrid;

  cockpitGrid = new CockpitGrid(3, 2, "cockpit");
  wingsGrid = new WingGrid(3, 1, "wings");
  segmentsGrid = new SegmentGrid(4, 2, "segments");
  tailsGrid = new TailGrid(3, 2, "tails");
  shipsGrid = new ShipGrid(1, 1, "ships");
  armadasGrid = new ArmadaGrid(4, 2, "armadas");

  grids.add(flairGrid);
  grids.add(cockpitGrid);
  grids.add(wingsGrid);
  grids.add(segmentsGrid);
  grids.add(tailsGrid);
  grids.add(shipsGrid);
  grids.add(armadasGrid);

  setupControls();

  for (Grid g : grids) {
    g.rebuild();
  }

  if (dark_background) {
    background(bg_dark);
  } else {
    background(bg_white);
  }
}

void draw() {
  if (dark_background) {
    background(bg_dark);
  } else {
    background(bg_white);
  }

  drawUIPanel();
  activeGrid.display();
}

void drawUIPanel() {
  noStroke();
  fill(128);
  rect(0, 0, UI_PANEL_WIDTH, height);
}



/*
CONTROLS
 */

void switchTabs(ControlEvent theControlEvent) {
  String tabName = theControlEvent.getTab().getName();
  println("Clicked " + tabName);

  if (tabName == "default") {
    activeGrid = flairGrid;
  } else if (tabName == "cockpits") {
    activeGrid = cockpitGrid;
  } else if (tabName == "wings") {
    activeGrid = wingsGrid;
  } else if (tabName == "segments") {
    activeGrid = segmentsGrid;
  } else if (tabName == "tails") {
    activeGrid = tailsGrid;
  } else if (tabName == "ships") {
    activeGrid = shipsGrid;
  } else if (tabName == "armadas") {
    activeGrid = armadasGrid;
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    switchTabs(theControlEvent);
    return;
  }
  activeGrid.handleEvents(theControlEvent);
}

void setupControls() {
  cp5 = new ControlP5(this);
  cp5.getTab("default").activateEvent(true).setLabel("flair").setId(1);
  cp5.addTab("cockpits").activateEvent(true).setId(2);
  cp5.addTab("wings").activateEvent(true).setId(3);
  cp5.addTab("segments").activateEvent(true).setId(4);
  cp5.addTab("tails").activateEvent(true).setId(5);
  cp5.addTab("ships").activateEvent(true).setId(6);
  cp5.addTab("armadas").activateEvent(true).setId(7);

  // Button to trigger redrawing of components
  cp5.addButton("rebuild")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(10 + UI_PANEL_WIDTH/2, height-40)
    .setSize(UI_PANEL_WIDTH/2 - 20, 30)
    .moveTo("global")
    .setBroadcast(true);

  // Button to reset components
  color c1 = color(240, 26, 16);
  color c2 = color(255, 0, 0);
  cp5.addButton("reset")
    .setBroadcast(false)
    .setValue(0)
    .setColorBackground(c1)
    .setColorForeground(c2)
    .setPosition(10, height-40)
    .setSize(UI_PANEL_WIDTH/2 - 20, 30)
    .moveTo("global")
    .setBroadcast(true);

  cp5.addButton("bgColor")
    .setBroadcast(false)
    .setValue(0)
    .setColorBackground(color(50))
    .setColorForeground(color(255))
    .setPosition(10, height - 80)
    .setSize(UI_PANEL_WIDTH/2 - 20, 30)
    .moveTo("global")
    .setBroadcast(true);

  flairGrid.createUIComponents();
  cockpitGrid.createUIComponents();
  wingsGrid.createUIComponents();
  segmentsGrid.createUIComponents();
  tailsGrid.createUIComponents();
  shipsGrid.createUIComponents();
  armadasGrid.createUIComponents();
}

// Functions called by controlp5 buttons
public void bgColor(int theValue) {
  dark_background = !dark_background;
}

public void rebuild(int theValue) {
  activeGrid.rebuild();
}

public void reset(int theValue) {
  activeGrid.setRangeValues();
  activeGrid.rebuild();
}
