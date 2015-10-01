import android.content.Intent;
import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import oscP5.*;

loader loader;
KetaiBluetooth bt;
String info = "";
KetaiList klist;
boolean isConf, connecting, isConnect ;
String deviceName ="";
PFont avNextMed ;
float d;
int speed ;
color c1 = #FFCC00;
color back = color(78, 93, 75);
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


///////////////////////////// Config your setup here! ////////////////////////////

// This is where you enter your Oauth info
static String OAuthConsumerKey = "Hnb2caMQlkw4veaXCOR2Pw";
static String OAuthConsumerSecret = "FxlCn9q3tYp5ya4GP0087mtXGApeweojqpAkVbymmtc";
// This is where you enter your Access Token info
static String AccessToken = "471885262-wrfQt7P3p7CyUO6QQaihd9vy3uoCZ95DBhMJlCzW";
static String AccessTokenSecret = "4QX8FH3IdPxUocLjaoqP0cmtuLNwGPrVqiPYEGjTg";

// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {"nasa"};
int tweetCount;
///////////////////////////// End Variable Config ////////////////////////////

TwitterStream twitter = new TwitterStreamFactory().getInstance();




void setup()
{  
  orientation(PORTRAIT);
  background(back);
  stroke(255);
  textSize(24);
  isConf = true;
  connecting =false ;
  isConnect =false ;
  avNextMed = createFont("hirak.otf", 32, true);
  ellipseMode(CENTER);
  //start listening for BT connections
  loader = new loader( 50, 255);
  bt.start();
  bt.discoverDevices();
  
  //Init Twitter :
  tweetCount= 0;
  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
}

// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
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
    fill(70);
    rect(0, height -150, width, 150);
    fill(100);
    rect(0, height -300, width, 150);
    popStyle();
    if (bt.isDiscovering() ) {
      loader.display(width/2, height -220 );
    } else {
      text("DISCOVER ",width/3,height-220);
    }
    text("CONNECT ",width/3,height-60);
    if (connecting) {
      pushStyle();
      fill(0);
      alpha(100);
      rect(0, 0, width, height);
      popStyle();
      loader.display(width/2, height/2 + 60);
      text("     Connecting to: \n" + deviceName, width/2 -200, height /2-20);
      getBluetoothInformation();
    }
  }
  if (isConnect) {
    background(78, 93, 75);
    // SLIDER SECTION 
    text("Connected to " + deviceName, width/2 -100, 50);
    text("Speed : " + speed, 70, 200);
    
    pushStyle();
    strokeWeight(5);
    line(50, height/2, width-50, height/2);
    noStroke();
    fill(5, 150, 00);
    if(mouseY < height-150){
      ellipse(mouseX- 75, height/2, 150, 150);
    }
    popStyle();
    
    //BOUTON 
    text("Send byte : " + speed , width/2 -40, height-60);
    pushStyle();
    fill(80);
    rect(0,height-150, width,150);
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