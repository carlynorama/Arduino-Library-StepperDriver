/*
  StepperDriver.h - StepperDriver for Wiring/Arduino
  (cc) 2007 Carlyn Maw .  Some rights reserved.
  
  Created 29 Oct 2010
  Version 0.1
*/


// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "StepperDriver.h"

   
  
// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

//------------------------------------------------------ Using Arduino Pin Num
StepperDriver::StepperDriver(int pinArrayLength, int *myPinArray)
{
    // initialize this instance's variables
    this ->_myPinArrayLength = pinArrayLength;
    this->_myPinArray = myPinArray;
    
  //motor pins  
  for (int p = 0; p <= 3 ; p++) {
    pinMode(_myPinArray[p], OUTPUT);
    digitalWrite(_myPinArray[p], HIGH);
  }
  
 //limit switch pins 
 for (int p = 4; p < _myPinArrayLength ; p++) {
    pinMode(_myPinArray[p], INPUT);
    //digitalWrite(_myPinArray[p], HIGH); these are HIGH/5V == true style. Can
    //only use internal pull ups when LOW/GND == true. 
  }
  
     //order in the array:
    //_plsNegPin (yellow)
    //_dirNegPin (red)
    //_plsPlusPin (black)
    //_dirPlusPin (green)
    //_limitHomePin  (blue)
    //_limitTopPin   (red/orange) 
    //_limitBottomPin (green)
    
    //the value of 99 means there is no pin.
  
    _plsNegPin = _myPinArray[0];       //pin attached to the Pulse Input Terminal (-)
    _dirNegPin = _myPinArray[1];   //pin attached to the Direction Input Terminal (-)

    //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
    _plsPlusPin= _myPinArray[2];       //pin attached to the Pulse signal Input Terminal (+)
    //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
    _dirPlusPin= _myPinArray[3]; 
   
    _minPulseOnTime = 10;  //shortest duration of pulse for VEXTA logic to work in micro seconds
    _minPulseOffTime= 10; //shortest pause between pules in micro seconds
    _directionResetPause= 20; //shortes amount of time you should wait between changing directions...

    //Humans & Motor Scale timeing- for the delay in pulsePin();
    //Not constant in code because might want to change the speed dynamically
    _pulseOnTime=1;  //this one should be kept as short as possible
    _pulseOffTime=7; //lengthen this one first

    //_pulseOnTime=400;  //this one should be kept as short as possible
    //_pulseOffTime=300; //lengthen this one first

    _limitHomePin = _myPinArray[4];
    _limitTopPin  = _myPinArray[5];
    _limitBottomPin = _myPinArray[6];
    
      
}

// Public Methods //////////////////////////////////////////////////////////////
// Functions available in Wiring sketches, this library, and other libraries

//---------////////////////////MAIN LOOP / LISTENER ///////////--------------//

//--------------------------------------------------------------------- turnCW()

void StepperDriver::turnCW(int mySteps) {

  //Everybody HIGH who is supposed to be
  
//      Serial.print("turning right ");
//      Serial.print(mySteps, DEC);
//      Serial.println(" steps");


  digitalWrite(_dirNegPin, HIGH);  
  
  digitalWrite(_plsPlusPin, HIGH); //<-- check to see if I can omit     
  digitalWrite(_dirPlusPin, HIGH); //<-- check to see if I can omit

  //pulse the number of times that their are steps. 
  //pulseOnTime and pulseOffTime are set once at the top for the motor
  for (int s = 0; s < mySteps; s++) {
    checkSwitches();
    //checkLimits();
    //checkHome();
    pulsePin(_plsNegPin, _pulseOnTime, _pulseOffTime);
    //pulsePin(_myPinArrayLength, _pulseOnTime, _pulseOffTime);
    //Serial.println(s, DEC);
  }
}

//--------------------------------------------------------------------- turnCCW()
    
void StepperDriver::setSpeed(int onTime, int offTime) {

    _pulseOnTime = onTime;   //this one should be kept as short as possible
    _pulseOffTime = offTime; //lengthen this one first
}
    
//--------------------------------------------------------------------- turnCCW()    
void StepperDriver::fullStop() {
    _fullStopFlag = true; 
}

//--------------------------------------------------------------------- turnCCW()

