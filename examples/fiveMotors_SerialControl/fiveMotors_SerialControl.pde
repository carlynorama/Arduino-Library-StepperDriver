/*

 This code is the Hello World on the VEXTA UD2115 on the Arduino.
 It uses the Two-Pulse Wire approach to move the motor - i.e. pulsing
 one wire moves it one direction, pulsing a second wire moves it the
 other direction.
 
 Each pair of wires on the VEXTA is actually leads through a photocoupler
 
 - The (+) wire is the source for lighting it and therefore 
 is ALWAYS held HIGH (could probably be just Vcc)
 - The (-) wire is the sink, and is sent LOW to create the pulse 
 the VEXTA stepper driver is looking for as a signal to step. 
 Otherwise this line should be kept HIGH
 
 The Circuit:
 * PIN 4: Attached to attached to the Pulse Input Terminal (+) 
 This pin is ALWAYS held HIGH, should be able to just tie it 
 to the Vcc Bus, check this
 * PIN 5: To Pulse Input Terminal (-)
 * PIN 6: Attached to attached to the direction (CW/CCW) Input 
 Terminal (+) This pin is ALWAYS held HIGH, should be able to 
 just tie it to the Vcc Bus, check this
 * PIN 7: Attached to the direction (CW/CCW) Input Terminal (-)
 * GND - must be attached to the FG connection at the end of the
 VEXTA's terminal block. 
 
 The Behavior:
 The motor moves 50 steps to the left 
 The motor moves 100 steps to the right
 The motor moves 200 steps to the left
 The motor moves 400 steps to the right
 System Pauses 
 
 Written By: Carlyn Maw
 Created On:  May 12, 2011 for the Natural History Museum, Los Angeles
 
 */

//------------------------------------------------------------------ START VARIABLE DEC

//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <StepperMotor.h>

//DEFINE: STEP TWO, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
const int baudRate = 9600;
boolean debugFlag = 0;
boolean serialListenerFlag = 1;

//DEFINE: STEP THREE, INPUTS AND THEIR VARIABLES

//------------------------  Signals from the Motor on NEW vertex only
//Not in the the UD2115
//boolean m_overheatFlag = 0; 
// Not in the UD2115
//boolean m_TimingSignal = 0; 

//DEFINE: STEP FOUR, OUTPUTS AND THEIR VARIABLES

//------------------------------------ Motor Control
const int numberOfMotorPins = 7;

//_plsNegPin (yellow)
//_dirNegPin (red)
//_plsPlusPin (black)
//_dirPlusPin (green)
//_homeLimitPin  (blue)
//_topLimitPin   (red/orange) 
//_bottomLimitPin (green/white)
  
int rMotorPins[numberOfMotorPins] = {28, 26, 24, 22, 30, 99, 99};

int zMotorPins[numberOfMotorPins] = {32, 34, 35, 37, 99, 38, 39};
//not wired up completely so I put in all 99's for limits even
//even though they are on the board. 
int fMotorPins[numberOfMotorPins] = {42, 44, 43, 45, 99, 99, 99}; 

int xMotorPins[numberOfMotorPins] = {6, 7, 8, 9, 10, 11, 12};
int yMotorPins[numberOfMotorPins] = {14, 15, 16, 17, 18, 19, 20};


StepperDriver rMotor = StepperDriver(numberOfMotorPins, rMotorPins);

StepperDriver zMotor = StepperDriver(numberOfMotorPins, zMotorPins);
StepperDriver fMotor = StepperDriver(numberOfMotorPins, fMotorPins);

StepperDriver xMotor = StepperDriver(numberOfMotorPins, xMotorPins);
StepperDriver yMotor = StepperDriver(numberOfMotorPins, yMotorPins);

//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Attach hardware serial functions and hardware objects
   Serial.begin(baudRate);
   
   //myMotor.setSpeed();
   //On: 1 - move this one up _after_ fiddling with off. 
   //Off: typical the original we settled on was 7, the new fast 3
   rMotor.setSpeed(1, 7);
     
   zMotor.setSpeed(1, 7);
   fMotor.setSpeed(1, 7);
   
   xMotor.setSpeed(1, 2);
   yMotor.setSpeed(1, 2); 


  //SETUP STEP TWO: Set digital pin mode for inputs and their initial conditions

  //SETUP STEP THREE: Set digital pin mode for outputs and their initial conditions

}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  //LOOP: STEP ONE, CHECK THE TIME 

  //LOOP: STEP TWO, POLL THE ENVIRONMENT
  if (serialListenerFlag && Serial.available() > 0) {
    respondToSerial();
  }

  //LOOP: STEP THREE, DO SOMETHING ABOUT IT

  /*
  turnCCW(50); //go 50 steps Counter Clockwise
  changeDirection(); //doesn't actually change the direction in this version - just forces the pause
  turnCW(100); //go 100 steps Clockwise
  changeDirection(); //etc...
  turnCCW(200);
  changeDirection();
  turnCW(400);
  changeDirection();

  delay(2000); //pause to let us know we are at the end.
  */

  //LOOP STEP THREE: TELL ME WHAT'S GOING ON
  // if (debugFlag) {
  //no seial messages yet
  // }


}  

//------------------------------------------------------------------ END MAIN LOOP


