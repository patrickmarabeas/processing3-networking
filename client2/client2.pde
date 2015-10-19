
import processing.net.*;

Client c;
Server s;

String cIP = "127.0.0.1";
int cPort = 3000;
int sPort = 3001;

int state = 1;

String input;
int data[];

void setup() {
  size(100, 100);
  //frameRate(5);
  
  background(204);
  stroke(0);
  
  //s = new Server(this, sPort);
  c = new Client(this, cIP, cPort);
  
}

void draw() {
  
  switch(state) {
    
    case 0:
      c = new Client(this, cIP, cPort);
      if(c.active()) {
        state = 1;
      }
      break;
     
    case 1:
     
      if (mousePressed == true) {
        stroke(255);
        line(pmouseX, pmouseY, mouseX, mouseY);
        c.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
      }
    
      if (c.available() > 0) { 
        input = c.readString();
        input = input.substring(0, input.indexOf("\n"));
        data = int(split(input, ' '));
        stroke(0);
        line(data[0], data[1], data[2], data[3]);
      }
     
      break;
    
  }

}