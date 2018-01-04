class Wall
{
  float[] corners = new float[4];
  boolean finished;
  color wallColor;
  boolean lethal;

Wall(int a, int b, int c, int d, color wallPaint, boolean type)
{
  corners[0] = a;
  corners[1] = b;
  corners[2] = c;
  corners[3] = d;
  wallColor = wallPaint;
  finished = false;
  lethal = type;
}

Wall(int[] verts)
{
  for(int i = 0; i < 4; i++)
  {
    corners[i] = verts[i];
  }
}

float[] getCorners()
{
  return corners;
}


float getCorner(int which)
{
  return corners[which];
}

color getColor()
{
  return wallColor;
}


void setCorner(int whereC, int whereD)
{
  corners[2] = whereC;
  corners[3] = whereD;
}

void setAllCorners(int[] verts)
{
  for(int i = 0; i < 4; i++)
  {
    corners[i] = verts[i];
  }
}

boolean isDeadzone()
{
  return lethal;
}

boolean getStatus()
{
 return finished; 
}


void finishWall()
{
  finished = true;
}

void drawWall()
{
  if (lethal)
  {
    stroke(255,0,0);
    fill(wallColor, 150);
  }
  else
  {
    noStroke();
    fill(wallColor);
  }
  rect(corners[0],corners[1],corners[2],corners[3]);
}
}