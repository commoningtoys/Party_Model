# The Party Model

This is an experimental model I developed during the christmas break. It is still a beta version, and I need to add a lot of features.
The model is based on the following rules:

 > 0. AGENTS GO TO A PARTY
 > 1. WHEN THIRSTINESS REACHES 0 THE AGENT GOES TO THE BAR TO REFILL HIS DRINK.
 > 2. ON THE WAY BACK IT STOPS TO THE CLOSEST AGENT WITH HIGHER COMPATIBILITY. THEREFORE IF THE AGENT HAS TO CHOOSE BETWEEN AN AGENT WITH COMPATIBILITY 10 AT DISTANCE 10 AND ANOTHER ONE WITH COMPATIBILITY 50 AT DISTANCE 20 WILL GO TO THE SECOND ONE.
 >
 > COMPATIBILITY: LETS SAY WE HAVE PEOPLE FROM 10 NEIGHBOURHOODS THE PEOPLE FROM
 > THE SAME HOOD ARE 100% COMPATIBLE AND IT DECREASES ACCORDING TO THE DISTANCE
 > FROM THAT NEIGHBOURHOOD, THIS INFLUENCES HOW MUCH TIME THEY SPEND TALKING TO EACH OTHER
 > TO ADD: 
 > * BEHAVIOUR OF THE AGENTS WHEN THERE IS A CONCERT GOING ON. AGENTS WILL SPEND A LOT OF TIME IN THE CONCERT HALL.
 > * BEHAVIOUR OF THE AGENTS WHEN WALLS ARE ADDED IN THE SYSTEM. AGENTS ATTRACTED TO WALLS BECAUSE THEY CAN LEAN AGAINST IT.

The agent behaviour is based on the work of [Daniel Shiffman](http://natureofcode.com/book/chapter-6-autonomous-agents/), regarding the function of 
```java
PVector seek()
PVector separate (ArrayList<Agent> Agents)
```
The following is the main function that allows the agent to look for his friends, but needs to be revidsed.
```java
void searchClosestFriend(ArrayList <Agent> Agents, Agent a) {
    if (Agents.size() > 1) {//with this we avoid that a single agents serches himself 
      float dMin = 99999999.0;
      for (int i = 0; i < Agents.size(); i++) {
        float d = PVector.dist(a.pos, Agents.get(i).pos);// / (a.hood / (Agents.get(i).hood));//check this function for accuracy
        float resultHood = Agents.get(i).hood / a.hood;
        //if(1 > resultHood && 0.99 < resultHood)a.friend = i;
        if (d < dMin && (1 > resultHood && 0.99 < resultHood)) {
          dMin = d;
          a.friend = i;//we find the index of the nearest agent we are more familiar with
        }
      }
    } else return;
  }
  ```
