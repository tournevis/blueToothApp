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
void setup()
{
  pinMode(LEDPIN, OUTPUT);
  pinMode(MOTORPIN, OUTPUT);
  glow = true;
  analogWrite(MOTORPIN, 0);
  mySerial.begin(9600);
  mySerial.println("Connected");
  Serial.begin(9600);
  Serial.println("Ready");
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
    byte speed = mySerial.read();
    if (speed > 0 ) {
      analogWrite(MOTORPIN, speed);
    }
    // If a measurement is requested, measure data and send it back
    mySerial.println("Speed set at " + String(speed) + " from Phone !");
    if ( Serial.available()){
      Serial.println("Speed set at " + String(speed) + " from Phone !");
    }
  }

  /*** LED 13 to debug ***/
  glow ? digitalWrite(LEDPIN, LOW) : digitalWrite(LEDPIN, HIGH);

}
