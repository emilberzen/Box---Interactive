import processing.serial.*;
Serial myPort;
import codeanticode.syphon.*;

SyphonServer server;
float yaw = 0.0;
float pitch = 0.0;
float roll = 0.0;



void setup()
{
  //size(500,500,P3D);
  server = new SyphonServer(this, "Processing Syphon");
  fullScreen(P3D);
  scale(-1,-1);
  colorMode(RGB, 4); 
  // if you have only ONE serial port active
  myPort = new Serial(this, Serial.list()[0], 9600); // if you have only ONE serial port active

  // if you know the serial port name
  //myPort = new Serial(this, "COM5:", 9600);                    // Windows
  //myPort = new Serial(this, "/dev/ttyACM0", 9600);             // Linux
  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);  // Mac

  textSize(16); // set text size
  textMode(SHAPE); // set text mode to shape
}

void draw()
{
  serialEvent();  // read and parse incoming serial message
  background(255); // set background to white
  lights();

  translate(width/2, height/2); // set position to centre

  pushMatrix(); // begin object
  
 

  float c1 = cos(radians(roll));
  float s1 = sin(radians(roll));
  float c2 = cos(radians(pitch));
  float s2 = sin(radians(pitch));
  float c3 = cos(radians(yaw));
  float s3 = sin(radians(yaw));
  

  applyMatrix( c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
               -s2, c1*c2, c2*s1, 0,
               c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
              0, 0, 0, 1);

  drawArduino();
  
  popMatrix(); // end of object

  // Print values to console
  print(roll);
  print("\t");
  print(pitch);
  print("\t");
  print(yaw);
  println();
}

void serialEvent()
{
  int newLine = 13; // new line character in ASCII
  String message;
  do {
    message = myPort.readStringUntil(newLine); // read from port until new line
    if (message != null) {
      String[] list = split(trim(message), " ");
      if (list.length >= 4 && list[0].equals("Orientation:")) {
        yaw = float(list[1]); // convert to float yaw
        pitch = float(list[2]); // convert to float pitch
        roll = float(list[3]); // convert to float roll
      }
    }
  } while (message != null);
}

void drawArduino()
{
translate(0, 0, 0); 
fill(pitch/10%255,roll/10%255,yaw/10%255);
//rotateY(50);
//stroke(255,255,255);
strokeWeight(5);
//noFill();
//box(roll,roll,roll);

//box(pitch);
//box(yaw);

//box(roll-300);

//box(pitch-300);
//box(yaw-300);

//box(roll+300);
//box(pitch+300);
//box(yaw+300);
//translate(100,100,100);

box(300);
server.sendScreen();

}