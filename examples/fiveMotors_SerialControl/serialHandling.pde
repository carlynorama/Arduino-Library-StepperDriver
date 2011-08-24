

//----------------------------------------- VALID VALUES FOR SERIAL IN

//since all these values are going to be used in a case statement
//they must be CONSTANTS.

const byte startByte = '<';  //60  change to 1?
const byte endByte = '>';    // 62 change to 4?
const byte delimeter = ',';  // 44

//y
const byte upCommand = 'u'; //102
const byte downCommand = 'd';//98

//z
const byte zoomForwardCommand = 'f'; //117
const byte zoomBackCommand = 'b'; //100

//x
const byte rightCommand = 'r'; //114
const byte leftCommand = 'l'; //108

//rotational
const byte rotateClockWiseCommand = 'c'; //99
const byte rotateCounterClockWiseCommand = 'k'; //107

//focus
const byte focusInCommand = 'i'; //105
const byte focusOutCommand = 'o'; //111

const byte heatGunCommand = 'g'; //103

const byte fullStopCommand = 's'; //115

const byte helpSerialCommand = 104;     // "h" for help. see sendSerialHelp() for reply
const byte sysQuerySerialCommand = 113; // "q" to query for board info 

//this is the variable that the "c" and "u" conditions use to hold the value
//that is after the command. Variables cannot be defied within case statements
//so a local holding var can't be defined on the fly.
int myParameter; //address location, so int

//------------------------------------------ WHAT TO SAY IF IT IS INVALID
const char serialInvalidReply[] = {
  "invalid command, send 'h' (104) for a list of valid commands"};


//--------------------------------------------------------- START SERIAL FUNCTIONS

