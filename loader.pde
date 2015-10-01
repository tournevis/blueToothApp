class loader{
  int raduis , alpha; 
  
  int rot;
  loader(int _raduis, int _alpha){
    raduis =_raduis;
    alpha = _alpha;
  }
  void display(int x, int y){
     pushMatrix();
     pushStyle();
     translate(x,y);
     rotate(radians( rot%360 ) );
     stroke(255);
     strokeWeight(10);
     noFill();
     arc(0,0, raduis, raduis, PI, PI+QUARTER_PI );
     popStyle();
     popMatrix();
     rot += 8;
  }
  

}