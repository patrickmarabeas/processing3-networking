
import processing.net.*;

Canvas canvas;

String cIP = "127.0.0.1";
int cPort = 3001;
int sPort = 3000;


void setup() {
  size(100, 100);
  frameRate(10);
  
  background(204);
  stroke(0);
  
  canvas = new Canvas(this, cIP, cPort, sPort);
  
}

void draw() {
  
  canvas.draw();

}




class P2P {
  
  String cIP;
  int cPort;
  int sPort;
  long lastConnectionCheck;
  boolean connected;
  
  PApplet cParent;
  
  Server s;
  Client c;
  
  public P2P(String cIP, int cPort, int sPort) {
    this.cIP = cIP;
    this.cPort = cPort;
    this.sPort = sPort;
  }
  
  public Server initServer(PApplet parent) {
    s = new Server(parent, sPort);
    return s;
  }
  
  public Client initClient(PApplet parent) {
    cParent = parent;
    c = new Client(parent, cIP, cPort);
    return c;
  }
  
  //public void run() {
  //  checkConnection();
  //}
  
  public boolean isConnected() {
    return connected;
  }
  
  public void ping() {
    
  }
  
  private void checkConnection() {
    if(lastConnectionCheck < millis() - 2000) {
      println("Checking connection");
      lastConnectionCheck = millis();
      if(c.active() == false) {
        println("Reconnecting");
        initClient(cParent);
      } else {
        println("Connection Good");
      }
    }
    
  }
  
}


class Canvas extends P2P {
  
  String input;
  int data[];
  
  Server s;
  Client c;
  
 Canvas(PApplet parent, String cIP, int cPort, int sPort) {
    super(cIP, cPort, sPort);
    super.initServer(parent);
    super.initClient(parent);
 }
 
 public void draw() {
   
   super.checkConnection();
   
   if (mousePressed == true) {
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY);
    super.s.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
   }
    
   if (super.c.available() > 0) { 
    input = super.c.readString();
    input = input.substring(0, input.indexOf("\n"));
    data = int(split(input, ' '));
    stroke(0);
    line(data[0], data[1], data[2], data[3]);
   }
   
 }
  
}