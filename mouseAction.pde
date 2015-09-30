void mouseReleased() {
  if (isConf) {
    if (mouseY > height-150 ) {
      if (bt.getDiscoveredDeviceNames().size() > 0)
        klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
      else if (bt.getPairedDeviceNames().size() > 0)
        klist = new KetaiList(this, bt.getPairedDeviceNames());
      // bt.discoverDevices();
      pushStyle();
      noStroke();
      fill(80);
      rect(0, height -150, width, 150);
      popStyle();
    }
  }
  if (isConnect) {
    if ( d < 50 ) {
      pushStyle();
      fill( 150,00,00);
       ellipse(width/2,height*0.8,150,150);
       popStyle();
      char m = 'm';
      byte[] bm = new byte[1];
      bm[0] = byte(m);
      if (bt.getConnectedDeviceNames().size() >0) {
        bt.writeToDeviceName( deviceName, bm);
      }
    }
  }
}
void mousePressed(){
  d = dist(mouseX, mouseY, width/2, height*0.8 );
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