void StepperDriver::turnCCW(int mySteps) {

  //Everybody HIGH who is supposed to be
  
//    Serial.print("turning left ");
//    Serial.print(mySteps, DEC);
//    Serial.println(" steps");

  digitalWrite(_plsNegPin, HIGH);  
  
  digitalWrite(_plsPlusPin, HIGH); //<-- check to see if I can omit     
  digitalWrite(_dirPlusPin, HIGH); //<-- check to see if I can omit

  //pulse the number of times that their are steps. 
  //pulseOnTime and pulseOffTime are set once at the top for the motor
  for (int s = 0; s < mySteps; s++) {
    checkSwitches();
    //checkHome();
    //pulsePin(5, _pulseOnTime, _pulseOffTime);
    pulsePin(_dirNegPin, _pulseOnTime, _pulseOffTime);
    //Serial.println(s, DEC);
  }
}

int StepperDriver::checkSwitches() {

    int switchMessage = 0;


   if (_limitTopPin !=99) {
        if (digitalRead(_limitTopPin)) {
            switchMessage = switchMessage + 1;
        } else {
            //Serial.print("  keep going up ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
    
   if (_limitBottomPin !=99) {
        if (digitalRead(_limitBottomPin)) {
            switchMessage = switchMessage + 4;
        } else {
            //Serial.print("  keep going down ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
    
    
    if (_limitHomePin !=99) {
        if (digitalRead(_limitHomePin)) {
            switchMessage = switchMessage + 2;
            
        } else {
            //Serial.print("  Not there yet... ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
    
    //Serial.println(switchMessage, BIN);
    //Serial.println("--");
    
    return switchMessage;
}

int StepperDriver::checkLimits() {

    int errorMessage = 0;


   if (_limitTopPin !=99) {
        if (digitalRead(_limitTopPin)) {
            errorMessage = 1;
            Serial.print("!");
        } else {
            //Serial.print("  keep going up ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
    
   if (_limitBottomPin !=99) {
        if (digitalRead(_limitBottomPin)) {
            errorMessage = 1;
            Serial.print("!");
        } else {
            //Serial.print("  keep going down ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
        
    return errorMessage;
}
    
int StepperDriver::checkHome() {

    int homeStatus = 0;

   if (_limitHomePin !=99) {
        if (digitalRead(_limitHomePin)) {
            Serial.print("h");
            homeStatus = 1;
        } else {
            //Serial.print("  Not there yet... ");
        }
    } else {
         //Serial.print(" You know, I don't really care. ");
    }
    //Serial.println("--");
    
    return homeStatus;
}

  

// Private Methods //////////////////////////////////////////////////////////////
// Functions available to the library only.

//--------------------------------------------------------------------- pulsePin()
void StepperDriver::pulsePin(int myPin, int myPulseOnDelay, int myPulseOffDelay) {
  //Pulsed pin should be HIGH when this function starts, but it does't really
  //matter because the VEXTA is looking for a change from low to high after 
  //a suffient time of it haveing been low (i.e. it is debounced)
  //Serial.println("pulsing");

  digitalWrite(myPin, LOW);
  delayMicroseconds(_minPulseOnTime); // what is needed for the logic circuit
  delay(myPulseOnDelay);               //what is needed by the motor & or humans
  digitalWrite(myPin, HIGH);
  delayMicroseconds(_minPulseOffTime);  // what is needed for the logic circuit
  delay(myPulseOffDelay);                //pulsewhat is needed by the motor & or humans
 // Serial.print("named pin");
  
  //digitalWrite(5, LOW);
  //delayMicroseconds(_minPulseOnTime); // what is needed for the logic circuit
  //delay(myPulseOnDelay);               //what is needed by the motor & or humans
  //digitalWrite(5, HIGH);
  //delayMicroseconds(_minPulseOffTime);  // what is needed for the logic circuit
  //delay(myPulseOffDelay);                //pulsewhat is needed by the motor & or humans
  
  
  
}


//--------------------------------------------------------------------- changeDirection()
//forces all the pins to be back at HIGH
//forces a decent wait time to change momentum


//is this an Error???

void StepperDriver::changeDirection() {  
  digitalWrite(_plsNegPin, HIGH);       //pin attached to the Pulse Input Terminal (-)
  //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
  digitalWrite(_plsPlusPin, HIGH);      //pin attached to the Pulse signal Input Terminal (+)
  digitalWrite(_dirNegPin, HIGH);   //pin attached to the Direction Input Terminal (-)
  //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
  digitalWrite(_dirPlusPin, HIGH);  //pin attached to the Direction Input Terminal (+)

  delayMicroseconds(300); //for the computer
  delay(1000); //for the motor 
}


