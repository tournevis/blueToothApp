void mousePressed() {
  d = dist(mouseX, mouseY, width/2, height*0.8 );
  if (isConf) {
    if (connectBtn.clicked(mouseX,mouseY) ) {
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
  if (isConnect && sendDataBtn.clicked(mouseX,mouseY) ) {
    pushStyle();
    fill(120);
    rect(0,height-150, width,150);
    popStyle();
    byte[] bm = new byte[1];
    bm[0] = byte(speed);
    bt.writeToDeviceName( deviceName, bm);
  }
}
void keyPressed() {
  /* if (key == CODED){
   if(keyCode == KeyEvent.KEYCODE_BACK){
   isConnect = false ;
   connecting = false;
   deviceName = "";
   }
   }
   */
}
void mouseDragged() {
  if (isConnect) {

    //if ( d < 250 ) {
    /*pushStyle();
     fill( 150, 00, 00);
     ellipse(width/2, height*0.8, 150, 150);
     popStyle();*/
    if (mouseX > 40 && mouseX < width-40 && mouseY < height- 150) {
      float mapSpeed =  map(mouseX, 40, width-40, 0, 255);
      speed = int(mapSpeed);
    }
    //}
  }
}
void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  deviceName = selection;
  bt.connectToDeviceByName(selection);
  connecting = true;

  //dispose of list for now

  klist = null;
}