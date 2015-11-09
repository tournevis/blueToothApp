package processing.test.bluetoothapp;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.Intent; 
import android.os.Bundle; 
import android.graphics.Bitmap; 
import android.graphics.BitmapFactory; 
import ketai.net.bluetooth.*; 
import ketai.ui.*; 
import ketai.net.*; 
import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class blueToothApp extends PApplet {










/** My Class Part **/
loader loader;
btn connectBtn;
btn sendDataBtn;
btn butBtn;
btn faultBtn;
btn penaltyBtn;
btn cartonjBtn;
/* LOS COLORES SCHEME SI SI 
    https://coolors.co/app/383d3b-aeffd8-00a896-02c39a-c52233
    https://coolors.co/app/383d3b-aeffd8-00a896-02c39a-f7ee4a
*/

KetaiBluetooth bt;


String info = "";
KetaiList klist;
boolean isConf, connecting, isConnect ;
String deviceName ="";
PFont avNextMed ;
float d;
int speed , slideVal ;
int c1 = 0xffFFCC00;
int back = 0xff383D3B;

//*****************************
// Enable Bluetooth at startup.
//*****************************

public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

public void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//****************************

public void setup()
{  
  orientation(PORTRAIT);
  background(back);
  stroke(255);
  isConf = true;
  connecting =false ;
  isConnect =false ;
  avNextMed = createFont("hirak.otf", 36, true);
  ellipseMode(CENTER);
  //start listening for BT connections
  loader = new loader(50, 255);
  connectBtn = new btn(0, height -150, width, 150, "CONNECT", color(0xff00A896));
  sendDataBtn = new btn(0, height -150, width, 150, "SEND DATA", color(0xff00A896));
  butBtn = new btn(0, height -300, width, 150, "BUTTTTT !", color(0xff90DCAD));
  faultBtn = new btn(0, height -450, width, 150, "FAUTE !", color(0xffAEFFD8));
  faultBtn.nameColor = color (0xff383D3B);
  penaltyBtn = new btn(0, height -600, width, 150, "PENALTY !", 0xffC52233);
  cartonjBtn = new btn(0, height -750, width, 150, "CARTON !", color(0xffF7EE4A));
  cartonjBtn.nameColor = color (0xff383D3B);

  bt.start();
  bt.discoverDevices();
}

public void draw() {
  if (isConf) {
    background(back);
    info ="";
    textFont(avNextMed);
    text(getBluetoothInformation(), 15, 60);
    ArrayList<String> names;
    names = bt.getDiscoveredDeviceNames();
    for (int i=0; i < names.size(); i++)
    {
      info += "["+i+"] "+names.get(i).toString() + "\n";
    }

    text("Aviable Device :\n\n" + info, 15, 360);

    pushStyle();
    noStroke();
    fill(0xff02C39A);
    rect(0, height -300, width, 150);
    popStyle();
    connectBtn.display();
    if (bt.isDiscovering() ) {
      loader.display(width/2, height -220 );
    } else {
      text("DISCOVER ", width/3, height-220);
    }

    if (connecting) {
      fill(255);
      pushStyle();
      fill(0);
      noStroke();
      alpha(100);
      rect(0, 0, width, height);
      popStyle();
      loader.display(width/2, height/2 + 60);
      text("Connecting to: \n" + deviceName, width/2 -200, height /2-20);
      getBluetoothInformation();
    }
  }
  if (isConnect) {
    background(back);
    // SLIDER SECTION 
    fill(255);
    text("Connected to " + deviceName, width/2 -150, 50);
    
    /**** SLIDER ****/
    
    pushStyle();
    strokeWeight(70);
    line(50, height/6, width-50, height/6);
    noStroke();
    fill(200);
   if (mouseX > 50 && mouseX < width-50 && mouseY < height/5 ) {
       slideVal = mouseX-30 ; 
    }
    ellipse(slideVal, height/6, 60, 60);
    popStyle();
    
    /**MY BUTTONS PARTS  **/
   
    sendDataBtn.display();
    butBtn.display();
    faultBtn.display();
    penaltyBtn.display();
     cartonjBtn.display();
  }
}

    /**** BLUETOOTH FUNCTION  *****/
public String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  if (devices.size() >0) {
    isConnect =true;
    isConf = false;
  } else {
    isConnect= false;
  }
  for (String device : devices)
  {
    btInfo+= device+"\n";
  }
  return btInfo;
}
class btn {
  int bwidth, bheight, bx, by; 
  int bcolor, nameColor;
  String name;
  boolean clicked;
  btn(int _bx, int _by, int _bwidth, int _bheight, String _name ,int _color) {
    bx= _bx;
    by = _by;
    bwidth =_bwidth;
    bheight = _bheight;
    name = _name;
    bcolor = _color;
    nameColor = color(255,255,255);
  }
  public void display() {

    pushMatrix();
    pushStyle();
    noStroke();
    fill(bcolor);
    rect(bx, by, bwidth, bheight);
    fill(nameColor);
    textSize(42);
    text(name ,bx + bwidth/3,by + bheight/2);
    popStyle();
    popMatrix();
   
  }
  public boolean clicked(int inputX , int inputY){
    if(inputX > bx && inputY > by && inputX < (bx+bwidth) && inputY < (by+bheight ) ){
      fill(bcolor);
      alpha(100);
      rect(bx, by, bwidth, bheight);
      return true; 
    } else {
      return false;
    }
  }
}
class loader{
  int raduis , alpha; 
  