////------------------------------------------------------------ respondToSerial()
void respondToSerial()
{
  //get the first byte in the serial buffer
  int incomingByte = Serial.read();

  //do different things based on it's value..
  switch (incomingByte) {

  case leftCommand:
    myParameter= getParameter();
    xMotor.turnCCW(myParameter);
    Serial.write(leftCommand);
    if (debugFlag == true) {
      Serial.print("going left ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case rightCommand:
    myParameter= getParameter();
    xMotor.turnCW(myParameter);
    Serial.write(rightCommand);
    if (debugFlag == true) {
      Serial.print("going right ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case upCommand:
    myParameter= getParameter();
    yMotor.turnCW(myParameter);
    Serial.write(upCommand);
    if (debugFlag == true) {
      Serial.print("going forward ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case downCommand:
    myParameter= getParameter();
    yMotor.turnCCW(myParameter);
    Serial.write(downCommand);
    if (debugFlag == true) {
      Serial.print("going back ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case zoomForwardCommand:
    myParameter= getParameter();
    zMotor.turnCW(myParameter);
    Serial.write(zoomForwardCommand);
    if (debugFlag == true) {
      Serial.print("going up ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case zoomBackCommand:
    myParameter= getParameter();
    zMotor.turnCCW(myParameter);
    Serial.write(zoomBackCommand);
    if (debugFlag == true) {
      Serial.print("going down ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case rotateClockWiseCommand:
    myParameter= getParameter();
    rMotor.turnCW(myParameter);
    Serial.write(rotateClockWiseCommand);
    // turnCW(myParameter);
    if (debugFlag == true) {
      //Serial.print("got right ");
      Serial.print("turning right ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case rotateCounterClockWiseCommand:
    myParameter= getParameter();
    rMotor.turnCCW(myParameter);
    Serial.write(rotateCounterClockWiseCommand);
   // turnCCW(myParameter);
    if (debugFlag == true) {
      Serial.print("got left ");
      //Serial.print("turning left ");
      //Serial.print(myParameter, DEC);
      //Serial.println(" steps");
    }
    break;
    
    
   case focusInCommand:
    myParameter= getParameter();
    fMotor.turnCW(myParameter);
    Serial.write(focusInCommand);
    if (debugFlag == true) {
      Serial.print("focusing in ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case focusOutCommand:
    myParameter= getParameter();
    fMotor.turnCCW(myParameter);
    Serial.write(focusOutCommand);    
    if (debugFlag == true) {
      Serial.print("focusing out ");
      Serial.print(myParameter, DEC);
      Serial.println(" steps");
    }
    break;

  case fullStopCommand:
    //myParameter= getParameter();
    rMotor.fullStop();
    zMotor.fullStop();
    fMotor.fullStop();
    xMotor.fullStop();
    yMotor.fullStop();
    Serial.write(focusOutCommand);    
    if (debugFlag == true) {
      Serial.print("STTOOOOOPPPP!!! ");
    }
    break;


    //"if the value of the incomingByte is 104 (user typed lowercase h)"  
  case helpSerialCommand:
    sendSerialHelp();
    break;

    //"if the value of the incomingByte is 113 (user typed lowercase q)"  
  case sysQuerySerialCommand:
    sendQueryReply();
    break;

    //"if the value of the incomingByte is not any of the above" 
  default:
    Serial.println(serialInvalidReply);
    break;
  }

  //clear out the serial buffer because now all the rest is garbage. 
  Serial.flush();
}

////--------------------------------------------------------END respondToSerial()

////------------------------------------------------------------ sendSerialHelp()
void sendSerialHelp()
{
  Serial.println("");
  //normally you'd put something here about what type of commads were possible
  Serial.println("x motor: l <number of steps> or r <number of steps>\n"
    "y motor: u <number of steps> or d <number of steps>\n"
    "z motor (zoom): f <number of steps> or b <number of steps>\n"
    "platter motor motor: c <number of steps> or k <number of steps> (clockwise, counter)\n"
    "focusing motor: i <number of steps> or o <number of steps> (clockwise, counter)\n"    
    "everybody stop: s\n"
    "heat gun on: g 1\n"
    "heat gun off: g 0\n"
    "h_elp, q_uery  system values");
  Serial.println("");
}

////---------------------------------------------------------END sendSerialHelp()

////------------------------------------------------------------ sendQueryReply()
//this is a good place to return information about the circuit 
//(what is attached to it, etc) and their states/values
void sendQueryReply()
{
  Serial.println("");
  Serial.println("Serial controlled stepper motor interface.");
}
////---------------------------------------------------------END sendQueryReply()

////-------------------------------------------------------------- getParameter()
//this function is designed to get the bytes following the 
//the first byte (up to a number defined by "longestParameter" 
//i.e. shorter than the Serial objects, possible buffer which is 128)

//It turns the characters recieved into a number and then 
//Does something with it...

int getParameter()
{
  //array the length of the message you're expecting. 
  const int longestParameter = 5;
  char serialBuffer[longestParameter];

  // the returned variable that should be holding the str -> int info
  int myInfo; 

  //gimme a sec to make sure I've got everyone... 
  //this delay is needed so the case statement sees the i, 
  //and then waits for the rest of the information before 
  //it analyzes it. If you don't have it, it punts the new
  //bytes back to the case statement and throws an error. 
  delay(100);

  //how many more bytes (characters) are in the Serial Buffer?
  int serialChars = Serial.available();

  //in case you got more than the function can chew - a value longer than 5 characters
  if (serialChars > longestParameter) {
    if (debugFlag) {
      Serial.println("I can't count that high... I'm gonna give you garbage in a minute...");
    }
    //really should do a return at this point passing some 
    //value that would be understood as an error to the 
    //function's caller. 
  }

  // for each byte of available serial
  for (byte i = 0; i <= (serialChars - 1); i ++) { 

    //goes ahead and puts it in the buffer   
    serialBuffer[i] = Serial.read();

    //if it is not a space or a number (avr-libc functions) or the negative sign
    //white space /neg sign at the begining is okay by the strtol that we 
    //will be using later.
    if (!(isdigit(serialBuffer[i]) || isspace(serialBuffer[i]) || serialBuffer[i] == 45)) {
      //error message
      if (debugFlag) {
        Serial.println(" --- NUMBERS ONLY, Please");
      }
      //AGAIN: should do a return at this point passing some 
      //value that would be understood as an error to the 
      //function's caller. 
    } 
  }

  //turn your char array into a string by adding a null character 
  //at the very end.
  serialBuffer[serialChars] = NULL;

  //strol = C function to convert the string into an integer. 
  //"On success, the function returns the converted integral number as a long int value.
  //If no valid conversion could be performed, a zero value is returned."
  //the big problem: 0 is a valid value for our parameter which is why we checked
  //for valid digit characters before. 
  myInfo = strtol(serialBuffer, NULL, 10);

  //echoing back what I got
  //Serial.print("I heard: ");
  //Serial.println(myInfo, DEC);

  //pass the int back to the calling function.
  return myInfo;

}

////-----------------------------------------------------------END getParameter()






