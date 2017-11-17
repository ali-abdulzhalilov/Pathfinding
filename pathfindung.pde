final int INFINITY = 100;

Map m;
PVector start, goal;

void setup() {
  size(640, 480);
  noLoop();
  
  float dis = 20f;
  m = new Map(int(width/dis), int(height/dis), dis);
}

void keyPressed() {
  redraw();
}

void draw() {
  background(0);
  
  m.display();
  
  start = new PVector(random(width), random(height));
  goal = new PVector(random(width), random(height));
  
  stroke(255, 0, 0); noFill();
  ellipse(start.x, start.y, 14, 14);
  stroke(0, 0, 255); noFill();
  ellipse(goal.x, goal.y, 14, 14);
  
  Node startNode = m.closest_node(start);
  Node goalNode = m.closest_node(goal);
  
  ArrayList<Node> path = m.find_path(startNode, goalNode);
  if (path != null) {
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(14);
    for (int i = 0; i < path.size(); i++) {
      text(i, path.get(i).x*m.nodeSize, path.get(i).y*m.nodeSize);
    }
  }
}