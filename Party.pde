class Party {
  ArrayList <Agent> as;
  PVector[] bars;//meeting points
  PVector randomBar;
  //bar radius
  int r = 30, min = 50, max = 500, index = 0, PG;
  boolean goToBar = true, searchFriend = true;
  /**
   * @param {int} partyGoers - number of agent of the model
   */
  Party(int partyGoers, int numberOfBars) {
    bars = new PVector[numberOfBars];
    for (int i = 0; i < bars.length; i++) {
      int radius = 350;
      float angle = map(i, 0, bars.length, 0, TWO_PI);
      float x = width/2 + radius * cos(angle);
      float y = height/2 + radius * sin(angle);
      bars[i] = new PVector(x, y);
    }
    as = new ArrayList <Agent> ();
    PG = partyGoers;
    //for (int i = 0; i < partyGoers; i++) {
    //  //as.add(new Agent(random(width), random(height), 0, randomBar()));
    //  as.add(new Agent(random(width), random(height), floor(random(min, max)) * 10, new PVector(random(height), random(width))));
    //}
  }
  //this function displays the agents and the bars
  void show() {
    for (Agent a : as)a.show();
    noStroke();
    for (PVector bar : bars)showBar(bar.x, bar.y, r);
  }
  /**
   * @param {float} x - position on x axis
   * @param {float} y - position on y axis
   */
  void showBar(float x, float y, int rad) {
    for (int i = 0; i < rad; i += 3) {
      fill(100, i * 2);
      ellipse(x, y, rad - i, rad - i);
    }
  }
  //this function updates all the agents
  void update() {
    //lets add some agents over time
    if (frameCount % 5 == 0) {
      if (PG >= 0)as.add(new Agent(width/2, height/2, floor(random(min, max)) * 10, new PVector(random(height), random(width))));
      PG--;
    }
    //
    for (Agent a : as) {
      //a.setTarget(new PVector(random(width), random(height)));
      a.applyBehaviors(as);
      a.update(bars, as);
    }
  }

  //returns a random bar PVector
  PVector randomBar() {
    return bars[floor(random(bars.length))];
  }
}