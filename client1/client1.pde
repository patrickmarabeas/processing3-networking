
import processing.net.*;
import hypermedia.net.*; // UDP Networking: http://ubaa.net/shared/processing/udp/udp_class_udp.htm
import http.requests.*;

String cIP = "127.0.0.1";
int cPort = 3001;
int sPort = 3000;
String ipData = "";

Canvas canvas;
UDPP2P udp;
HTTPGET ipList;
GetRequest get;
JSONObject response;

void setup() {
  size(100, 100);
  frameRate(10);
  background(204);
  stroke(0);

  //canvas = new Canvas(this, cIP, cPort, sPort);
  //udp = new UDPP2P(this, sPort, cIP);
  
  get = new GetRequest("http://127.0.0.1:3002/");
  get.send();
  response = parseJSONObject(get.getContent());
  println(response);
  
  //ipList = new HTTPGET(this, "search.twitter.com", 80, "/search.atom?q=Nottingham");
  //ipList.request();
  //ipData = ipList.response();
  
  //println(ipData);
  
}

void draw() {
  //canvas.draw();
  //udp.run();
  //ipData = ipList.getData();
  //println(response);
}



class HTTPGET {
  
  String domain;
  int port;
  String address;
  String data;
  
  Client c;
  PApplet parent;
 
  HTTPGET(PApplet parent, String domain, int port, String address) {
    this.parent = parent;
    this.domain = domain;
    this.port = port;
    this.address = address;
    
    c = new Client(parent, domain, port);
  }
  
  public void request() {
   c.write("GET " + address + " HTTP/1.1\r\n");
   c.write("Host: " + domain + "\r\n");
   c.write("User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Ubuntu/10.04 Chromium/10.0.648.205 Chrome/10.0.648.205 Safari/534.16\r\n");
   c.write("Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5\r\n");
   c.write("Accept-Language: en-us,en;q=0.5\r\n");
   c.write("Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n");
   c.write("\r\n");
  }
  
  public String response() {
    if (c.available() > 0) { 
      return c.readString();
    } else {
      return response();
    }
    
  }
  
}




class UDPP2P {
  
  UDP local;
  
  UDPP2P(PApplet owner, int sPort, String cIP) {
    
    local = new UDP(owner, sPort, cIP);
    
  }
  
  public void run() {
    
  }
  
  
  
}




class TCPP2P {

  String cIP;
  int cPort;
  int sPort;
  long lastConnectionCheck;
  long startPing;
  boolean connected;

  PApplet cParent;

  Server s;
  Client c;

  public TCPP2P(String cIP, int cPort, int sPort) {
    this.cIP = cIP;
    this.cPort = cPort;
    this.sPort = sPort;
  }

  public void run() {
    checkConnection();
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

  public boolean isConnected() {
    return connected;
  }

  public void ping() {
    println(System.nanoTime());
  }

    public void checkConnection() {
    if (lastConnectionCheck < millis() - 1000) {
      println("Checking connection");
      lastConnectionCheck = millis();
      if (c.active() == false) {
        println("Reconnecting");
        initClient(cParent);
        connected = false;
      } else {
        println("Connection Good");
        connected = true;
      }
    }
  }
}


class Canvas extends TCPP2P implements java.io.Serializable {

  transient String input;
  transient int data[];

  Canvas(PApplet parent, String cIP, int cPort, int sPort) {
    super(cIP, cPort, sPort);
    super.initServer(parent);
    super.initClient(parent);
  }

  public void draw() {
    super.run();

    if (isConnected()) {

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
    }
  }
}