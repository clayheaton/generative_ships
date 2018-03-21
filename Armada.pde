class Armada {
  Ship ship;
  float sectorWidth, sectorHeight, scalefactor;
  Armada(float _sectorWidth, float _sectorHeight) {
    this.ship = new Ship();
    this.sectorWidth = _sectorWidth;
    this.sectorHeight = _sectorHeight;
    float scalefactorW = this.sectorWidth / this.ship.shipLength;
    float scalefactorH = this.sectorHeight / this.ship.shipHeight;
    this.scalefactor = min(1,this.scalefactor = min(scalefactorW,scalefactorH));
  }

  void display() {
    pushMatrix();
    scale(this.scalefactor);
    this.ship.display();
    popMatrix();
  }
}






class ArmadaSector extends Sector {
  Armada armada;
  ArmadaSector(int _x, int _y, PVector _corner, int _w, int _h) {
    super(_x, _y, _corner, _w, _h);
    rebuild();
  }
  void rebuild() {
    armada = new Armada(this.w, this.h);
  }

  void display() {
    if (debug) {
      debugDisplay();
    }

    pushMatrix();
    translate(this.center.x, this.center.y);
    this.armada.display();
    popMatrix();
  }
}




class ArmadaGrid extends Grid {
  ArmadaGrid(int _nx, int _ny, String _sectorType) {
    super(_nx, _ny, _sectorType);
    setRangeValues();
  }

  void createUIComponents() {

  }

  void setRangeValues() {

  }

  void handleEvents(ControlEvent theControlEvent) {

  }

  void makeSectors() {
    int sectorW = (int)(width - UI_PANEL_WIDTH - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsAcross - 1))) / this.sectorsAcross;
    int sectorH = (int)(height - (GRID_OUTER_MARGIN * 2) - (GRID_INNER_MARGIN * (this.sectorsDown - 1))) / sectorsDown;

    for (int y = 0; y < sectorsDown; y++) {
      for (int x = 0; x < sectorsAcross; x++) {
        PVector secCorner = new PVector(x*sectorW + GRID_OUTER_MARGIN + (x * GRID_INNER_MARGIN) + UI_PANEL_WIDTH, y*sectorH + GRID_OUTER_MARGIN + (y * GRID_INNER_MARGIN));
        Sector s = null;
        s = new ArmadaSector(x, y, secCorner, sectorW, sectorH);
        if (null != s) {
          sectors[x][y] = s;
        }
      }
    }
  }
}
