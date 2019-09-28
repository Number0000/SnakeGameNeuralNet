class NeuralNet{
  int iNodes;  //number of input nodes
  int hNodes;  //number of hidden nodes
  int oNodes;  //number of output nodes
  
  Matrix whi;  //matrix containing weights between the input nods and the hidden nodes
  Matrix whh;  //matrix containing weights between the hidden nodes and second layer hidden nodes
  Matrix woh;  //matrix containing weights between the second hidden layer nodes and the output nodes
  
  //constructor
  NeuralNet(int inputNumber, int hiddenNumber, int outputNumber){
    //set dimension from parameters
    iNodes = inputNumber;
    hNodes = hiddenNumber;
    oNodes = outputNumber;
    
    //create first layer
    //include bias weight
    whi = new Matrix(hNodes, iNodes + 1);
    
    //create second layer
    //include bias weight
    whh = new Matrix(hNodes, hNodes + 1);
    
    //create output layer
    //include bias weight
    woh = new Matrix(oNodes, hNodes + 1);
    
    //set the matrices to random values
    whi.randomize();
    whh.randomize();
    woh.randomize();
  }
  
  //-------------------------------------------
  //mutation function for genetic algorithm
  void mutate(float m){
    whi.mutate(m);
    whh.mutate(m);
    woh.mutate(m);
  }
  
  //--------------------------------------------
  //calculate the output values by feeding forward through the neural network
  float[] output(float[] inputsArr){
    // input bias
    // Inputs ->  hiddenInputs 
    
    //convert array to matrix
    //Note woh has nothing to do with it
    //it's just a function in the Matrix class
    Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);
    
    //add bias
    Matrix inputBias = inputs.addBias();
    
    //----calculate the guessed output---------------
    //apply layer one weights to the inputs
    Matrix hiddenInputs = whi.dot(inputBias);
    
    //pass through activation function(sigmoid)
    Matrix hiddenOutputs = hiddenInputs.activate();
    
    //add bias to layer three
    Matrix hiddenOutputBias = hiddenOutputs.addBias();
    
    //apply layer two weights
    Matrix hiddenInput2 = whh.dot(hiddenOutputBias);
    Matrix hiddenOutput2 = hiddenInput2.activate();
    Matrix hiddenOutputBias2 = hiddenOutput2.addBias();
    
    //apply layer three weight
    Matrix outputInputs = woh.dot(hiddenOutputBias2);
    
    //pass through activation function(sigmoi)
    Matrix outputs = outputInputs.activate();
    
    //convert to an array and return
    return outputs.toArray();
  }
  
  //-----------------------------------------
  //crossover function for genetic algorithm
  NeuralNet clone(){
    NeuralNet clone = new NeuralNet(iNodes, hNodes, oNodes);
    clone.whi = whi.clone();
    clone.whh = whh.clone();
    clone.woh = woh.clone();
    
    return clone;
  }
  
  //-----------------------------------------
  //converts the weights matrices to a single table
  // used for strogin the AI in a file
  Table NetToTable(){
    //create table
    Table table = new Table();
    
    //convert the matrices to an array
    float[] whiArr = whi.toArray();
    float[] whhArr = whh.toArray();
    float[] wohArr = woh.toArray();
    
    //set the amount of columns in the table
    for (int i = 0; i < max(whiArr.length, whhArr.length, wohArr.length); i++){
      table.addColumn();
    }
    
    //set the first row as whi
    TableRow tableRow = table.addRow();
    
    for (int i = 0; i < whiArr.length; i++){
      tableRow.setFloat(i, whiArr[i]);
    }
    
    //set the second row as whh
    tableRow = table.addRow();
    
    for (int i = 0; i < whhArr.length; i++){
      tableRow.setFloat(i, whhArr[i]);
    }
    
    //set the third row as woh
    tableRow = table.addRow();
    
    for (int i = 0; i < wohArr.length; i++){
      tableRow.setFloat(i, wohArr[i]);
    }
    
    //return table
    return table;
  }
  
  //-----------------------------------------------
  //takes in table as parameter and overwrites the matrices data for this neural network
  //used to load data from file
  void TableToNet(Table table){
    //create array to temporarily store the data for each matrix
    float[] whiArr = new float[whi.rows * whi.cols];
    float[] whhArr = new float[whh.rows * whh.cols];
    float[] wohArr = new float[woh.rows * woh.cols];
    
    //set the whi array as the first row of the table
    TableRow tableRow = table.getRow(0);
    
    for (int i = 0; i < whiArr.length; i++){
      whiArr[i] = tableRow.getFloat(i);
    }
    
    //set the whh array as the second row of the table 
    tableRow = table.getRow(1);
    
    for (int i = 0; i < whhArr.length; i++){
      whhArr[i] = tableRow.getFloat(i);
    }
    
    //set the third row as woh
    tableRow = table.getRow(2);
    
    for (int i = 0; i < wohArr.length; i++){
      wohArr[i] = tableRow.getFloat(i);
    }
    
    //convert the arrays to matrices and set them as the layer matrices
    whi.fromArray(whiArr);
    whh.fromArray(whhArr);
    woh.fromArray(wohArr);
  }
}
