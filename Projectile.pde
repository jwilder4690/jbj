class Projectile 
{
  color tint;
  int type;
  int speed;
  int shadow;
  int fading;
  float pX;
  float pY;
  float originX;
  float originY;
  float angle;
  boolean exploded;
  boolean verticalCollision;
  boolean held;
  int direction;
  int collisions;
  int redirects;
  int range;
  float[] coordinates = new float[7];
  float[] staticCoordinates = new float[7];
  
Projectile(float x, float y, float aim, int which, boolean friendly)
{
    pX = 0; 
    pY = -20; 
    originY = y; 
    originX = x;
    angle = aim;
    speed = 3;
    exploded = false;
    range = 170;
    direction = 1;
    switch(which)      
    {
      case 0: collisions = 0; redirects = 0; if(friendly){speed = 4;}break;                             //normal
      case 1: collisions = 3; redirects = 0; speed = 4; break;                             //ricochet
      case 2: collisions = 0; redirects = 1; break;                             //split
      case 3: collisions = 0; redirects = 2; shadow = 70; break;                //triangle
      case 4: collisions = 0; redirects = 3; shadow = 70; break;                //square
      case 5: collisions = 0; redirects = 300; break;                //circle
      case 6: collisions = 0; redirects = 3; speed = 2; break;                  //tele
    }
    type = which;
    if(friendly)
    {
      tint = color(0, 255, 255);
    }
    else
    {
      tint = color(255, 0, 255);
    }
}

float getX()
{
  return originX + (pX*cos(angle) - pY*sin(angle));
}

float getY()
{
  return originY + (pY*cos(angle) + pX*sin(angle));
}

int getType()
{
  return type;
}

boolean getExploded()
{
  return exploded;
}

int getDirection()
{
  return direction;
}

float getAngle()
{
  return angle;
}

void lockCoordinates(float[] coords)
{
  staticCoordinates = coords;
  if(type == 5)
  {
    fading = 290;
  }
  else
  {
    fading = 70;
  }
}

void setColor(int a, int b, int c)
{
  tint = color(a,b,c);
}

void setCollisionType(boolean vert)
{
  verticalCollision = vert;
}

void changeDirection(int direction, float radius)   
{
  if(redirects > 0)
  {
    originX = getX();
    originY = getY();
    pX = 0;
    pY = 0;
  
    angle = angle+(direction*PI/(radius*.523));    ////turns in a circke based on radius
    redirects--;
  }
}

int getRange()
{
  return range;
}

void redirect(int directs)
{
  redirects = directs;
  redirects--;
}

void setOrigin(float x, float y)
{
  pX = x;
  pY = y;
}

int getRedirects()
{
  return redirects;
}

float[] getAllCoordinates()
{
  return coordinates;
}

float getCoordinates(int index)
{
  return coordinates[index];
}

void bounce()
{
  if (collisions > 0)
  {
    originX = getX();
    originY = getY();
    pX = 0;
    pY = 0;
    if (verticalCollision)                  //direction of wall, so we can bounce off correctly
    {
      angle = -angle;
    }
    else
    {
      angle = PI - angle;
    }
    ////////////////////////////Constrains angle to -PI/2 to PI/2//////////////////
    if(angle > PI/2)
    {
      angle = angle - 2*PI;
    }
    else if(angle < -PI/2)
    {
      angle = angle+ 2*PI;
    }
    //////////////////////////////////////////////////////////////////////////////////
    collisions--;
    if(collisions == 0)
    {
      exploded = true;
      laserImpact.trigger();
    }
    else
    {
      bounce.trigger();
    }
    //pY = -5;      ////try to get the bullet out of the corner before checking collisions again
  }
}

void updatePosition()
{
  pY -= speed;
}

void drawProjectile()
{
      updatePosition();
      pushMatrix();
      translate(originX, originY);
      rotate(angle);
      pushMatrix();
      translate(pX, pY);
      noStroke();
      fill(tint);
      ellipse(0, 0, 4, 4);
      rect(-2,0,2,8);
      if(type == 6 && redirects > 0)
      {
        noStroke();
        fill(0,100, 255, 150);
        ellipse(0,0,2*range,2*range);
      }
      popMatrix();
      popMatrix();
      
     if(type == 3 && redirects > 0)
     {
       //coordinates = calculateTriangle(getX(),getY(),originX,originY);
       coordinates = calculateTriangle(getX(),getY(),originX, originY, angle);
       drawTriangle(coordinates,0);
     }
     if(type == 4 && redirects > 0)
     {
       coordinates = calculateSquare(getX(),getY(),originX,originY, angle);
       drawSquare(coordinates,0);
     }
     if(type == 5 && redirects > 0)
     {
       coordinates = calculateCircle(getX(),getY(),originX,originY, angle);
       if(!guidingBullet)
       {
         drawCircle(coordinates,0);
       }
     }
      if (fading > 0)
      {
        if(type == 3)
        {
          drawTriangle(staticCoordinates, fading);
        }
        if(type == 4)
        {
          drawSquare(staticCoordinates, fading);
        }
        if(type == 5)
        {
          drawCircle(staticCoordinates, fading);
        }
          fading--;
        } 
}
 
float[] calculateTriangle(float bx, float by, float cx, float cy, float angle)
{
  float dist = 2*(sqrt(sq(mouseX-bx)+sq(mouseY-by)));      // Length of one side of the triangle is twice the distance to the mouse
  if (dist < 150)                                           //sets minimum length of triange
  {
    dist = 150;
  }
  float m = (by-cy)/(bx-cx);

  if ( m > 0)                                                //adjusts the third point depending on slope of line and mouse position
  {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0)
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  else
  {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0) 
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  float[] coords = {direction, bx, by, angle, dist};
  return coords;
}
 
 void drawTriangle(float[] coords, int opacity)
{
  if (opacity > 0)
  {
    fill(255,255,255, opacity*2.5);
    noStroke();
  }
  else
  {
    noFill();
    stroke(255,255,255);
  }
  pushMatrix();
  translate(coords[1], coords[2]);
  rotate(coords[3]);
  triangle(0,0,0,coords[4],coords[0]*sqrt((3*sq(coords[4]))/4),(coords[4]/2)); 
  popMatrix();
  stroke(0,0,0);
}


float[] calculateSquare(float bx, float by, float cx, float cy, float angle)
{
  float dist = sqrt(sq(mouseX-bx)+sq(mouseY-by)); 
  if(dist < 100)
  {
    dist = 100;
  }
  float m = (by-cy)/(bx-cx);
  
  
   if ( m > 0)                                                //adjusts the third point depending on slope of line and mouse position
   {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0)
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  else
  {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0) 
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  float[] plotPoints = {direction, bx, by, angle, dist};
  return plotPoints;
} 


void drawSquare(float[] temp, int opacity)
{
  if (opacity > 0)
  {
    fill(255,255,255, opacity*2.5);
    noStroke();
  }
  else
  {
    noFill();
    stroke(255,255,255);
  }
  
  pushMatrix();
  translate(temp[1], temp[2]);
  rotate(temp[3]);
  rect(0,0, temp[0]*temp[4], temp[4]);
  popMatrix();
  stroke(0,0,0);
}


float[] calculateCircle(float bx, float by, float cx, float cy, float angle)
{
  float dist = 2*sqrt(sq(mouseX-bx)+sq(mouseY-by));            //double radius of circle around bullet
  float m = (by-cy)/(bx-cx);                                   //slope
  
   if ( m > 0)                                                //adjusts the third point depending on slope of line and mouse position
   {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0)
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  else
  {
      if ((bx-cx)*(mouseY-cy)-(by-cy)*(mouseX-cx) > 0) 
      {
        direction = 1;
      }
      else 
      {
        direction = -1;
      }
  }
  float[] plotPoints = {direction, bx, by, angle, dist};
  return plotPoints;
}
  
  
void drawCircle(float[] temp, int opacity)
{
  if (opacity > 0)
  {
    fill(255,255,255, opacity*0.75);
    noStroke();
  }
  else
  {
    noFill();
    stroke(255,255,255);
  }
  
    pushMatrix();
    translate(temp[1],temp[2]);
    rotate(temp[3]);
    ellipse(0+temp[0]*temp[4]/2, 0, temp[4],temp[4]);
    popMatrix();
    stroke(0,0,0);
}  
  
}