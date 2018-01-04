void loadSplash()
{
  rectMode(CORNERS);
  noStroke();
  fill(50,50,75);
  rect(0,485,1100,800);
  for(int i = 0; i < stars2.length; i++)
  {
    stars2[i] = new Star(random(0,1100), random(485,800), random(2,15));
    stars2[i].makeStar();
  }
  for(int i = 0; i < forest.length; i++)
  {
    forest[i] = new Tree(45*i+random(0,15),700,random(300,500),random(60,80));
    forest[i].makeTree();
  }
  for(int i = 0; i < stars.length; i++)
  {
    stars[i] = new Star(random(0,1100), random(0,500), random(2,15));
  }
}

void drawBasicSplash()
{
  fill(0,255,255); 
  rect(0,0,1100,800); 
  fill(100,100,100); 
  rect(0,700,1100,800); 
  fill(0,0,0); 
  textFont(titleFont, 60); 
  text(title, 450, 80); 
  textFont(bodyFont, 45); 
  text(body, 90, 100, 1025, 725); 
  fill(255,255,255); 
  textFont(bodyFont, 25);
}

void drawControlsSplash()
{
  stroke(0,255,255);
  strokeWeight(2);
  fill(50,50,75); 
  rect(0,0,1100,800);
  fill(0,255,255);
  strokeWeight(2);
  line(165, 160, 310, 160);
  line(475, 160, 600, 160);
  line(805, 160, 945, 160);
  textFont(titleFont, 60); 
  text("Controls", 420, 80);
  textFont(bodyFont, 45);   
  fill(220,220,255);
  text("Movement", 170, 150);
  text("Shooting", 480, 150);
  text("Hot Keys", 820, 150);
  text("W      =   Up", 135, 242);
  text("A      =   Left", 135, 342);
  text("S      =   Down", 135, 442);
  text("D      =   Right", 135, 542);
  text("R      =   Retry", 785, 242);
  text("SPACE     =   Next", 790, 342);
  text("Mouse  =  Aim", 400,242);
  text("Left click  =  Fire", 400,342);
  text("Right Click  =  Swap Weapon", 400,442);
  strokeWeight(3);
  noFill();
  stroke(0,255,255);
  rect(120,200, 170, 250);
  rect(120,300, 170, 350);
  rect(120,400, 170, 450);
  rect(120,500, 170, 550);
  rect(770,200, 820, 250);
  rect(770,300, 900, 350);
}

void drawMainSplash()
{
  drawSplash();
  moonAngle+=PI/360;
  if(moonAngle > 2*PI+startingAngle)
  {
    moonAngle = startingAngle;
  }
}

void drawSplash()
{
  noStroke();
  fill(50,50,75);   ////indigo
  //////////////////////////////background////////////////////
  rect(0,0,1100,200);
  rect(0,0,550,485);
  rect(800,0,1100,485);
  rect(0,450,1100,500);
    for(int i = 0; i < stars.length; i++)
  {
    stars[i].makeStar();
  }

  

  ////////////////////////////////moon///////////////////////////
  fill(220,220,255); //////light blue 
  ellipse(550,300,300,300);

  ////////////////////////////////tank//////////////////////////
  fill(0,255,0); ////green
  pushMatrix();
  translate(550,300);
  rotate(moonAngle);
  //rect(-30,-190,30,-150);
  stroke(0,0,0);
  quad(-30,-162,30,-162,25,-147,-25, -147);
  rect(0,-172,40,-168);
  quad(-21,-162,-17,-180, 19, -180, 21, -162);
  popMatrix();
  fill(227,3,200); ////magenta
  pushMatrix();
  translate(550,300);
  rotate(moonAngle-PI);
  //rect(-30,-190,30,-150);
  stroke(0,0,0);
  quad(-30,-162,30,-162,25,-147,-25, -147);
  rect(0,-172,40,-168);
  quad(-21,-162,-17,-180, 19, -180, 21, -162);
  popMatrix();
  noStroke();
  
  ///////////////////////////////shadow/////////////////////////////
  fill(50,50,75,128);  ////indigo with 50% opacity
  rect(550,150,800,450);
  rect(550,150,800,450);
  arc(550,300,200,299,PI/2,3*PI/2);
  arc(550,300,200,299,PI/2,3*PI/2);
  


////////////////////////////////ground///////////////////////////
  fill(0,0,15);
  pushMatrix();
  translate(0,-30);
  beginShape();
  vertex(0,710);
  vertex(100,700);
  vertex(150,700);
  vertex(270,705);
  vertex(330,700);
  vertex(390,697);
  vertex(455,690);
  vertex(480,685);
  vertex(560,680);
  vertex(620,690);
  vertex(680,695);
  vertex(750,698);
  vertex(810,709);
  vertex(870,715);
  vertex(930,713);
  vertex(1020,718);
  vertex(1100,720);
  vertex(1100,1000);
  vertex(0,1000);
  endShape(CLOSE); 
  popMatrix();
////////////////////////////credits////////////////////////////
  fill(220,220,255);
  textFont(bodyFont, 25);
  text("Track: Phantom Sage - Kingdom (feat. Miss Lina) [NCS Release]\nMusic provided by NoCopyrightSounds", 10, 710);
}

class Star
{
  float x;
  float y;
  float h;
  
  Star(float x, float y, float h)
  {
    this.x = x;
    this.y = y;
    this.h = h;
  }
  
  
void makeStar()
{
  noStroke();
  fill(220,220,255);
  PShape s = createShape();
  s.beginShape();
  s.vertex(0,-h);
  s.vertex(h/10,h/10);
  s.vertex(h/4,0);
  s.vertex(h/10,-h/10);
  s.vertex(0,h);
  s.vertex(-h/10,h/10);
  s.vertex(-h/4,0);
  s.vertex(-h/10,-h/10);
  endShape();
  shape(s, x, y);
}
}

  
class Tree
{
  float x;
  float y;
  float angle;
  float h;
  
  Tree(float x, float y, float angle, float h)
  {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.h = h;
  }


void makeTree() {

  strokeWeight(h/8);
  stroke(0,0,15);
  float a = (angle / (float) 1100) * 90f;
  // Convert it to radians
  pushMatrix();
  theta = radians(a);
  // Start the tree from the x,y coords
  translate(x,y);
  // Draw a line 120 pixels
  line(0,0,0,-h);
  // Move to the end of that line
  translate(0,-h);
  // Start the recursive branching!
  
  branch(h);
  popMatrix();

}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 5) 
  {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    strokeWeight(h/10);
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    strokeWeight(h/10);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
} 
}