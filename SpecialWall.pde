class SpecialWall extends Wall
{
  boolean moving;
  boolean fading;
  boolean start;
  boolean vertical; //true = vertical false = hortizonal
  boolean faded;    //switch for fading off 
  float moveSpeed;
  float fadeSpeed; 
  int positionTracker;
  int limit;
  boolean direction = true;


SpecialWall(int a, int b, int c, int d, boolean move, boolean vert, boolean fade, int max, float rate, color paint)
{
  super(a,b,c,d, paint, false);
  moving = move;
  fading = fade;
  vertical = vert;
  positionTracker = 0;
  limit = max;
  moveSpeed = rate;
  fadeSpeed = rate;
  faded = false;
  start = true;
}

boolean getMove()
{
  return moving;
}

boolean getVert()
{
  return vertical;
}

boolean getFade()
{
  return fading;
}
int getMax()
{
  return limit;
}
float getRate()
{
  return moveSpeed;
}

boolean getFaded()
{
  return faded;
}
int getTracker()
{
  return positionTracker;
}

boolean getDirection()
{
  return direction;
}

void setTracker(int track)
{
  positionTracker = track;
}

void setDirection(boolean flip)
{
  direction = flip;
}

void setStart(boolean ignition)
{
  start = ignition;
}

void drawWall()
{
  if(moving)
  {
    fill(wallColor);
    if (start)
    {
      rect(corners[0],corners[1],corners[2],corners[3]);
    }
    else
    {
      drawMovingWall();
    }

  }
  else if(fading)
  {
    drawFadingWall();
  }
}



void drawMovingWall()
{
  noStroke();
  if(vertical)
  {
    if(direction)
    {
      corners[1] = corners[1]+(1*moveSpeed);
      corners[3] = corners[3]+(1*moveSpeed);
      rect(corners[0],corners[1],corners[2],corners[3]);
      
      if(positionTracker < limit)
      {
        positionTracker++;
      }
      else
      {
        direction = !direction;
      }
    }
    else
    {
      corners[1] = corners[1]-(1*moveSpeed);
      corners[3] = corners[3]-(1*moveSpeed);
      rect(corners[0],corners[1],corners[2],corners[3]);
      
      if(positionTracker > 0)
      {  
        positionTracker--;
      }
      else
      {
        direction = !direction;
      }
    }
  }
  else if (!vertical)
  {    
    if(direction)
    {
      corners[0] = corners[0]+(1*moveSpeed);
      corners[2] = corners[2]+(1*moveSpeed);
      rect(corners[0],corners[1],corners[2],corners[3]);
      
      if(positionTracker < limit)
      {
      positionTracker++;
      }
      else
      {
        direction = !direction;
      }
    }
    else
    {
      corners[0] = corners[0]-(1*moveSpeed);
      corners[2] = corners[2]-(1*moveSpeed);
      rect(corners[0],corners[1],corners[2],corners[3]);
      
      if(positionTracker > 0)
      {
        positionTracker--;
      }
      else
      {
        direction = !direction;
      }
    }
  }
}

void drawFadingWall()
{
  noStroke();
  if(direction)
  {
    fill(wallColor);
    faded = false;
    positionTracker++;
  }
  else if (!direction)
  {
    noFill();
    faded = true;
    positionTracker--;
  }
  rect(corners[0],corners[1],corners[2],corners[3]);
  if (positionTracker == limit)
  {
    direction = !direction;
  }
  if (positionTracker == 0)
  {
    direction = !direction;
  }
}

}