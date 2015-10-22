class btn {
  int bwidth, bheight, bx, by; 
  color bcolor, nameColor;
  String name;
  boolean clicked;
  btn(int _bx, int _by, int _bwidth, int _bheight, String _name ,color _color) {
    bx= _bx;
    by = _by;
    bwidth =_bwidth;
    bheight = _bheight;
    name = _name;
    bcolor = _color;
    nameColor = color(255,255,255);
  }
  void display() {

    pushMatrix();
    pushStyle();
    noStroke();
    fill(bcolor);
    rect(bx, by, bwidth, bheight);
    fill(nameColor);
    text(name ,bx + bwidth/3,by + bheight/2);
    popStyle();
    popMatrix();
  }
  boolean clicked(int inputX , int inputY){
    if(inputX > bx && inputY > by && inputX < (bx+bwidth) && inputY < (by+bheight ) ){
      fill(bcolor);
      alpha(150);
      rect(bx, by, bwidth, bheight);
      return true; 
    } else {
      return false;
    }
  }
}