class Map {
  ArrayList<Node> mapNodes;
  private PVector size;
  private float nodeSize;
  
  Map(int sizeX, int sizeY, float nodeSize) {
    mapNodes = new ArrayList<Node>();
    size = new PVector(sizeX, sizeY);
    this.nodeSize = nodeSize;
    
    for (int i = 0; i < size.x; i++)
      for (int j = 0; j < size.y; j++) {
        Node newNode = new Node(i, j);
        mapNodes.add(newNode);
      }
  }
  
  ArrayList<Node> find_path(Node start, Node goal) {
    if (!start.walkable || !goal.walkable) {
      println("Error: start and/or goal is not walkable");
      return null;
    }
    
    ArrayList<Node> openSet = new ArrayList<Node>();
    ArrayList<Node> closedSet = new ArrayList<Node>();
    openSet.add(start);
    
    while(openSet.size() > 0) {
      Node node = openSet.get(0);
      
      for (int i = 1; i < openSet.size(); i++) {
        Node tmpNode = openSet.get(i);
        if (tmpNode.fCost() < node.fCost() || tmpNode.fCost() == node.fCost()) {
          if (tmpNode.hCost < node.hCost)
            node = tmpNode;
        }
      }
      
      openSet.remove(node);
      closedSet.add(node);
      
      if (node == goal)
        return retrace_path(start, goal);
        
      ArrayList<Node> neighbours = get_neighbours(node);
      for (int i = 0; i < neighbours.size(); i++) {
        Node neighbour = neighbours.get(i);
        if (!neighbour.walkable || closedSet.contains(neighbour))
        //if (closedSet.contains(neighbour))
          continue;
        
        int new_cost_to_neighbour = node.gCost + get_node_distance(node, neighbour);
        if (new_cost_to_neighbour < neighbour.gCost || !openSet.contains(neighbour)) {
          neighbour.gCost = new_cost_to_neighbour;
          neighbour.hCost = get_node_distance(neighbour, goal);
          neighbour.parent = node;
          
          if (!openSet.contains(neighbour))
            openSet.add(neighbour);
        }
      }
    }
    
    println("Error: can't find path");
    return null;
  }
  
  int get_node_distance(Node nodeA, Node nodeB) {
    int dstX = abs(nodeA.x - nodeB.x);
    int dstY = abs(nodeA.y - nodeB.y);

    if (dstX > dstY)
      return 14*dstY + 10* (dstX-dstY);
    return 14*dstX + 10 * (dstY-dstX);
  }
  
  ArrayList<Node> retrace_path(Node start, Node end) {
    ArrayList<Node> path = new ArrayList<Node>();
    Node current = end;
    
    while (current != start) {
      path.add(current);
      current = current.parent;
    }
    
    for (int i = 0; i < path.size() / 2; i++)
    {
       Node tmp = path.get(i);
       path.set(i, path.get(path.size()-i-1));
       path.set(path.size()-i-1, tmp);
    }
    //path.reverse(); // make so magic in here
    
    return path;
  }
  
  ArrayList<Node> get_neighbours(Node node) {
    ArrayList<Node> neighbours = new ArrayList<Node>();
    PVector[] dirs = new PVector[] {
      new PVector(-1, 0), //left
      new PVector(1, 0), //right
      new PVector(0, -1), //up
      new PVector(0, 1), //down
      
      new PVector(-1, -1), // up left
      new PVector(1, 1), // down right
      new PVector(1, -1), //up right
      new PVector(-1, 1), //down left
    };
    
    if (node != null) {
      for (int i = 0; i < mapNodes.size(); i++) {
        Node someNode = mapNodes.get(i);
        
        for (int j = 0; j < dirs.length; j++) {
          if (someNode.x == node.x + dirs[j].x && someNode.y == node.y + dirs[j].y)
            neighbours.add(someNode);
        }
      }
    }
    
    return neighbours;
  }
  
  Node closest_node(PVector somePos) {
    Node minNode = mapNodes.get(0);
    float minDist = dist(somePos.x, somePos.y, minNode.x*nodeSize, minNode.y*nodeSize);
    
    for (int i = 1; i < mapNodes.size(); i++) {
      Node someNode = mapNodes.get(i);
      float someDist = dist(somePos.x, somePos.y, someNode.x*nodeSize, someNode.y*nodeSize);
      if (minDist > someDist) {
        minNode = someNode;
        minDist = someDist;
      }
    }
    
    return minNode;
  }
  
  void display() {
    noStroke();
    
    for (int i = 0; i < mapNodes.size(); i++) {
      Node node = mapNodes.get(i);
      if (!node.walkable) {
        fill(255, 0, 0);
        ellipse(node.x*nodeSize, node.y*nodeSize, 8, 8);
      }
      else {
        textAlign(CENTER, CENTER);
        textSize(7);
        
        fill(0, 255, 0);
        text(node.myCost, node.x*nodeSize, node.y*nodeSize);
      }
    }
  }
  
  void draw_nodelist(ArrayList<Node> someList, color c, float nodeDrawRadius) {
    stroke(c);
    noFill();
    
    for (int i = 0; i < someList.size(); i++) {
      Node node = someList.get(i);
      ellipse(node.x*nodeSize, node.y*nodeSize, nodeDrawRadius, nodeDrawRadius);
    }
  }
}