import java.util.*;

class Swarm {

  /* This is the algorithm - checks each particle against
   a series of rules and updates vx and vy values - these  
   values determine the particle's new position */
   private Particle[] particleSet;
   private int index = 0;

  // change these to change swarm behaviour  
  private final float  inertia = 0.9, // sort of 'laziness' (0-1)
                       max_velocity = 12.0, // != speed
                       separation = 35, // min distance between particles
                       gravity_threshold = 500; // radius of particle attraction
                       
  private float maxX, maxY, maxZ;
  
  
  // Contains a mapping of our swarm id's to the colors we will draw them with
  private HashMap<Byte, Integer> swarms;
              
  private Random rand = new Random();
   
  Swarm() {
    particleSet = new Particle[5];
    swarms = new HashMap<Byte, Integer>();
    
    maxX = width - 40;
    maxY = height - 40;
    maxZ = height - 40;
  }
  
  /**
   * Register a new swarm id, and the color used to draw it
   */
  public void registerSwarm(byte id, color particleColor) {
     swarms.put(id, particleColor);
  }
  
  public void addParticle(int x_, int y_, int z_, byte swarmId) {
    if (!swarms.containsKey(swarmId)) {
       throw new NullPointerException("No swarm registerd for swarmId " + swarmId);
    }
    
    // check if we need to extend our array
    if (index == particleSet.length) {
       Particle[] temp = new Particle[(int)(particleSet.length * 1.5)];
       System.arraycopy(particleSet, 0, temp, 0, particleSet.length);
       particleSet = temp; 
    }
    
    // We introduce a tiny bit of randomness for initial positions so we dont get particle stacking
    particleSet[index++] = 
      new Particle(x_, y_, z_, swarmId, swarms.get(swarmId))
      .setPos(
        x_ + (rand.nextFloat() * 2 - 1),
        y_ + (rand.nextFloat() * 2 - 1),
        z_ + (rand.nextFloat() * 2 - 1)
        );
  }
  
  private void update() {
    // variables we'll be assigned each iteration of the loop
    float sq_dist, x_diff, y_diff, z_diff, distance;    
    Particle particle, neighbour;
    
    for (int i = 0; i < index; i++) {
      particle = particleSet[i];
      for (int j = 0; j < index; j++) {
        // check we're not trying to calculate stuff against ourself
        if (i != j) {
          neighbour = particleSet[j];
          x_diff = neighbour.x - particle.x;
          y_diff = neighbour.y - particle.y;
          z_diff = neighbour.z - particle.z;
          
          distance = sqrt(sq(x_diff) + sq(y_diff) + sq(z_diff));
          
          // we are only intrested in being attracted to particles from the same swarm as us
          if (particle.swarmId == neighbour.swarmId) {
            // -- gravity rule --
            // if particle is too far from its neighbour, move closer
            if (distance < gravity_threshold)
            {
              sq_dist = sq(distance);
              particle.vx += ((x_diff) / sq_dist) * 10;
              particle.vy += ((y_diff) / sq_dist) * 10;
              particle.vz += ((z_diff) / sq_dist) * 10;
            }
          }
          
          // -- seperation rule -- 
          // if particle is too close to its neighbour, move away
          // tweak on original boids rule
          if (separation / distance > 1)
          {
            particle.vx = particle.vx - x_diff * 0.4;
            particle.vy = particle.vy - y_diff * 0.4;
            particle.vz = particle.vz - z_diff * 0.4;
          }
        }
      }
      
      // -- inertia rule --
      // keep particles moving
      particle.vx = inertia * particle.vx;
      particle.vy = inertia * particle.vy;
      particle.vz = inertia * particle.vz;
      
      // -- constraint rule --
      // keep particles within 40 pixels of screen edge 
      // multiply by < 1 for less "bouncy" movement
      if (particle.x < 40)
        particle.vx += 40 - particle.x;
      if (particle.x > maxX)
        particle.vx -= particle.x - maxX;
  
      if (particle.y < 40)
        particle.vy += 40 - particle.y;
      if (particle.y > maxY)
        particle.vy -= particle.y - maxY;
        
      if (particle.z < 40)
        particle.vz += 40 - particle.z;
      if (particle.z > maxZ)
        particle.vz -= particle.z - maxZ;
        
      velocity_clamp(particle);
  
      // update particle position by adding new vectors
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.z += particle.vz;
      
      particle.draw();
    }
  }

  private void velocity_clamp(Particle particle) {
    // limit velocity to keep stable movement
    particle.vel = sqrt(sq(particle.vx) + sq(particle.vy) + sq(particle.vz));
    if (particle.vel > max_velocity)
    {
      particle.vx = (max_velocity / particle.vel) * particle.vx;
      particle.vy = (max_velocity / particle.vel) * particle.vy;
      particle.vz = (max_velocity / particle.vel) * particle.vz;
    }
  }
  
  public void printUsage() {
     System.out.println(index + " @ " + frameRate);
  }
}

