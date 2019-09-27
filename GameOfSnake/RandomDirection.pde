class RandomDirection{
  int angle_nn;
  int[] heady_nn;
  int directionTemp;
  
  RandomDirection(int angle, int[] heady){
    angle_nn = angle;
    heady_nn = heady;
  }
  
  int update(){
    angle = check_direction(angle, heady);
    switch(directionTemp){
      case 0: println(directionTemp + " : going right"); break;
      case 1: println(directionTemp + " : going up"); break;
      case 2: println(directionTemp + " : going left"); break;
      case 3: println(directionTemp + " : going down"); break;
    }
    return angle;
  }
  
  int check_direction(int angle, int[] heady){
    directionTemp = random_direction();
    if(directionTemp == 1 && angle != 270 && (heady[1] - 8 != heady[2])){
      angle = 90;
    }
    else if(directionTemp == 3 && angle != 90 && (heady[1] - 8 != heady[2])){
      angle = 270;
    }
    else if(directionTemp == 2 && angle != 0 && (heady[1] - 8 != heady[2])){
      angle = 180;
    }
    else if(directionTemp == 0 && angle != 180 && (heady[1] - 8 != heady[2])){
      angle = 0;
    }
    return angle;
  }
  
  int random_direction(){
    int temp = round(random(0, 3));
    return temp;
  }
}
