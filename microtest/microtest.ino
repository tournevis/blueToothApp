#define mPin 3
const float pi = 3.14;
float myDuration[] = {2, 60, 30, 60, 15, 30};
int myValue[] = { 255, 180, 240, 220, 240};
int durIndex, valIndex, degre;
float var, rad;
byte myByte;
long duration;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); //Serial Ordi
  Serial1.begin(9600); // Serial Bluetooth
  duration = 1 ;
  var = 0 ;
  degre = 0;
  Serial.println("ready");
}

void loop() {
  if (Serial1.available() > 0) {
    myByte = Serial1.read();
    // Les premiers byte sont donc l'intensité et le second sont pour le calcul de la durée 
    // Moche , mais sachant que les valeur en dessous de 10 reviennent à ne pas trouné pour le moteur, autant s'en servier pour le contrôle de la durée plutôt que d'utiliser une string comme array qui demanderai beaucoup de ressources.
    if (myByte < 6 ) {
      duration = myDuration[myByte] * 1000;
    }
    if (myByte >= 6 && myByte <= 11 ) {
      valIndex = myByte - 6;
      var = myValue[valIndex];
    }
    //Pour set la variable à la main depuis l'application mobile 
    if(myByte > 11){
      var = myByte;
     }
    Serial.println("Duration" );
    Serial.println(duration);
    Serial.println("INTENSITY" );
    Serial.println(var);
  }else {
    duration = 0;
    degre += 15;
    var = (sin(degre * ( pi / 180 ) ) + 2 ) * 25 ;
    Serial.println(var);
  }
  analogWrite(mPin, var);
  delay(duration + 40);              // si jamais duration est à zero 
  myByte = 0 ;
  delay(40);              // wait for a second
}

