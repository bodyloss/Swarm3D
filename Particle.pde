class Particle {

  public float x, y, z, // 3D co-ordinates
  vx, vy, vz, // vector x/y
  vel; // velocity
  public byte swarmId;
  private color col; 

  Particle(int x, int y, int z, byte swarmId, color col) {
    vx = vy = vz = vel = 0;
    this.swarmId = swarmId;
    this.x  = x;
    this.y  = y;
    this.z = z;
    this.col = col;
  }

  public Particle setPos(int x_, int y_, int z_) {
    // set particle position
    x = x_;
    y = y_;
    z = z_;
    return this;
  }

  public Particle setPos(float x_, float y_, float z_) {
    // set particle position
    x = x_;
    y = y_;
    z = z_;
    return this;
  }

  public void draw()
  {
    pushMatrix();
    translate(x, y, -z);
    fill(col);
    noStroke();
    sphere(14.0);
    stroke(col);
    line(0, 0, 0, -vx, -vy, -vz); // particle tails
    popMatrix();
  }
}

