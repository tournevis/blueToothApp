import android.content.Intent;
import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import oscP5.*;

KetaiBluetooth bt;
String info = "";
KetaiList klist;
boolean isConf, connecting, isConnect;
String deviceName ="";
PFont avNextMed ;
float d;
int speed ;
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
  background(78, 93, 75);
  stroke(255);
  textSize(24);
  isConf = true;
  connecting =false ;
  isConnect =false ;
  avNextMed = createFont("hirak.otf", 32, true);
  ellipseMode(CENTER);
  //start listening for BT connections
  bt.start();

  bt.discoverDevices();
}

void draw() {
  if (isConf) {
    background(78, 93, 75);
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
    fill(50);
    rect(0, height -150, width, 150);
    popStyle();
    text("Discover ", width/3, height -60);
    if (connecting) {
      pushStyle();
      fill(0);
      alpha(100);
      rect(0, 0, width, height);
      popStyle();
      text("Connecting to " + deviceName, width/2 -100, height /2-20);
       getBluetoothInformation();
    }
  }
  if(isConnect){
    background(78, 93, 75);
    text("Connected to " + deviceName, width/2 -100,50);
    text("Speed : " + speed, 70, 200);
    pushStyle();
    strokeWeight(5);
    line(50,height/2, width-50, height/2);
    noStroke();
    fill(5,150,00);
    ellipse(mouseX- 75 ,height/2,150,150);
    popStyle();
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
  if(devices.size() >0){
    isConnect =true;
  }else {
    isConnect= false;
  }
  for (String device : devices)
  {
    btInfo+= device+"\n";
  }
  return btInfo;
}