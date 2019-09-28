class Matrix{
  // local variables
  int rows;
  int cols;
  float[][] matrix;
  
  //---------------------------------------------------
  //constructor
  Matrix(int r, int c){
    cols = c;
    rows = r;
    matrix = new float[rows][cols];
  }
  
  //---------------------------------------------------
  //constructor
  Matrix(float[][] m){
    matrix = m;
    cols = m.length;
    rows = m[0].length;
  }
  
  //----------------------------------------------------
  //print matrix
  void output() {
    for (int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        print(matrix[i][j] + " ");
      }
      println();
    }
  }
  
  //---------------------------------------
  //multiply scalar
  void multiply(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] *= n;
      }
    }
  }
  
  //---------------------------------------
  //return a matrix which is this matrix dot product parameter matrix
  Matrix dot(Matrix m){
    Matrix result = new Matrix(rows, m.cols);
    float sum = 0;
    if(cols == m.rows){
      //for each spot in the new matrix
      for(int i = 0; i < rows; i++){
        for(int j = 0; j < m.cols; j++){
          sum = 0;
          for(int k = 0; k < cols; k++){
            sum += matrix[i][k] * m.matrix[k][j];
          }
          result.matrix[i][j] = sum;
        }
      }
    }
    return result;
  }
  
  //---------------------------------------------
  //set the matrix to random ints between -1 and 1
  void randomize(){
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        matrix[i][j] = random(-1, 1);
      }
    }
  }
  
  //---------------------------------------------
  //set the matrix to random ints between -1 and 1
  void Add(float n){
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        matrix[i][j] += n;
      }
    }
  }
  
  //---------------------------------------------
  //return a matrix which is this matrix + parameter matrix
  Matrix add(Matrix m){
    Matrix newMatrix = new Matrix(rows, cols);
    if(cols == m.cols && rows == m.rows){
      for(int i = 0; i < rows; i++){
        for (int j = 0; j < cols; j++){
          newMatrix.matrix[i][j] = matrix[i][j] + m.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //return a matrix which is this matrix - paramter matrix
  Matrix subtract(Matrix m){
    Matrix newMatrix = new Matrix(rows, cols);
    if(cols == m.cols && rows == m.rows){
      for(int i = 0; i < rows; i++){
        for (int j = 0; j < cols; j++){
          newMatrix.matrix[i][j] = matrix[i][j] - m.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //set the matrix to random ints between -1 and 1
  Matrix multiply(Matrix m){
    Matrix newMatrix = new Matrix(rows, cols);
    if(cols == m.cols && rows == m.rows){
      for(int i = 0; i < rows; i++){
        for (int j = 0; j < cols; j++){
          matrix[i][j] = matrix[i][j] * m.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //return a matrix which is the transpose of this matrix
  Matrix transpose(){
    Matrix newMatrix = new Matrix(cols, rows);
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        newMatrix.matrix[i][j] = matrix[j][i];
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //create a single column from the parameter array
  Matrix singleColumnMatrixFromArray(float[] arr){
    Matrix newMatrix = new Matrix(arr.length, 1);
    for(int i = 0; i < rows; i++){
      newMatrix.matrix[i][0] = arr[i];
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //sets this matrix from an array
  void fromArray(float[] arr){
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        matrix[i][j] = arr[j + i * cols];
      }
    }
  }
  
  //---------------------------------------------
  //return an array which represents this matrix
  float[] toArray(){
    float[] arr = new float[rows* cols];
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        arr[j + i * cols] = matrix[i][j];
      }
    }
    return arr;
  }
  
  //---------------------------------------------
  //for ix1 matrixes adds one to the bottom
  Matrix addBias(){
    Matrix newMatrix = new Matrix(rows+1, 1);
    for(int i = 0; i < rows; i++){
      newMatrix.matrix[i][0] = matrix[i][0];
    }
    newMatrix.matrix[rows][0] = 1;
    return newMatrix;
  }
  
  //---------------------------------------------
  //applies the activation function(sigmoid) to each element of the matrix
  Matrix activate(){
    Matrix newMatrix = new Matrix(rows, cols);
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        newMatrix.matrix[i][j] = matrix[i][j];
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //sigmoid activation function
  float sigmoid(float x){
    float y = 1/(1 + pow((float) Math.E, -x));
    return y;
  }
  
  //return the matrix that is the derived sigmoid function of the current matrix
  Matrix sigmoidDerived(){
    Matrix newMatrix = new Matrix(rows, cols);
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        newMatrix.matrix[i][j] = (matrix[i][j] * (1 - matrix[i][j]));
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //return the matrix which is the matrix with the bottom layer removed
  Matrix removeBottomLayer(){
    Matrix newMatrix = new Matrix(rows-1, cols);
    for(int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        newMatrix.matrix[i][j] = matrix[i][j];
      }
    }
    return newMatrix;
  }
  
  //---------------------------------------------
  //Mutation function for genetic algorithm
  void mutate(float mutationRate){
    //for each element in the matrix
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        float rand = random(1);
        if(rand < mutationRate){  //if chosen to be mutated
          matrix[i][j] += randomGaussian()/5;  //add a random value to it(can be negative)
          
          //set the boundaries to 1 and -1
          if(matrix[i][j] > 1){
            matrix[i][j] = 1;
          }
          
          if(matrix[i][j] < -1){
            matrix[i][j] = -1;
          }
        }
      }
    }
  }
  
  //----------------------------------------------
  //return a matrix which has a random number of values from this matrix and the rest from the parameter matrix
  Matrix crossOver(Matrix partner){
    Matrix child = new Matrix(rows, cols);
    
    //pick a random point in the matrix
    int randCol = floor(random(cols));
    int randRow = floor(random(rows));
    
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        if((i < randRow) || (i == randRow && j <= randCol)){  //if before th random point then copy from this matrix
          child.matrix[i][j] = matrix[i][j];
        } else {  //if after the  random point then copy from the parameter array
          child.matrix[i][j] = partner.matrix[i][j];
        }
      }
    }
    return child;
  }
  
  //-----------------------------------------------
  //return a copy of this matrix
  Matrix clone(){
    Matrix clone = new Matrix(rows, cols);
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        clone.matrix[i][j] = matrix[i][j];
      }
    }
    return clone;
  }
}
