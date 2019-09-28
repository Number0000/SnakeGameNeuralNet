class Food{
  PVector pos;  //position of food
  
  //---------------------------------
  //constructor
  Food(){
    pos = new PVector();
    
    //set positoon to a random spot
    pos.x = random_placement();
    pos.y = random_placement();
  }
  
  //random placement for the food
  int random_placement(){
    return (round(random(0, 47) + 1) * 8);
  }
  
  //-------------------------------------
  //show the food as white square
  void show(){
    fill(255, 255, 255);
    stroke(0);
    rect(pos.x, pos.y, 8, 8);
  }
  
  //--------------------------------------
  //return a clone of this food
  Food clone(){
    Food clone = new Food();
    clone.pos = new PVector(pos.x, pos.y);
    
    return clone;
  }
}
