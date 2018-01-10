class Agent {
  PVector pos, target, vel, acc;
  float r = 10, speed = 3.5, force = 0.3;
  /**
   * TO ADD: Male and Female(maybe later)
   * hood - defines which neighbourhood the agent comes from
   * hoodsNum - the number of different hoods
   * t-is the thirstiness of the agent
   */
  int hood;
  int hoodsNum = 30, t, resetT, friend = 0;//the friend variable stores the index of the friend agent to look for
  float [] compatibility = new float[hoodsNum];//deprecated
  // @param {boolean} justArrived - determines if the agent is just arrived at the party
  boolean justArrived = true, lookingForFriend = true, thirsty = false;
  color c;
  /**
   * Agent constructor
   * @param {float} x - pos on the x axis
   * @param {float} y - pos on y axis
   */
  Agent(float x, float y, int thirstiness, PVector _target) {
    t = thirstiness;
    resetT = thirstiness;
    pos = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    target = _target;
    hood = floor(random(1, hoodsNum + 1));//we assign a random neighbourhood for each agent
    //colorMode(HSB);
    c = color(map(hood, 0, hoodsNum, 100, 255));
    //colorMode(RGB);
    if (random(100) < 50) {
      justArrived = true;
      lookingForFriend = true;
    } else {
      justArrived = false;
      lookingForFriend = false;
    }
    //set compatibility 
    //for (int i = 1; i <= compatibility.length; i++)compatibility[i - 1] = i / hood;
    //println(hood); 
    //println(compatibility);
  }
  /**
   * show the agent as circle with a directional nose
   */
  void show() {
    if (thirsty) stroke(255, 255, 0);
    if (lookingForFriend) stroke(0, 255, 255);
    strokeWeight(0.5);
    line(pos.x, pos.y, target.x, target.y);
    fill(c);
    noStroke();
    //stroke(0, 255, 0);
    //float theta = vel.heading();
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(theta + PI/2);
    //line(0, 0, 0, -r * 2);
    ellipse(0, 0, r, r);
    popMatrix();
  }
  /**
   * update the agent pos using vector math
   * given a target the agent tries to reach it
   *
   * when the agent reaches the bar drinks
   * and than looks around to see if there are friends nearby
   * in this case we use the function dist to check the distance
   * and we compare it with the compatibility of the agent
   */
  void update(PVector[] bars, ArrayList<Agent> Agents) {  
    edges();
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(speed);
    pos.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
    //each iteration decreses the thirstiness
    t--;
    // if the agent is just arrived serches for his friends
    if (justArrived) {    
      searchFriend(Agents, this);
      justArrived = false;
    }
    if (t < 0) {
      thirsty = true;
      lookingForFriend = false;
      //check if the agent is followed by anyone if yes
      //that agent should look for other friends nearby
      for (int i = 0; i < Agents.size(); i++) {
        int index = Agents.get(i).friend;
        if (Agents.get(index).equals(this))searchFriend(Agents, Agents.get(i)); //compare the two agent if thez are the same than the agent should loook for another friend
      }
      PVector bar = bars[floor(random(bars.length))];
      target = bar;
      t = resetT;
    }
    /*******************
     * look for friends *
     *******************/
    if (thirsty && targetReached()) {
      thirsty = false;
      lookingForFriend = true;
      searchFriend(Agents, this);
    }
    if (lookingForFriend)target = Agents.get(friend).pos;
    /**
     end of look for friends
     */
  }
  /**
   * sets the agent to be searched
   */
  void searchFriend(ArrayList <Agent> Agents, Agent a) {
    if (Agents.size() > 1) {//with this we avoid that a single agents serches himself 
      float dMin = 99999999.0;
      for (int i = 0; i < Agents.size(); i++) {
        float d = PVector.dist(a.pos, Agents.get(i).pos) * (a.hood / (Agents.get(i).hood));//check this function for accuracy
        if (d < dMin && d > r && !Agents.get(i).thirsty) {
          dMin = d;
          a.friend = i;//we find the index of the nearest agent we are more familiar with
        }
      }
    } else return;
  }
  void searchClosestFriend(ArrayList <Agent> Agents, Agent a) {
    if (Agents.size() > 1) {//with this we avoid that a single agents serches himself 
      float dMin = 99999999.0;
      for (int i = 0; i < Agents.size(); i++) {
        float d = PVector.dist(a.pos, Agents.get(i).pos) / (a.hood / (Agents.get(i).hood));//check this function for accuracy
        float resultHood = Agents.get(i).hood / a.hood;
        //if(1 > resultHood && 0.99 < resultHood)a.friend = i;
        if (d < dMin && (1 > resultHood && 0.99 < resultHood)) {
          dMin = d;
          a.friend = i;//we find the index of the nearest agent we are more familiar with
        }
      }
    } else return;
  }
  /**
   * set a new target for the agent
   * @param {PVector} p - vector element of the pos to reach
   */
  void setTarget(PVector p) {
    target = p;
  }
  //returns if the agent has reached his target
  boolean targetReached() {
    float d = PVector.dist(pos, target);
    return (d < 10);
  } 
  void edges() {    //off-screen wrap around  
    if (pos.x < 0) vel.mult(-1);
    if (pos.x > width) vel.mult(-1);
    if (pos.y < 0) vel.mult(-1);
    if (pos.y > height) vel.mult(-1);    
    //if (pos.x < 0) pos.x = width;
    //if (pos.x > width) pos.x = 0;
    //if (pos.y < 0) pos.y = height;
    //if (pos.y > height) pos.y = 0;
  }
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }
  /**
   * The functions below are from Nature of Code
   * Separation and Seek by Daniel Shiffman
   * http://natureofcode.com
   */
  void applyBehaviors(ArrayList<Agent> a) {
    PVector separateForce = separate(a);
    PVector seekForce = seek();
    separateForce.mult(2.0);
    seekForce.mult(1.5);
    applyForce(separateForce);
    applyForce(seekForce);
  }
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS vel
  PVector seek() {
    PVector desired = PVector.sub(target, pos);  // A vector pointing from the pos to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speed);
    // Steering = Desired minus vel
    PVector steer = PVector.sub(desired, vel);
    steer.limit(force);  // Limit to maximum steering force

    return steer;
  }

  // Separation
  // Method checks for nearby Agents and steers away
  PVector separate (ArrayList<Agent> Agents) {
    float desiredseparation = r * 1.2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Agent other : Agents) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(speed);
      // Implement Reynolds: Steering = Desired - vel
      sum.sub(vel);
      sum.limit(force);
    }
    return sum;
  }
}