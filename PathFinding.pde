int w;
int h;
int widthSpace;
int heightSpace;
Node[][] allnodes = new Node[30][16];
Node current;
Node start;
Node target;
void setup()
{
  size(1500,800);
  background(255);
  widthSpace = 50 ;
  heightSpace = 50;
  w = displayWidth;
  h = displayHeight;
  
  current = start;
   
   for(int col = 0; col< 30; col++)
   {
      for(int row = 0; row < 16; row++)
      {
        Node newNode = new Node(col,row);
        allnodes[col][row] = newNode;
      } 
   }

   start = allnodes[10][5]; // col raw 
   target = allnodes[24][12];
    
   allnodes[3][15].isTarget = true;

    for(int col = 0; col< 30; col++)
   {
      for(int row = 0; row < 16; row++)
      {
         if(col == 0 || col == 29 || row == 0 || row == 15)
         {
           allnodes[col][row].isExplored = true;
         }
      } 
   }


}


void draw()
{
  
  
 background(255);
 noFill();
 for(int i=0; i< width; i+=widthSpace){
   line(i,0,i,height);
 }
 for(int w=0; w< height; w+=heightSpace){
   line(0,w,width,w);
 } 
 // col, row, mode 0 is red, 1 is green , 2 is blue , 3 is black
  

    for(int col = 0; col< 30; col++)
   {
      for(int row = 0; row < 16; row++)
      {
         if(allnodes[col][row].isExplored)
         {
             drawMark(col,row,3);
         }
      } 
   }
   
   drawMark(target.row,target.col,0);
   drawMark(start.row,start.col,0);
   writeText(64,50,14,start.row,start.col);
  
 
}














int[] CalculateCost(Node parent_node,Node this_node)
{
 
   int[] costs = new int[2];// int[0] is G_cost , int[1] is H_cost;
   int G_cost;
   int H_cost;
   
   
   if((parent_node.row != this_node.row)&&(parent_node.col != this_node.col))
   {
     // diagonal 
     G_cost = parent_node.G_cost + 14;
   }
   else
   {
     G_cost = parent_node.G_cost + 10;
   }
   
   H_cost = (Math.max(this_node.row, this_node.col) - Math.min(this_node.row, this_node.col)) * 10 + Math.min(this_node.row, this_node.col) * 14;
   costs[0] = G_cost;
   costs[1] = H_cost;
   return costs;
}









void UpdateCost(Node this_node) // only appicable to explored nodes
{
  ArrayList<Node> neighbors = new ArrayList<Node>();
  
  neighbors = FindNeighbor(this_node,"UpdateCost");
  int min_F_cost = neighbors.get(0).G_cost + neighbors.get(0).H_cost;
  int min_H_cost = neighbors.get(0).H_cost;
  
  
  Node min_node = this_node.parent;
  for(Node node : neighbors) // find the explored neighbor that has the minimum cost
  {
    if(node.isExplored)
    {
      if((node.G_cost + node.H_cost < min_F_cost)&&(node.H_cost < min_H_cost))
      {
        min_F_cost = node.G_cost + node.H_cost; 
        min_H_cost = node.H_cost;
        min_node = node;
      }
    }
  }
  
  this_node.G_cost = CalculateCost(min_node,this_node)[0];
  this_node.H_cost = CalculateCost(min_node,this_node)[1];
  this_node.parent = min_node;
}



class Node
{
  int row;
  int col;
  int G_cost; 
  int H_cost; 
  
  
  boolean isTarget = false;
  boolean isExplored = false;
  
  Node parent; 
  
  
   Node(int row_number, int col_number) { 
   row = row_number;
   col = col_number;
  } 
}





void drawMark(int col, int row ,int colorCode)
{
 
  switch(colorCode)
  {
  case 0 : fill(255,0,0);
  break;
  
  case 1 : fill(0,255,0);
  break;
  
  case 2 : fill(0,0,255);
  break;
  
  case 3 : fill(125);
  break;
  
  }
  
  rect(col * widthSpace,row * heightSpace,50,50);
}
 
void writeText(int F_cost, int G_cost, int H_cost, int col, int row )
{
  
 
fill(255,255,0);
textSize(32);
text(F_cost, (col + 0.1 ) * widthSpace , (row + 0.9) * heightSpace); 
  
 
fill(255,255,0);
textSize(15);
text(G_cost, (col) * widthSpace , (row + 0.3) * heightSpace); 
 

 
fill(255,255,0);
textSize(15);
text(H_cost, (col + 0.65) * widthSpace , (row + 0.3) * heightSpace); 
 

}

 











ArrayList<Node> FindNeighbor(Node node,String Mode)
{
  ArrayList<Node> result = new ArrayList<Node>();
  ArrayList<Node> universe = new ArrayList<Node>();
   
   
  int row = node.row;
  int col = node.col; 
  
  universe.add(allnodes[row - 1][col - 1]);
  universe.add(allnodes[row - 1][col]);
  universe.add(allnodes[row - 1][col + 1]);
  
  universe.add(allnodes[row][col - 1]);
  universe.add(allnodes[row][col + 1]);
  
  universe.add(allnodes[row + 1][col - 1]);
  universe.add(allnodes[row + 1][col]);
  universe.add(allnodes[row + 1][col + 1]);
   
  if(!allnodes[row - 1][col - 1].isExplored) 
  {
  result.add(allnodes[row - 1][col - 1]);
  } 
  
  if(!allnodes[row - 1][col].isExplored) 
  {
  result.add(allnodes[row - 1][col]);
  } 
  
  if(!allnodes[row - 1][col + 1].isExplored) 
  {
  result.add(allnodes[row - 1][col + 1]);
  } 
  
  if(!allnodes[row][col - 1].isExplored) 
  {
  result.add(allnodes[row][col - 1]);
  } 
  
  if(!allnodes[row][col + 1].isExplored) 
  {
  result.add(allnodes[row][col + 1]);
  } 
  
  if(!allnodes[row + 1][col - 1].isExplored) 
  {
  result.add(allnodes[row + 1][col - 1]);
  } 
  
  if(!allnodes[row + 1][col].isExplored) 
  {
  result.add(allnodes[row + 1][col]);
  } 
   
  if(!allnodes[row + 1][col + 1].isExplored) 
  {
  result.add(allnodes[row + 1][col + 1]);
  }   
  
  
  
  if(Mode == "FindNeighbour")
  {
    return result;
  }
  else
  {
    for(Node tempnode: result)
    {
      universe.remove(tempnode);
    }
    return result;
  }
   
}