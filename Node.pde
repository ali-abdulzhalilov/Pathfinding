class Node {
  int x, y;
  int gCost;
  int hCost;
  int myCost;
  Node parent;
  boolean walkable;
  
  Node (int x, int y) {
    this.x = x;
    this.y = y;
    this.myCost = (int)random(INFINITY);
    this.walkable = random(2) > 0.5;
  }
  
  public int fCost() {
    return gCost + hCost + myCost;
  }
}