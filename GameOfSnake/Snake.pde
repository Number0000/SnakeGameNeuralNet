class Snake{
  int len = 1;  //the length of the snake
  PVector pos;  //position of the head of the snake
  ArrayList<PVector> tailPosition;  //all the position of the tail of the snake
  PVector vel;  //which direction of the snake will move
  PVector temp;  //hold a temporary PVector for new tail
  Food food;  //the food that snake needs to eat
  NeuralNet brain;  //the neural net controlling the snake
  float[] vision = new float[24];  //the inputs of the neural net
  float[] decision; //the output of the neural net
  
  int lifetime = 0;  //how long the snake lived for
  int fitness = 0;  //the quality of this snake
  //the number of moves leftto live if this gets down to 0, the snake dies
  //this prevent the snake to circles forever
  int leftToLive = 200;
  
  int growCount;  //the amount the snake still needs to grow
  
  boolean alive = true;  //true if the snake is alive
  boolean test = false;  //true if the snake is eing tested or trained
  
  //constructor
  Snake(){
    //set initial position of the head
    int x = 200;
    int y = 200;
    
    pos = new PVector(x, y);
    vel = new PVector(10, 0);
    
    tailPosition = new ArrayList<PVector>();
    temp = new PVector((x-10), y);
    tailPosition.add(temp);
    
    temp = new PVector((x-20), y);
    tailPosition.add(temp);
    
    temp = new PVector((x-30), y);
    tailPosition.add(temp);
    
    len += 3;
    
    //initiate target food
    food = new Food();
    
    //create a neural net with 24 input neurons and 4 output neurons
    brain = new NeuralNet(24, 18, 4);
    
    //initiate the life for snake
    leftToLive = 200;
  }
  
  //-----------------------------------------------------------------
  //display the snake
  void show(){
    fill(255);
    stroke(0);
    //show the tail
    for(int i = 0; i < tailPosition.size(); i++){
      rect(tailPosition.get(i).x, tailPosition.get(i).y, 8, 8);
    }
    //show the head
    rect(pos.x, pos.y, 10, 10);
    
    //show the food
    food.show();
  }
  
  //--------------------------------------------------------------
  //mutates neural net
  void mutate(float m){
    brain.mutate(m);
  }
  
  //--------------------------------------------------------------
  //set the velocity from the output of the neural network
  void setVelocity(){
    //get the output of the neural network
    decision = brain.output(vision);
    
    //get the maximum position in the output array and use this to 
    //determine which direction is the best possibility to navigate to the target food
    float max = 0;
    int maxIndex = 0;
    for(int i = 0; i< decision.length; i++){
      if(max < decision[i]){
        max = decision[i];
        maxIndex = i;
      }
    }
    
    //set the velocity based on this decision
    if(maxIndex == 0){
      //if (vel.x!=10 and vel.y!=0) // this stop snake to going back to own body, but 
                                    //removed to teach snake to avoid their body
      vel.x = -10;
      vel.y = 0;
    } else if (maxIndex == 1){
      vel.x = 0;
      vel.y = -10;
    } else if (maxIndex == 2){
      vel.x = 10;
      vel.y = 0;
    } else {
      vel.x = 0;
      vel.y = 10;
    }
  }
  
  //-------------------------------------------------------------------
  //move the snake in direction of the vel PVector
  void moveToward(){
    //move through time
    lifetime += 1;
    leftToLive = 1;
    
    //if time left is down to 0, then snake dies
    if(leftToLive < 0){
      alive = false;
    }
    
    //if the snake hit itself or the edge, then snake dies
    if(dying(pos.x + vel.x, pos.y + vel.y)){
      alive = false;
    }
    
    //if snake head is on the same position as the food then eat it
    if(pos.x + vel.x == food.pos.x && pos.y + vel.y == food.pos.y){
      eat();
    }
    
    //snake grows 1 square at a time, so that snake has recently eaten, then grow count will be more then 0
    if(growCount >0){
      growCount--;
      grow();
    } else {  //if not growing, then move the tail positions to follow the head
      for(int i = 0; i < tailPosition.size() -1; i++){
        temp = new PVector(tailPosition.get(i+1).x, tailPosition.get(i-1).y);
        tailPosition.set(i, temp);
      }
      temp = new PVector(pos.x, pos.y);
      tailPosition.set(len-2, temp);
    }
    
    //moving snake head
    pos.add(vel);
  }
  
  //-----------------------------------------------------------------
  //the snake just ate some food
  void eat(){
    //reset food to new position
    food = new Food();
    //make sure the food isn't spawn on the snake position
    while(tailPosition.contains(food.pos)){
      food = new Food();
    }
    
    //increase time left to live
    leftToLive += 100;
    
    //....
    //if testing then grow by 4, but if not snake will only grow by 1
    //this ensure snake evolving so they don't get too big too soon
    if(test || len > 10){
      growCount += 4;
    } else {
      growCount += 1;
    }
  }
  
  //------------------------------------------------------------------
  //grows the snake by 1 square
  void grow(){
    //add the head to the tail list
    //this simulates the snake growing as the head is the only thing which moves
    temp = new PVector(pos.x, pos.y);
    tailPosition.add(temp);
    len += 1;
  }
  
  //-----------------------------------------------------------------
  //return true if the snake is going to hit itself or wall
  boolean dying(float x, float y){
    //check id hit wall
    if(x >= (width-8) || y >= (height-8) || x <= 0 || y <= 0){
      return true;
    }
    
    //check if hit tail
    return isOnTail(x, y);
  }
  
  //return true if coordinate is on snake tail
  boolean isOnTail(float x, float y){
    for(int i = 0; i < tailPosition.size(); i++){
      if(x == tailPosition.get(i).x && y == tailPosition.get(i).y){
        return true;
      }
    }
    return false;
  }
  
  //----------------------------------------------------------------------
  //calculate the fitness of the snake after it died
  void calcFitness(){
    //fitness is based on length and lifetime
    if(len < 10){
      fitness = floor(pow(2, lifetime) * pow(2, floor(len)));
    } else {
      //..
      //grow slower after 10 to stop fitness from getting really big for one time
      //ensure greater than len = 9
      fitness = floor(pow(2, lifetime) * pow(2, 10) * (len-9));
    }
  }
  
  //------------------------------------------------------------------------
  //crossover function for genetic algorithm
  Snake crossOver(Snake partner){
    Snake child = new Snake();
    
    child.brain = brain.crossOver(partner.brain);
    return child;
  }
  
  //---------------------------------------------------------------------------
  //return a clone of snake
  Snake clone(){
    Snake clone = new Snake();
    
    clone.brain = brain.clone();
    clone.alive = true;
    
    return clone;
  }
  
  //---------------------------------------------------------------------------
  //saves the snake to a file by converting it to a table
  void saveSnake(int snakeNo, int score, int populationID){
    //save the snake top score and it's population id
    Table snakeStats = new Table();
    snakeStats.addColumn("Top Score");
    snakeStats.addColumn("PopulationID");
    TableRow tableRow = snakeStats.addRow();
    tableRow.setFloat(0,score);
    tableRow.setInt(1, populationID);
    
    saveTable(snakeStats, "data/SnakeStats" + snakeNo + ".csv");
    
    //save the snake brain
    saveTable(brain.NetToTable(), "data/Snake" + snakeNo + ".csv");
  }
  
  //return the snake saved in the parameter position
  Snake loadSnake(int snakeNo){
    Snake loadSnake = new Snake();
    Table table = loadTable("data/Snake" + snakeNo + ".csv");
    loadSnake.brain.TableToNet(table);
    return loadSnake;
  }
  
  //----------------------------------------------------------------------------
  //look in 8 direction to find/detect food, wall and it's tail
  void look(){
    vision = new float[24];
        //look left
    float[] tempValues = lookInDirection(new PVector(-10, 0));
    vision[0] = tempValues[0];
    vision[1] = tempValues[1];
    vision[2] = tempValues[2];
    //look left/up  
    tempValues = lookInDirection(new PVector(-10, -10));
    vision[3] = tempValues[0];
    vision[4] = tempValues[1];
    vision[5] = tempValues[2];
    //look up
    tempValues = lookInDirection(new PVector(0, -10));
    vision[6] = tempValues[0];
    vision[7] = tempValues[1];
    vision[8] = tempValues[2];
    //look up/right
    tempValues = lookInDirection(new PVector(10, -10));
    vision[9] = tempValues[0];
    vision[10] = tempValues[1];
    vision[11] = tempValues[2];
    //look right
    tempValues = lookInDirection(new PVector(10, 0));
    vision[12] = tempValues[0];
    vision[13] = tempValues[1];
    vision[14] = tempValues[2];
    //look right/down
    tempValues = lookInDirection(new PVector(10, 10));
    vision[15] = tempValues[0];
    vision[16] = tempValues[1];
    vision[17] = tempValues[2];
    //look down
    tempValues = lookInDirection(new PVector(0, 10));
    vision[18] = tempValues[0];
    vision[19] = tempValues[1];
    vision[20] = tempValues[2];
    //look down/left
    tempValues = lookInDirection(new PVector(-10, 10));
    vision[21] = tempValues[0];
    vision[22] = tempValues[1];
    vision[23] = tempValues[2];
  }
  
  float[] lookInDirection(PVector direction){
    //set up a temp array to hold the values that are going to be passed to the main vision array
    float[] visionInDirection = new float[3];
    
    //the position where we are currently looking for food, or tail or wall
    PVector position = new PVector(pos.x, pos.y);
    //true if the food has been located in the  direction looked
    boolean foodIsFound = false;
    //true if the tail has been located in the direction looked
    boolean tailIsFound = false;
    
    float distance = 0;
    //move once in the desired direction before starting
    position.add(direction);
    distance+=1;
    
    //look in the direction until you reach a wall
    while(!(position.x >= (width-8) || position.y >= (height-8) || position.x <= 0 || position.y <= 0)){
      //check for food position
      if(!foodIsFound && position.x == food.pos.x && position.y == food.pos.y){
        visionInDirection[0] = 1;
        foodIsFound = true;  //don't check if food is already found
      }
      
      //check for tail position
      if(!tailIsFound && isOnTail(position.x, position.y)){
        visionInDirection[1] = 1/distance;
        tailIsFound = true;  //dont' check if tail is already found
      }
      
      //look further in the direction
      position.add(direction);
      distance += 1;
    }
    
    //set the distance to wall to percent
    visionInDirection[2] = 1/distance;
    
    return visionInDirection;
  } 
}
