int angle = 0;
int snakesize = 5;
int time = 0;
int[] headx = new int[2500];
int[] heady = new int[2500];
int heading = 0;  //direction for the snake going, for right: 0, up: 1, left: 2, down: 3
int foodx = random_placement();
int foody = random_placement();
boolean redo = true;
boolean stopgame = false; //Neccessary variable to plot the game characters and boundaries
boolean alive = true;
boolean autopilot = false;
RandomDirection steering = new RandomDirection(angle, heady);

void setup(){
  restart();
  textAlign(CENTER);
  size(400, 400); // size of windows
}

void draw(){
  if(stopgame){}
  else {  // continue game
    time += 1;
    fill(255, 255, 255);
    stroke(0);
    rect(foodx, foody, 8, 8);
    fill(0, 0, 0);
    stroke(0);
    rect(0, 0, width, 8);
    rect(0, height - 8, width, 8);
    rect(0, 0, 8, height);
    rect(width-8, 0, 8, height);

    if((time%5) == 0){
      travel();
      display();
      checkdead();
      if(autopilot == true && ((time%10) == 0)){
        angle = steering.update();
      }
    }
  }
}

void keyPressed(){
  if(key == CODED){
    if(autopilot == false){
      if(keyCode == UP && angle != 270 && (heady[1] - 8 != heady[2])){
        angle = 90;
      }
      if(keyCode == DOWN && angle != 90 && (heady[1] + 8 != heady[2])){
        angle = 270;
      }
      if(keyCode == LEFT && angle != 0 && (headx[1] - 8 != heady[2])){
        angle = 180;
      }
      if(keyCode == RIGHT && angle != 180 && (headx[1] + 8 != heady[2])){
        angle = 0;
      }
    }
    if(keyCode == SHIFT) restart(); //Restart if shift is pressed
  }
  if(key == 'Z' || key == 'z') paused(); //paused if z is pressed
  if(key == 'A' || key == 'a') autopilot_switch();
}

void restart(){
  background(255);
  headx[1] = 200;
  heady[1] = 200;
  for(int i = 2; i < 1000; i++){
    headx[i] = 0;
    heady[i] = 0;
  }
  stopgame = false;
  foodx = random_placement();
  foody = random_placement();
  snakesize = 5;
  time = 0;
  angle = 0;
  redo = true;
  alive = true;
  heading = 0;
  autopilot = false;
}

void paused(){
  if(alive == true){
    if(stopgame == true){
      stopgame = false;
      println("game unpaused " + stopgame);
    } else if(stopgame == false){
      stopgame = true;
      println("game paused " + stopgame + " " + str(snakesize-1));
    }
  }
}

void autopilot_switch(){
  if(alive == true){
    if(autopilot == true){
      autopilot = false;
      println("autopilot off " + autopilot);
    } else if(autopilot == false){
      autopilot = true;
      println("autopilot on " + autopilot + " " + str(snakesize-1) + angle);
    }
  }
}

int random_placement(){
  return (round(random(0, 47) + 1) * 8);
}

void travel() {
  if (alive == true){
    for(int i = snakesize; i > 0; i--){
      if( i != 1){
        headx[i] = headx[i-1];
        heady[i] = heady[i-1];
      }
      else {
        switch(angle){
          case 0:
            headx[1] += 8;
            heading = 0;
            break;
          case 90:
            heady[1] -= 8;
            heading = 1;
            break;
          case 180:
            headx[1] -= 8;
            heading = 2;
            break;
          case 270:
            heady[1] += 8;
            heading = 3;
            break;
        }
      }
    }
  }
}

void display(){
  if(headx[1] == foodx && heady[1] == foody){
    snakesize+= 1;
    redo = true;
    while(redo){
      foodx = random_placement();
      foody = random_placement();
      for(int i = 1; i < snakesize; i++){
        if(foodx == headx[i] && foody == heady[i]){
          redo = true;
        } 
        else {
          redo = false;
          break;
        }
      }
    }
  }
  stroke(255, 255, 255);
  fill(0);
  rect(headx[1], heady[1], 8, 8);
  fill(255);
  rect(headx[snakesize], heady[snakesize], 8, 8);
}

void checkdead(){
  for(int i = 2; i < snakesize; i++){
    if(headx[1] == headx[i] && heady[1] == heady[i]){
      reportScore();
      stopgame = true;
      alive = false;
    }
    if(headx[1] >= (width-8) || heady[1] >= (height-8) || headx[1] <= 0 || heady[1] <= 0){
      reportScore();
      stopgame = true;
      alive = false;
    }
  }
}

void reportScore(){
  fill(0);
  text("GAME OVER", 200, 30);
  text("Score:  " + str(snakesize-1), 200, 55);
  text("Press SHIFT to RESTART", 200, 80);
  text("Press Z to PAUSE", 200, 105);
  text("Press A to enable autopilot", 200, 130);
}
