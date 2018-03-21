class Sector {
  int xCoord, yCoord, w, h;
  PVector corner, center;

  Sector(int _x, int _y, PVector _corner, int _w, int _h) {
    this.xCoord = _x;
    this.yCoord = _y;
    this.corner = _corner;
    w = _w;
    h = _h;
    
    this.center = new PVector(this.corner.x + w/2, this.corner.y + h/2);
  }

  void display() {
    if (debug) {
      debugDisplay();
    }
  }
  
  void rebuild() {
     println("rebuild() not implemented in subclass");
  }

  void debugDisplay() {
    noFill();
    stroke(200);
    rect(this.corner.x, this.corner.y, this.w, this.h);
  }
}
