// Bluetooth
#include <SoftwareSerial.h>
SoftwareSerial mySerial(10, 11);
// Pin for the LED/motor
#define LEDPIN 13
#define MOTORPIN 3
bool glow, lastGlow;
// Setup
long lastDebounceTime;
long debounceDelay = 50;
byte duration = 0;
void setup()
{
  pinMode(LEDPIN, OUTPUT);
  pinMode(MOTORPIN, OUTPUT);
  glow = false;
  analogWrite(MOTORPIN, 0);
  mySerial.begin(9600);
  mySerial.println("Connected");
  Serial.begin(9600);
  Serial.println("Ready");
  duration =0;
}

void loop()
{
  /*** DEBOUNCE ***/

  /*** COMPUTER SERIAL ***/
  if (Serial.available()) {

    // Read command
    byte c = Serial.read ();

    // If a measurement is requested, measure data and send it back
    if (c == 'm') {

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
    //  int speed = mySerial.parseInt();
      duration = mySerial.read();
      glow = !glow;
    // If a measurement is requested, measure data and send it back
    //mySerial.println("Speed set at " + String(speed) + " from Phone !");
  //  if ( duration >0){
      Serial.println("Duration set at " + String(duration) + " from Phone !");
    //}
  }

  /*** LED 13 to debug ***/
  glow ? digitalWrite(LEDPIN, LOW) : digitalWrite(LEDPIN, HIGH);
  if (glow){  
    analogWrite(MOTORPIN, 100);  
    delay(duration);
    analogWrite(MOTORPIN, 0);
    glow =false;
  }
  
 
}
