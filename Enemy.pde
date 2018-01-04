class Enemy extends Tank
{
  boolean moving;
  boolean vertical;
  boolean shooting; 
  int limit;
  float moveSpeed;
  int bulletRate;      /////was float? Not needed
  float positionTracker;
  int ammoTracker;
  boolean direction;
  boolean destroyed;
  boolean start;
  int aim;
  
  Enemy(float b, float c, boolean move, boolean vert, boolean shoot, int max, float rate, int br, int targetting)
  {
    super(500,b,c);
    health = 50;
    moving = move;
    vertical = vert;
    shooting = shoot;
    limit = max;
    moveSpeed = rate;
    bulletRate = br;
    positionTracker = 0;
    ammoTracker = 0;
    destroyed = false;
    start = true;
    aim = targetting;
  }

  int getAim()
  {
    return aim;
  }
  
  boolean getStatus()
  {
    return destroyed;
  }
   
  boolean getDirection()
  {
    return direction;
  }
   
  boolean getMove()
  {
    return moving;
  }
  boolean getVert()
  {
    return vertical;
  }
  boolean getShoot()
  {
    return shooting;
  }
  int getMax()
  {
    return limit;
  }
  float getRate()
  {
    return moveSpeed;
  }
  float getTracker()
  {
    return positionTracker;
  }
  int getBulletRate()
  {
    return bulletRate;
  }
  
  void setTracker(float track)
  {
    positionTracker = track;
  }
    
  void setDirection(boolean flip)
  {
    direction = flip;
  }
  
  void setStatus(boolean revive)
  {
    destroyed = revive;
  }
  
  boolean getStart()
  {
    return start;
  }
  
  void setStart(boolean ignition)
  {
    start = ignition;
  }
  
  void explode()
  {
    if(!destroyed)
    {
      explosion.trigger();
    }
    destroyed = true;
    
  }

  
  void move()
  {
    if(vertical)
    {
      if(direction)
      {
        if(positionTracker < limit)
        {
          tankY+=moveSpeed;
          positionTracker+=moveSpeed;
        }
        else
        {
          direction = !direction;
        }
      }
      else if(!direction)
      {
          if(positionTracker > 0)
          {
            tankY-=moveSpeed;
            positionTracker-=moveSpeed; 
          }
          else
          {
            direction = !direction;
          }
      }
    }
    else if(!vertical)
    {
      if(direction)
      {
        if(positionTracker < limit)
        {
          tankX+=moveSpeed;
          positionTracker+=moveSpeed;
        }
        else
        {
          direction = !direction;
        }
      }
      else if(!direction)
      {
          if(positionTracker > 0)
          {
            tankX-=moveSpeed;
            positionTracker-=moveSpeed; 
          }
          else
          {
            direction = !direction;
          }
      } 
    }
  }
  
  void shoot()
  {
    if(ammoTracker < bulletRate)
    {
      ammoTracker++;
    }
    else
    {
      ammoTracker = 0;
      laserEnemy.trigger();
      shotsEnemy.add(new Projectile(tankX, tankY, angle, 0,false));
      shotsEnemy.get(shotsEnemy.size()-1).setColor(255,0,150);
    }
  }
  
  
  void drawEnemy(float targetX, float targetY)
  {
    if(moving && !destroyed && !start)
    {
      move();
    }
    
    if(!destroyed)
    {
      fill(227,3,200);
      switch(aim)
      {
        case -1: setAngle(atan2((this.getY()-targetY),((this.getX()-targetX)))-PI/2); break;      /////aim at hero, need this because default radio index is -1
        case 0:  setAngle(atan2((this.getY()-targetY),((this.getX()-targetX)))-PI/2); break;      /////aim at hero
        case 1:  setAngle(0); break;                                                             /////aim up
        case 2:  setAngle(-PI/2); break;                                                          /////aim left
        case 3:  setAngle(PI); break;                                                              /////aim down
        case 4:  setAngle(PI/2); break;                                                           /////aim right
      }
    }

    if(destroyed)
    {
      fill(100,50,100);
    }
    stroke(0,0,0);
    pushMatrix();
    translate(tankX, tankY);
    if(!moving)
    {
      rect(-10, -10, 10,10);
      rect(-11,-11,-8,-8);
      rect(8,8,11,11);
      rect(8,-11, 11,-8);
      rect(-11,8, -8, 11);
      rotate(angle);
      rect(-5,-5, 5,5);
      rect(-1,0, 1,-20);
    }
    else if (vertical)
    {
      rect(-12,-12, -7, 12);
      rect(7, -12, 12, 12);
      rect(-10, -10, 10,10);
      rotate(angle);
      ellipse(0,0, 10,10);
      rect(-1,0, 1,-20);
    }
    else 
    {
      rect(-12,-12, 12, -7);
      rect(-12, 7, 12, 12);
      rect(-10, -10, 10,10);
      rotate(angle);
      ellipse(0,0, 10,10);
      rect(-1,0, 1,-20);
    }
    popMatrix();
    if(shooting && ! destroyed)
    {
      shoot();
    }
  }
}