  int rot;
  loader(int _raduis, int _alpha){
    raduis =_raduis;
    alpha = _alpha;
  }
  public void display(int x, int y){
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
public void mousePressed() {
  d = dist(mouseX, mouseY, width/2, height*0.8f );
  if (isConf) {
    if (connectBtn.clicked(mouseX, mouseY) ) {
      if (bt.getDiscoveredDeviceNames().size() > 0)
        klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
      else if (bt.getPairedDeviceNames().size() > 0)
        klist = new KetaiList(this, bt.getPairedDeviceNames());
      // bt.discoverDevices();
    }
    if (mouseY > height-300 && mouseY < height-150 && !bt.isDiscovering()) {  
      bt.discoverDevices();
      pushStyle();
      noStroke();
      fill(120);
      rect(0, height -300, width, 150);
      popStyle();
    }
  }
  /*** SEND DATA TO THE ARDUINO HERE  ***/
  if (isConnect ) {
    if (sendDataBtn.clicked(mouseX, mouseY) ) {
      byte[] bm = new byte[2];
      bm[0] = PApplet.parseByte(speed);
      bm[1] = PApplet.parseByte(0);
      bt.writeToDeviceName( deviceName, bm);
    }
    if (penaltyBtn.clicked(mouseX, mouseY) ) {
      byte[] bm = new byte[2];
      bm[0] = PApplet.parseByte(8);
      bm[1] = PApplet.parseByte(3);
      bt.writeToDeviceName( deviceName, bm);
    }
    if (butBtn.clicked(mouseX, mouseY) ) {
      byte[] bm = new byte[2];
      bm[0] = PApplet.parseByte(6);
      bm[1] = PApplet.parseByte(1);
      bt.writeToDeviceName( deviceName, bm);
    }
    if (faultBtn.clicked(mouseX, mouseY) ) {
      byte[] bm = new byte[2];
      bm[0] = PApplet.parseByte(7);
      bm[1] = PApplet.parseByte(2);
      bt.writeToDeviceName( deviceName, bm);
    }
    if (cartonjBtn.clicked(mouseX, mouseY) ) {
      byte[] bm = new byte[2];
      bm[0] = PApplet.parseByte(9);
      bm[1] = PApplet.parseByte(4);
      bt.writeToDeviceName( deviceName, bm);
    }
  }
}
public void mouseDragged() {
  if (isConnect) {
    //if ( d < 250 ) {
    /*pushStyle();
     fill( 150, 00, 00);
     ellipse(width/2, height*0.8, 150, 150);
     popStyle();*/
    if (mouseX > 40 && mouseX < width-40 && mouseY < height- 150) {
      float mapSpeed =  map(mouseX, 40, width-40, 0, 255);
      speed = PApplet.parseInt(mapSpeed);
    }
    //}
  }
}
public @Override
void onBackPressed() {
  if(isConnect){
    isConnect = !isConnect;
  }else{
    System.exit(0);
  }
}
public void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  deviceName = selection;
  bt.connectToDeviceByName(selection);
  connecting = true;

  //dispose of list for now

  klist = null;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "blueToothApp" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
