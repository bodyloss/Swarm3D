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

void setup() {
  size(800, 750, P3D);
  smooth();
  frameRate(60);
  
  background(0);
  
  ellipseMode(CENTER);
  strokeWeight(2.0);
  
  swarm = new Swarm();
  swarm.registerSwarm((byte)0, #E54ADE);
  swarm.registerSwarm((byte)1, #C11B29);
  swarm.registerSwarm((byte)2, #1B22C1);
  
  
  for (byte i =0; i < 3; i++) {
    for (int j = 0; j < 10; j++) {
      swarm.addParticle(width / 2, height / 2, height / 2, i);
    }
  }
  
  camera(width/2.0 - 50, height/2.0 - 50, (height/2.0) / tan(PI*30.0 / 180.0) +400, width/2.0, height/2.0, 0, 0, 1, 0);
  
}

void draw() {
  background(0);
  
  ambientLight(40, 40, 40, 255, 255, 255);
  directionalLight(255, 255, 255, 1, 1, -1);  
  
  pushMatrix();  
  translate(width / 2, height / 2);
  noFill();
  box(width - 80, height - 80, height - 80);  
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

