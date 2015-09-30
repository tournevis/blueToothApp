// Bluetooth 
#include <SoftwareSerial.h>
SoftwareSerial mySerial(10, 11);
// Pin for the LED/motor
#define LEDPIN 13
#define MOTORPIN 6
bool glow;
// Setup
void setup()
{
  pinMode(LEDPIN, OUTPUT);
  pinMode(MOTORPIN, OUTPUT);
  glow = true;
  mySerial.begin(9600);
  mySerial.println("Connected");
  Serial.begin(9600);
  Serial.println("Ready");
}

void loop()
{
    /*** COMPUTER SERIAL ***/
    if (Serial.available()) {

      // Read command
      byte c = Serial.read ();

      // If a measurement is requested, measure data and send it back
      if (c == 'm'){

          glow = !glow;
    
          // Send data (temperature,humidity)
          Serial.println(String(glow) + " from Computer !");
          if (mySerial.available()) {
           Serial.println(String(glow) + " from Phone !");
         }
      }
  }
    /*** bluetooth Serial ***/
  if (mySerial.available()) {

      // Read command
      byte c = mySerial.read ();
      // If a measurement is requested, measure data and send it back
      if (c == 'm'){

          glow = !glow;
          
          // Send data (temperature,humidity)
          mySerial.println(String(glow) + " from Phone !");
      }
  }

  /*** LED 13 to debug ***/
  glow?digitalWrite(LEDPIN,LOW) : digitalWrite(LEDPIN,HIGH);
  glow?digitalWrite(MOTORPIN,LOW) : digitalWrite(MOTORPIN, HIGH);
}
