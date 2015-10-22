#define mPin 3
const float pi = 3.14;
float var;
int degre;
float rad;
char myChar;
byte myByte;
int RXLED = 17;
int duration, intensity;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); //This pipes to the serial monitor
  Serial1.begin(9600);
  //Serial.begin(9600);
  duration = 1 ;
  var = 0 ;
  degre = 0;
  Serial.println("ready");
  pinMode(RXLED, OUTPUT);  // Set RX LED as an output
  pinMode(mPin, OUTPUT);
}

void loop() {
  if(Serial1.available()>0) {
    myByte = Serial1.read();
    // Moche , mais sachant que les valeur en dessous de 10 reviennent à ne pas trouné pour le moteur, autant s'en servier pour le contrôle de la durée plutôt que d'utiliser une string comme array qui demanderai beaucoup de ressources. 
    if(myByte < 10 ){
       duration = myByte;   
      }
     if(myByte >= 10 ){
       intensity = myByte; 
       var = myByte;
      }
    Serial.println(myByte);
  }else{
    duration = 0;
    degre += 15;
    var = sin(degre * ( pi /180 ) ) + 2 ;
    Serial.println(var);
  }
  
  analogWrite(mPin,var*30);
  digitalWrite(RXLED, LOW);   // set the LED on
  TXLED0; //TX LED is not tied to a normally controlled pin
  delay(250 * duration);              // wait for a second
  digitalWrite(RXLED, HIGH);    // set the LED off
  TXLED1;
  myByte = 0 ; 
  intensity =0 ;
  delay(40);              // wait for a second
  
}

