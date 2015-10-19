
import processing.net.*;

Client c;
Server s;

String cIP = "127.0.0.1";
int cPort = 3001;
int sPort = 3000;

int state = 0;

String input;
int data[];

void setup() {
  size(100, 100);
  frameRate(10);
  
  background(204);
  stroke(0);
  
  s = new Server(this, sPort);
  c = new Client(this, cIP, cPort);
  
}

void draw() {
  
  if(c.active()) {
    
    if (mousePressed == true) {
     stroke(255);
     line(pmouseX, pmouseY, mouseX, mouseY);
     s.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
    }
    
    if (c.available() > 0) { 
     input = c.readString();
     input = input.substring(0, input.indexOf("\n"));
     data = int(split(input, ' '));
     stroke(0);
     line(data[0], data[1], data[2], data[3]);
    }
    
  } else {
    
   c = new Client(this, cIP, cPort); 
    
  }
  
   
  
    

}