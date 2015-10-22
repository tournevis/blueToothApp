import android.content.Intent;
import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;

/** My Class Part **/ 
loader loader;
btn connectBtn;
btn sendDataBtn;
btn butBtn;
btn faultBtn;
btn penaltyBtn;


KetaiBluetooth bt;
String info = "";
KetaiList klist;
boolean isConf, connecting, isConnect ;
String deviceName ="";
PFont avNextMed ;
float d;
int speed ;
color c1 = #FFCC00;
color back = #383D3B;

//*****************************
// Enable Bluetooth at startup.
//*****************************

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//****************************

void setup()
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
  loader = new loader(50,255);
  connectBtn = new btn(0, height -150, width, 150, "CONNECT", color(#00A896));
  sendDataBtn = new btn(0, height -150, width, 150, "SEND DATA", color(#00A896));
  butBtn = new btn(0, height -300, width, 150, "BUTTTTT !", color(#90DCAD));
  faultBtn = new btn(0, height -450, width, 150, "FAUTE !", color(#AEFFD8));
  faultBtn.nameColor = color (#383D3B);
  penaltyBtn = new btn(0, height -600, width, 150, "PENALTY !", #C52233);
  
  bt.start();
  bt.discoverDevices();
}

void draw() {
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
    fill(#02C39A);
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
    text("Connected to " + deviceName, width/2 -100, 50);
    text("Speed : " + speed, 70, 200);

    pushStyle();
    strokeWeight(70);
    line(50, height/3, width-50, height/3);
    noStroke();
    fill(200);
    ellipse(mouseX-30, height/3, 60, 60);
    popStyle();
    sendDataBtn.display();
    butBtn.display();
    faultBtn.display();
    penaltyBtn.display();
  }
}

String getBluetoothInformation()
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