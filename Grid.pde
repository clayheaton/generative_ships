class Grid {
  int sectorsAcross, sectorsDown;
  String sectorType;
  Sector[][] sectors;

  Grid(int _nx, int _ny, String _sectorType) {
    this.sectorsAcross = _nx;
    this.sectorsDown = _ny;

    // Parse for establishing proper sectors
    this.sectorType = _sectorType;
    this.sectors = new Sector[this.sectorsAcross][this.sectorsDown];
    makeSectors();
  }

  void rebuild() {
    for (int x = 0; x < this.sectorsAcross; x++) {
      for (int y = 0; y < this.sectorsDown; y++) {
        Sector s = sectors[x][y];
        s.rebuild();
      }
    }
  }

  void display() {
    for (int x = 0; x < this.sectorsAcross; x++) {
      for (int y = 0; y < this.sectorsDown; y++) {
        Sector s = sectors[x][y];
        s.display();
      }
    }
  }
  
  void createUIComponents(){
    print("implement createUIComponents() in subclass");
  }
  
  void setRangeValues(){
    print("implement setRangeValues() in subclass");
  }
  
  void handleEvents(ControlEvent theControlEvent){
    print("implement handleEvents in subclass");
  }
  
  void makeSectors(){
    print("implement makeSectors in subclass");
  }

}
