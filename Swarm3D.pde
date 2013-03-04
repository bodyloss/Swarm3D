/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/30083*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
///////////////////////////////////////////////
/* A simple swarm algorithm implementation based
 on Daniel Jones' AtomSwarm (www.erase.net)
 This is a stripped down version (all native
 Processing), generally cleaned up a little 
 with a couple of tweaks */
//////////////////////////////////////////////

Swarm swarm;
int curr = 0;
float rotation=0.1;

void setup() {
  size(800, 750, P3D);
  smooth();
  frameRate(100);
  
  background(0);
  
  ellipseMode(CENTER);
  strokeWeight(2.0);
  
  swarm = new Swarm();
  swarm.registerSwarm((byte)0, #E54ADE);
  swarm.registerSwarm((byte)1, #C11B29);
  swarm.registerSwarm((byte)2, #1B22C1);
  
  
  for (byte i =0; i < 3; i++) {
    for (int j = 0; j < 7; j++) {
      swarm.addParticle(width / 2, height / 2, height / 2, i);
    }
  }
  
  sphereDetail(20);
  
  camera(width/2.0 - 50, height/2.0 - 50, (height/2.0) / tan(PI*30.0 / 180.0) +400, width/2.0, height/2.0, 0, 0, 1, 0);
  
}

void draw() {
  float xpos= cos(radians(rotation)) * mouseX;
  float zpos= sin(radians(rotation)) * mouseX;
  
  camera(xpos - (width/2.0), mouseY - (height / 2), zpos + (height/2.0) / tan(PI*30.0 / 180.0) + 400, width / 2.0, height / 2.0, 0, 0, -1, 0);
  
  background(0);
  
//  pushMatrix();
//  fill(0, 10);
//  translate(width/2.0 - 50, height/2.0 - 50, (height/2.0) / tan(PI*30.0 / 180.0) +399);
//  rect(0, 0, width + 100, height + 100);
//  popMatrix();

  
  ambientLight(40, 40, 40, 255, 255, 255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(width, height, -height, -1, -1, 1);  
  
  pushMatrix();  
  translate(width / 2, height / 2);
  noFill();
  box(width, height, height);  
  popMatrix();

  // start the swarming..
  swarm.update();
}

void mousePressed() {
  // add and delete particles
  switch (mouseButton) {
    case LEFT:
      for (int i = 0; i < 50; i++)
        swarm.addParticle(mouseX, mouseY, 0, (byte)curr);
      curr = ++curr % 3;
      break;
    case RIGHT:
      break;
      
  }
  swarm.printUsage();
}

