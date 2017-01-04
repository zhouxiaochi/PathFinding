int w;
int h;
int widthSpace;
int heightSpace;

Node[][] allnodes = new Node[30][16];

ArrayList<Node> ExploredNode = new ArrayList<Node>();
ArrayList<Node> ChosenNode = new ArrayList<Node>();

Node current;
Node start;
Node target;

boolean proceed;



boolean targetFound;

void setup()
{
  size(1500,800);
  background(255);
  widthSpace = 50 ;
  heightSpace = 50; 
  w = displayWidth;
  h = displayHeight;
  
  
   
   for(int col = 0; col< 30; col++)
   {
      for(int row = 0; row < 16; row++)
      {
        Node newNode = new Node(col,row);
        allnodes[col][row] = newNode;
      } 
   }

   start = allnodes[5][5]; // col raw 
   
   
   
   
   
   target = allnodes[15][11];
    
   target.isTarget = true;

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

    current = start;
    
    for(int i = 5; i < 15 ; i ++)
{
   allnodes[12][i].isExplored = true;
}   


for(int j = 0; j < 15 ; j++)
{
   allnodes[12+j][10].isExplored = true;
}


for(int j = 0; j < 15 ; j++)
{
   allnodes[12+j][12].isExplored = true;
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
  


if(!targetFound)
{


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
 
 
   
  ArrayList<Node> Neighbor = FindNeighbor(current,"FindNeighbour");
 
  for(Node node: Neighbor)
  {
    
    
    
      int G_cost;
      int H_cost;
      int F_cost;
    
   
    G_cost =  CalculateCost(current,node)[0];
    H_cost =  CalculateCost(current,node)[1];
     
    F_cost = G_cost + H_cost;
    
    node.G_cost = G_cost;
    node.H_cost = H_cost;
 
    ExploredNode.add(node);
     
  } 
  
    for(Node chosennode : ChosenNode)
   {
     drawMark(chosennode.row,chosennode.col,2);
     writeText(chosennode);
     ExploredNode.remove(chosennode);
   }
   
   
   Node Min_node = ExploredNode.get(0);
   
    
   int Min_F_Cost = ExploredNode.get(0).G_cost + ExploredNode.get(0).H_cost;
   int Min_H_Cost = ExploredNode.get(0).H_cost;
   
   
   
   for(Node explorednode : ExploredNode)
   {    

     drawMark(explorednode.row,explorednode.col,1);
     writeText(explorednode);
     
     
     if(Min_F_Cost >= (explorednode.G_cost + explorednode.H_cost) && (explorednode.H_cost < Min_H_Cost) )
     {
       Min_F_Cost = explorednode.G_cost + explorednode.H_cost;
       Min_H_Cost = explorednode.H_cost;
       Min_node = explorednode;
       Min_node.G_cost = Min_node.G_cost;
       Min_node.H_cost = Min_node.H_cost;
       
     }
     
   }
   
 

   

    
   current = Min_node;
   ChosenNode.add(current);
   current.isExplored = true;
   ExploredNode.remove(current);

   drawMark(current.row,current.col,0);
    
   if(current.isTarget)
   {
      targetFound = true;
      println("Target found");
   }
 
}
  
 else
 {
     for(Node chosennode : ChosenNode)
   {
     drawMark(chosennode.row,chosennode.col,2);
     writeText(chosennode);
 
   }
    
   for(Node explorednode : ExploredNode)
   {    

      drawMark(explorednode.row,explorednode.col,1);
      writeText(explorednode);
 
     
   }
 
 


  
   
 
  ArrayList<Node> path = new ArrayList<Node>();
  path.add(current);
    
  while(current!=start)
  {
    ArrayList<Node> neighbors = new ArrayList<Node>();
    neighbors = FindNeighbor(current,"TraceBack");
    Node min_node = neighbors.get(0);
    int Min_cost = min_node.G_cost + min_node.H_cost ;
    
    for(Node TheNode:neighbors)
    {
        
     if(((TheNode.G_cost + TheNode.H_cost) < Min_cost ) && (TheNode.G_cost>0))
     { 
       Min_cost = (TheNode.G_cost + TheNode.H_cost);
       min_node = TheNode;
     }
    }
    
    println(min_node);
    path.add(min_node);
    current = min_node;
 
  }
  

  for(Node point : path)
 {
   drawMark(point.row,point.col,0);
 }
  

 
 }
  
  
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
   
    
   
   int delta_row = Math.abs(this_node.row - target.row);
   int delta_col = Math.abs(this_node.col - target.col);
   
   H_cost = (Math.max(delta_row,delta_col) - Math.min(delta_row, delta_col)) * 10 + Math.min(delta_col, delta_row) * 14;
   
   
   costs[0] = G_cost;
   costs[1] = H_cost;
   return costs;
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

 
void writeText(Node node )
{
  
 
fill(255,255,0);
textSize(28);
text(node.G_cost + node.H_cost, (node.row + 0.1 ) * widthSpace , (node.col + 0.9) * heightSpace); 
  
 
fill(255,255,0);
textSize(12);
text(node.G_cost, (node.row) * widthSpace , (node.col + 0.3) * heightSpace); 
 

 
fill(255,255,0);
textSize(12);
text(node.H_cost, (node.row + 0.65) * widthSpace , (node.col + 0.3) * heightSpace); 
  
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
    
    for(Node this_node : result)
    {
       this_node.parent = node;
    }
    return result;
  }
  else
  {
    for(Node tempnode: result)
 
      for(Node this_node : result)
    {
      universe.remove(tempnode);
      this_node.parent = node;
    }
    
 
    
    return result;
  }
 

 
 
 
  
   
}