/*
	StepperDriver.h - - StepperDriver library for Wiring/Arduino - Version 0.1
	
	Original library 		(0.1) by Carlyn Maw.
	
 */

// ensure this library description is only included once
#ifndef StepperDriver_h
#define StepperDriver_h

// include types & constants of Wiring core API
#include "WProgram.h"

// library interface description
class StepperDriver {
 
  // user-accessible "public" interface
  public:
  // constructors:
    //StepperDriver(int myPlsPin, int myNegPin, bool myMode);
    //StepperDriver(int myBit, bool myMode, unsigned char *myRegister);
    
    StepperDriver(int pinArrayLength, int *myPinArray);
    
    //char* version(void);			// get the library version
    //unsigned char getRegisterValue(void);

	
	//bool isMoving(void);
    
    //int getPulseOnTime(void);
    //void setPulseOnTime(int);
    
    //int getPulseOffTime(void);
    //void setPulseOffTime(int);
    
    void turnCW(int);
    void turnCCW(int);
    
    int checkLimits();    // returns value of just the limit swtiches
    int checkHome();     // returns value of just home switch
    int checkSwitches(); //returns binary of all the switches (Top = 1 Home = 2 Bottom = 4)
    
    
    void setSpeed(int, int); 
    void fullStop();
	
 

  // library-accessible "private" interface
  private:
    
    int _myPinArrayLength;
    int *_myPinArray;
    
    int _plsNegPin;       //pin attached to the Pulse Input Terminal (-)

    //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
    int _plsPlusPin;      //pin attached to the Pulse signal Input Terminal (+)

    int _dirNegPin;   //pin attached to the Direction Input Terminal (-)

    //(below pin can just be tied to 5V, doesn't actually need to be a pin, I think.)
    int _dirPlusPin;
    
    int _limitHomePin;
    int _limitTopPin;
    int _limitBottomPin;
    
    //------------------------------------ Motor Characteristics & Settings
    int _minPulseOnTime;  //shortest duration of pulse for VEXTA logic to work in micro seconds
    int _minPulseOffTime; //shortest pause between pules in micro seconds
    int _directionResetPause; //shortes amount of time you should wait between changing directions...

    //Humans & Motor Scale timeing- for the delay in pulsePin();
    //Not constant in code because might want to change the speed dynamically
    int _pulseOnTime;  //this one should be kept as short as possible
    int _pulseOffTime; //lengthen this one first
    
    bool _fullStopFlag;
    
    
    
//add in version two a way to set this dynamically? Use these in code?
//const int m_degreesInRotation = 400;  // controlled by a dipswitch in motor driver, 
//if 5 is OFF then it is 1.8 deg / step or 200/revol
//if 5 is ON then it is 0.9 deg or 400/revol
//const int m_plsMode = 2;      // controlled by a dipswtich in motor driver
// 1 and 3 ON is 2 Pulse mode (set m_plsMode to 2 )
// 2 and 4 ON is 1 Pulse mode (set m_plsMode to 1)
	
	void pulsePin(int myPin, int myPulseOnDelay, int myPulseOffDelay);
	void changeDirection();
	bool checkFullStopFlag();

};

#endif

