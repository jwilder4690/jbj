class Tank
{
float tankX;
float tankY;
float modifier;
float angle;
float turnAngle;
float fuel;
float range;
int speed;
int health;
int turbo;
color paintJob;




Tank(int fuelGiven, float startX, float startY)
{
  tankX = startX;
  tankY = startY;
  speed = 2;
  modifier = 1;
  turbo = 500;
  health = 150;
  fuel = fuelGiven;
  angle = 0;
  range = 450;
  paintJob = color(98,244,3);
}


//////////////////////// For the HUD ///////////////////////////////

int getTurbo()
{
  return turbo;
}

float getFuel()
{
  return fuel;
}

int getHealth()
{
  return health;
}

/////////////////////////////////////////////////////////////////////


float getX()
{
  return tankX;
}

void setX(float x)
{
  tankX = x;
}

void setY(float y)
{
  tankY = y;
}

float getY()
{
  return tankY;
}

void setTurnAngle(float turn)
{
  turnAngle = turn;
}

float getTurnAngle()
{
  return turnAngle;
}

float getAngle()
{
  return angle;
}

void setRange(float max)
{
  range = max;
}


void setAngle(float aim)
{
  angle = aim;
}

void setTurbo(int boost)
{
  turbo -= boost;
    if(turbo < 0)
    {
      turbo = 0;
    }
}

void setPaintJob(color paint)
{
  paintJob = paint;
}

void setHealth(int life)
{
  health = life;
}

void setModifier(float adjustment)
{
  modifier = adjustment;
}

void setFuel(int gas)
{
  fuel = gas;
}

void setSpeed(int throttle)
{
  speed = throttle;
}


float getSpeed()
{
  return speed;
}


void takeDamage(int damage)
{
  health -= damage;
  if(health < 0)
  {
    health = 0;
  }
}


/////////////////////////////////Movement and Aim///////////////////////////

void moveUp()
{
  if (fuel > 0)
  {
  tankY -= speed*modifier;
  fuel = fuel-(1*modifier);
  }
}
void moveDown()
{
  if (fuel > 0)
  {
    tankY += speed*modifier;
    fuel = fuel-(1*modifier);
  }
}
void moveLeft()
{
  if (fuel > 0)
  {
    tankX -= speed*modifier;
    fuel = fuel-(1*modifier);
  }
}
void moveRight()
{
  if (fuel > 0)
  {
     tankX += speed*modifier;
     fuel = fuel-(1*modifier);
  }
}



void drawTank(float mX, float mY, int level)
{  
  float target = constrain(sqrt(sq(mX-tankX)+sq(mY-tankY)), 0, range);
  
  if(level > 3)
  {
    setAngle(atan2((this.getY()-mY),((this.getX()-mX)))-PI/2);
  }
  else
  {
    setAngle(turnAngle);
  }
  fill(paintJob);
  stroke(0,100,0);
  pushMatrix();
  translate(tankX, tankY);
  pushMatrix();
  rotate(turnAngle);
  rect(-12,-12, -7, 12);
  rect(7, -12, 12, 12);
  rect(-10, -10, 10,10);
  popMatrix();
  rotate(angle);
  ellipse(0,0, 10,10);
  rect(-1,0, 1,-20);
  noStroke();
  fill(0,255,0);
  ellipse(0,-target,5,5);             //////target laser
  stroke(0,255,0);
  noFill();
  ellipse(0,-target, 7,7);
  popMatrix();
}
}