void contactServer()
{
  if(level == 0)
  {
    clientJBJ.updateServer("NA",0);
  }
  else
  {
    clientJBJ.updateServer(fPlayerName.getValue(),sw.getElapsedTime());
  }
}


String timerForm(int time)        //////formats milliseconds into hours, minutes, seconds, hundreths with padding
{
  return (nf((time/(1000*60*60))%24,2)+":"+nf((time/(1000*60))%60,2)+":"+nf((time/(1000))%60,2)+":"+nf((time/10)%100,2));
}

void triggerAlarm()
{
    if(start)
    {
      alarm.setGain(startingVolume);
      alarm.trigger();
      start = false;
    }
   alarm.shiftGain(startingVolume, -40,7500);
}


void loadDescription(String file)
{
  String line = null;
  try
  {
    BufferedReader reader = createReader(file);
    line = reader.readLine();
    title = line;
    line = reader.readLine();
    body = line;
  }
  catch (Exception e)
  {
    e.printStackTrace();  
  }  
}


void createAudio()
{
  minim = new Minim(this);
  for(int i = 0; i < 22; i++)
  {
    songs[i] = minim.loadFile("level"+i+".mp3");
  }
  tankMove = minim.loadFile("tankMove.wav");
  laserGuide = minim.loadFile("laserGuide.wav");
  
  laserHero = minim.loadSample("laserHero.wav");
  laserEnemy = minim.loadSample("laserEnemy.wav");
  laserEmpty = minim.loadSample("laserEmpty.wav");
  laserBounce = minim.loadSample("laserBounce.wav");
  powerDown = minim.loadSample("powerDown.wav");
  alarm = minim.loadSample("alarm.wav");
  explosion = minim.loadSample("explosion.wav");
  switchWeapon = minim.loadSample("switchWeapon.wav");
  bounce = minim.loadSample("bounce.wav");
  grunt = minim.loadSample("grunt.wav");
  redirect = minim.loadSample("redirect.wav");
  laserTeleport = minim.loadSample("laserTeleport.wav");
  laserImpact = minim.loadSample("laserImpact.wav");
  laserSplit = minim.loadSample("laserSplit.wav"); 
  deadzone = minim.loadSample("deadzone.wav"); 
  portal = minim.loadSample("portal.wav"); 
  winLevel = minim.loadSample("winLevel.wav");
  
  startingVolume = alarm.getGain();             /////////////////Sets volume in beginning so that we can reset
}


void playAudio(int progress)
{
  if(progress < 22)
  {
    if(progress > 0)
    {
       songs[progress-1].pause();
       songs[progress-1].rewind();
       songs[progress].play();
    }
    else
    {
      songs[progress].play();
    }
  }
}

void pauseAudio(int progress)
{
  songs[progress].pause();
}

void toggleMute(boolean noisy)
{
  if(noisy)
  {
    laserHero.mute();
    laserEnemy.mute();
    laserEmpty.mute();
    tankMove.mute();
    alarm.mute();
    explosion.mute();
    switchWeapon.mute();
    bounce.mute();
    grunt.mute();
    redirect.mute();
  }
  else
  {
    laserHero.unmute();
    laserEnemy.unmute();
    laserEmpty.unmute();
    tankMove.unmute();
    alarm.unmute();
    explosion.unmute();
    switchWeapon.unmute();
    bounce.unmute();
    grunt.unmute();
    redirect.unmute();
  }
}

void loadLevel(String file)
{
  String line = null;
  String[] pieces;
  int loop = 0;
  try
  {
    BufferedReader reader = createReader(file);
    line = reader.readLine();
    pieces = split(line,",");
    finishZone = new Wall(int(pieces[0]),int(pieces[1]),int(pieces[2]),int(pieces[3]),color(int(pieces[4]),int(pieces[5]),int(pieces[6])),false);
    loop = int(reader.readLine());
    for(int i = 0; i < loop; i++)                                              ////Terrain
    {
      line = reader.readLine();
      pieces = split(line,",");
      terrain.add(new Wall(int(pieces[0]),int(pieces[1]),int(pieces[2]),int(pieces[3]),color(int(pieces[4]),int(pieces[5]),int(pieces[6])),false));
    }
    line = reader.readLine();
    pieces = split(line,",");
    hero = new Tank(int(pieces[0]),float(pieces[1]),float(pieces[2]));         ////Hero
    fuelGiven = int(pieces[0]);
    loop = int(reader.readLine());
    for(int i = 0; i < loop; i++)                                          ////Enemies
    {
      line = reader.readLine();
      pieces = split(line,",");
      enemies.add(new Enemy(float(pieces[0]),float(pieces[1]),boolean(pieces[2]),boolean(pieces[3]),boolean(pieces[4]),int(pieces[5]),float(pieces[6]),int(pieces[7]),int(pieces[8])));
      enemies.get(enemies.size()-1).setTracker(float(pieces[9]));
      enemies.get(enemies.size()-1).setDirection(boolean(pieces[10]));
      enemies.get(enemies.size()-1).setStart(false);
    }
    loop = int(reader.readLine());
    for(int i = 0; i < loop; i++)                                             /////Walls
    {
      line = reader.readLine();
      pieces = split(line, ",");
      walls.add(new Wall(int(pieces[0]),int(pieces[1]),int(pieces[2]),int(pieces[3]),color(int(pieces[4]),int(pieces[5]),int(pieces[6])),boolean(pieces[7])));

    }
    loop = int(reader.readLine());
    for(int i = 0; i < loop; i++)                         ////Spec Walls
    {
      line = reader.readLine();
      pieces = split(line,",");
      wallsSpec.add(new SpecialWall(int(pieces[0]),int(pieces[1]),int(pieces[2]),int(pieces[3]),boolean(pieces[4]),boolean(pieces[5]),boolean(pieces[6]),int(pieces[7]),float(pieces[8]),color(int(pieces[9]),int(pieces[10]),int(pieces[11]))));
      wallsSpec.get(wallsSpec.size()-1).setTracker(int(pieces[12]));
      wallsSpec.get(wallsSpec.size()-1).setDirection(boolean(pieces[13]));
      wallsSpec.get(wallsSpec.size()-1).setStart(false);
    }
    loop = int(reader.readLine());
    for(int i = 0; i < loop; i++)                          //////Bullets
    {
      line = reader.readLine();
      ammoClips[i] = int(line);
    }
    ammoLeft = ammoClips.clone();
    fillWeaponsCache(ammoClips);
  } 
  catch (Exception e)
  {
    e.printStackTrace();  
  }
}



void checkInput()
{
  heroX = hero.getX();
  heroY = hero.getY();
  
  //////////////////////////////////////////////////////////////////Sound Trigger/////////////////////////////////////////////////////////////////////////////
  if((keys['a'] || keys['A']) || (keys['w'] || keys['W']) || (keys['d'] || keys['D']) || (keys['s'] || keys['S']))  ////if A,W,S,D pressed
  {

    if(!looping && hero.getFuel() > 0)
    {
      tankMove.loop();
      looping = true;
    }
  }
  else
  {
    tankMove.pause();
    looping = false;
  }
  


  //////////////////////////////////////////////////////////////Speed and Angle///////////////////////////////////////////////////////////////////////////////
  
  if((keys['a'] || keys['A']) && (keys['w'] || keys['W']))            /////if diagonal movement slows and turns
  {
    hero.setModifier(.71);
    hero.setTurnAngle(-PI/4);
  }
  else if((keys['d'] || keys['D']) && (keys['s'] || keys['S']))
  {
    hero.setModifier(.71);
    hero.setTurnAngle(3*PI/4);
  }
  else if((keys['a'] || keys['A']) && (keys['s'] || keys['S']))               /////if diagonal movement slows and turns     
  {
    hero.setModifier(.71);
    hero.setTurnAngle(5*PI/4);
  }
  else if ((keys['w'] || keys['W']) && (keys['d'] || keys['D']))
  {
    hero.setModifier(.71);
    hero.setTurnAngle(PI/4);
  }
  else if (keys['a'] || keys['A'])  
  {
    hero.setModifier(1);
    hero.setTurnAngle(-PI/2);
  }
  else if (keys['d'] || keys['D'])
  {
    hero.setModifier(1);
    hero.setTurnAngle(PI/2);
  }
  else if (keys['w'] || keys['W']) 
  {
    hero.setModifier(1);
    hero.setTurnAngle(0);
  }
  else if  (keys['s'] || keys['S'])
  {
    hero.setModifier(1);
    hero.setTurnAngle(PI);
  }
  
  
  //////////////////////////////////////////////////Movement////////////////////////////////////////////////////////////////////////////////////
  if (keys['a'] || keys['A'])
  {
    hero.moveLeft();
    if(collisionDetection(walls, wallsSpec, hero.getX(), hero.getY(), 10))           ///tests next move for collision, returns if collides, sets movement otherwise
    {
      hero.setX(heroX);
      hero.setY(heroY);
    }
  }
  if (keys['w'] || keys['W'])
  {
    hero.moveUp();
    if(collisionDetection(walls, wallsSpec, hero.getX(), hero.getY(), 10))
    {
      hero.setX(heroX);
      hero.setY(heroY);
    }
  }
  if (keys['s'] || keys['S'])
  {
    hero.moveDown();
    if(collisionDetection(walls, wallsSpec, hero.getX(), hero.getY(), 10))
    {
      hero.setX(heroX);
      hero.setY(heroY);
    }
  }
  if (keys['d'] || keys['D'])
  {
    hero.moveRight();
    if(collisionDetection(walls, wallsSpec, hero.getX(), hero.getY(), 10))
    {
      hero.setX(heroX);
      hero.setY(heroY);
    }
  }
  
  ///////////////////////////////////////////////Hot keys////////////////////////////////////////////////////////////////////////////
  if((keys['r'] || keys['R']) && (gameMode == GAME_LEVEL || gameMode == LOSS_SCREEN || gameMode == VICTORY_SCREEN))
  {
    sw.stop();
    sw.start();
    bulletTracker = 0;
    if(gameMode == LOSS_SCREEN || gameMode == VICTORY_SCREEN)
    {
      gameMode = LEVEL_DESCRIPTION;
      if(level > 20)
      {
        level = 21;
      }
      bNext.setX(1000);
      bRetry.setX(width+170);
    }
    else
    {
      clearAll();
      if(level > 20)
      {
        level = 21;
      }
      loadLevel("level"+level+".txt");
      gameMode = GAME_LEVEL;
    }
  }
  
  if(keys[' '] && (gameMode == LEVEL_DESCRIPTION || gameMode == VICTORY_SCREEN))
  {
    if(gameMode == VICTORY_SCREEN)
    {
      clearAll();
      if(level == 21)
      {
        gameMode = CREDITS;
        bNext.setX(width+170);
        bLeaderBoard.setX(200);
      }
      else
      {
        gameMode = LEVEL_DESCRIPTION;
        level++;
        loadDescription("description"+level+".txt");
      }
      bRetry.setX(width+170);
      bMain.setX(10);
    }
    else 
    {
      gameMode = GAME_LEVEL;
      clearAll();
      loadLevel("level"+level+".txt");
      bNext.setX(width+170);
      bRetry.setX(1000);
      bMain.setX(width + 170);
      sw.start();
    }
  }
  
  //////////////////////////////////////////////Cheat Codes//////////////////////////////////////////////////////////////////////////
  if(keys['G'] && keys['J'])
  {
    gameMode = VICTORY_SCREEN;
    bulletTracker = 0;
    bRetry.setX(width+170);
    bNext.setX(1000);
    cursor();
    sw.stop();
  }
}


boolean bulletCollision(ArrayList<Enemy> grunts, float x, float y, int size)
{
  if(sqrt(sq(hero.getX()-x)+sq(hero.getY()-y)) < size+10)      /////Checks for collision with Hero
  {
    if( gameMode == GAME_LEVEL)
    {
      wound = 255;
      hero.takeDamage(50);
      grunt.trigger();
    }
    return true;
  }
  for(int i = 0; i < grunts.size(); i++)       /////Checks for collision with Enemies
  {
    if(sqrt(sq(grunts.get(i).getX()-x)+sq(grunts.get(i).getY()-y)) < size+10)
    {
      if(gameMode == GAME_LEVEL)
      {
        grunts.get(i).takeDamage(50);
      }
      if(grunts.get(i).getHealth() == 0)
      {
        grunts.get(i).explode();
      }
      return true;
    }
  }
  return false;
}


boolean collisionDetection(ArrayList<Wall> obstacles, ArrayList<SpecialWall> obstacles2, float x, float y, int size)
{
  if ((x+size) > 1100 || (x-size) < (0) || (y+size) > 700 || (y-size) < 0)                                                  /////checks for collision with boundary walls, uses size for width of colliding object
  {
    return true;
  }
  for(int i = 0; i < enemies.size(); i++)
  {
    if (dist(x,y,enemies.get(i).getX(), enemies.get(i).getY()) < 20)
    {
      return true;
    }
  }
  for(int i = 0; i < obstacles.size(); i++)                                                                                 //////loops through walls, uses corners to check for collision, 4 methods based on how you drew box
  {
    if (x > obstacles.get(i).getCorner(0) - size && x <  obstacles.get(i).getCorner(2) + size && y > obstacles.get(i).getCorner(1) - size && y <  obstacles.get(i).getCorner(3) + size)
    {
      if(obstacles.get(i).isDeadzone())     //kills player if steps on deadzone
      {
        cursor();
        gameMode = LOSS_SCREEN;
        grunt.trigger();
        deadzone.trigger();
      }
      return true; 
    }
    //////////////////////removed 4 corner check here, still working?????????????
  }
  
  for(int i = 0; i < obstacles2.size(); i++)                                                                                 //////loops through special walls, uses corners to check for collision, 4 methods based on how you drew box
  {
    if (!obstacles2.get(i).getFaded() && x > obstacles2.get(i).getCorner(0) - size && x < obstacles2.get(i).getCorner(2) + size && y > obstacles2.get(i).getCorner(1) - size && y < obstacles2.get(i).getCorner(3) + size)
    {
      return true;
    }
//////////////////////removed 4 corner check here, still working?????????????
  }
  return false;
}

boolean collisionDetectionBullet(ArrayList<Wall> obstacles, ArrayList<SpecialWall> obstacles2, float x, float y, int size, Projectile  bullet)
{
  if ((x+size) > 1100 || (x-size) < (0) || (y+size) > 700 || (y-size) < 0)                                                  /////checks for collision with boundary walls, uses size for width of colliding object
  {
    if((x+size) > 1100 || (x-size) < 0)
    {
      bullet.setCollisionType(true);
    }
    if((y+size) > 700 || (y-size) < 0)
    {
      bullet.setCollisionType(false);
    }
    
    return true;
  }
  for(int i = 0; i < obstacles.size(); i++)                                                                                 //////loops through walls, uses corners to check for collision, 4 methods based on how you drew box
  {
    if(obstacles.get(i).isDeadzone())
    {
      continue;
    }
    if (x > obstacles.get(i).getCorner(0) - size && x <  obstacles.get(i).getCorner(2) + size && y > obstacles.get(i).getCorner(1) - size && y <  obstacles.get(i).getCorner(3) + size)
    {
      if(x > obstacles.get(i).getCorner(0) && x <  obstacles.get(i).getCorner(2))                                          /////Checks whether the bullet collided with a vertical wall or horizontal
      {
        bullet.setCollisionType(false);                                                                                           
      }
      else if (y > obstacles.get(i).getCorner(1) && y <  obstacles.get(i).getCorner(3))
      {
        bullet.setCollisionType(true);
      }
      else
      {
        float angle = bullet.getAngle();
        if(abs(obstacles.get(i).getCorner(0)-x) < size && abs(obstacles.get(i).getCorner(1)-y) < size)      /////handles top left corner case 
        {
          if(angle > (-3*PI)/2 && angle < -radians(225))               ////////adjusts based on angle of bullet
          {
            bullet.setCollisionType(true);
          }
          else if(angle > -radians(225) && angle < -PI)
          {
            bullet.setCollisionType(false);
          }
          else if(angle > -PI && angle < -PI/2)
          {
            bullet.setCollisionType(false);
          }
          else if(angle > 0 && angle < PI/2)
          {
            bullet.setCollisionType(true);
          }
          else 
          { 
          }    
        }
        else if(abs(obstacles.get(i).getCorner(0)-x) < size && abs(y-obstacles.get(i).getCorner(3)) < size)    //////handles bottom left case
        {
          if(angle > 0 && angle < radians(45))               ////////adjusts based on angle of bullet
          {
            bullet.setCollisionType(false);
          }
          else if(angle > radians(45) && angle < PI/2)
          {
            bullet.setCollisionType(true);
          }
          else if(angle < 0 && angle > -PI/2)
          {
            bullet.setCollisionType(false);
          }
          else if(angle < -PI && angle > (-3*PI)/2)
          {
            bullet.setCollisionType(true);
          }
          else 
          {  
          }  
        }
        else if(abs(x-obstacles.get(i).getCorner(2)) < size && abs(y-obstacles.get(i).getCorner(3)) < size)   //////handles bottom right case
        {
          if(angle < 0 && angle > -radians(45))               ////////adjusts based on angle of bullet
          {
            bullet.setCollisionType(false);
          }
          else if(angle > -radians(45) && angle < -PI/2)
          {
            bullet.setCollisionType(true);
          }
          else if(angle < -PI/2 && angle > -PI)
          {
            bullet.setCollisionType(true);
          }
          else if(angle > 0 && angle < PI/2)
          {
            bullet.setCollisionType(false);
          }
          else 
          {
          }
        }
        else if(abs(obstacles.get(i).getCorner(2)-x) < size && abs(y-obstacles.get(i).getCorner(1)) < size)   /////handles top right corner case
        {
          if(angle < -PI/2 && angle > -radians(135))               ////////adjusts based on angle of bullet
          {
            bullet.setCollisionType(true);
          }
          else if(angle < -radians(135) && angle > -PI)
          {
            bullet.setCollisionType(false);
          }
          else if(angle < -PI && angle > (-3*PI)/2)
          {
            bullet.setCollisionType(false);
          }
          else if(angle < 0 && angle > -PI/2)
          {
            bullet.setCollisionType(true);
          }
          else 
          {  
          }
        }
      }
      return true; 
    }
  //////////////////////removed 4 corner check here, still working?????????????
  }
  
  for(int i = 0; i < obstacles2.size(); i++)                                                                                 //////loops through special walls, uses corners to check for collision, 4 methods based on how you drew box
  {
    if (!obstacles2.get(i).getFaded() && x > obstacles2.get(i).getCorner(0) - size && x < obstacles2.get(i).getCorner(2) + size && y > obstacles2.get(i).getCorner(1) - size && y < obstacles2.get(i).getCorner(3) + size)
    {
      if(x < obstacles2.get(i).getCorner(0) || x >  obstacles2.get(i).getCorner(2))
      {
        bullet.setCollisionType(true);
      }
      else 
      {
        bullet.setCollisionType(false);
      }
      return true;
    }
  //////////////////////removed 4 corner check here, still working?????????????
  }
  return false;
}

int checkGameState(ArrayList<Enemy> grunts, int currentState, Wall zone)
{
  for(int i = 0; i < wallsSpec.size(); i++)                                                                                 //////loops through special walls, uses corners to check for collision, 4 methods based on how you drew box
  {
    if (!wallsSpec.get(i).getFaded() && hero.getX() > wallsSpec.get(i).getCorner(0) - 10 && hero.getX() < wallsSpec.get(i).getCorner(2) + 10 && hero.getY() > wallsSpec.get(i).getCorner(1) - 10 && hero.getY() < wallsSpec.get(i).getCorner(3) + 10)
    {
      cursor();
      bMain.setX(10);
      return LOSS_SCREEN;
    }
//////////////////////removed 4 corner check here, still working?????????????
  }
  if(hero.getHealth() == 0)
  {
    cursor();
    bMain.setX(10);
    return LOSS_SCREEN;
  }
  int army = 50;
  if(grunts.size() > 0)
  {
    army = grunts.size();
  }
  for(int i = 0; i < grunts.size(); i++)
  {
    if(grunts.get(i).getStatus())
    {
      army--;
    }
  }
 if(army == 0)
 {
   cursor();
   sw.stop();
   thread("contactServer");
   bulletTracker = 0; //////////////////////////////resets to 0, in case level goes from having many weapons to fewer//////////////////////////
   start = true;      /////allows alarm to retrigger
   winLevel.trigger();
   tankMove.pause();
   laserGuide.pause();
   bNext.setX(1000);
   bRetry.setX(910);
   return VICTORY_SCREEN;
  }
  
 if (hero.getX() > zone.getCorner(0) - 10 && hero.getX()<  zone.getCorner(2) + 10 && hero.getY() > zone.getCorner(1) - 10 && hero.getY() <  zone.getCorner(3) + 10)
 {
   portal.trigger();
   if (level < 21)
   {
     cursor();
     sw.stop();
     thread("contactServer");
     winLevel.trigger();
     bulletTracker = 0; //////////////////////////////resets to 0, in case level goes from having many weapons to fewer//////////////////////////
     tankMove.pause();
     bNext.setX(1000);
     bRetry.setX(910);
     start = true;      /////allows alarm to retrigger
     return VICTORY_SCREEN; 
   }
   else if(level == 25)
   {
     level = 21;   ///////////resets to 21 because 21-25 were linked
     cursor();
     sw.stop();
     thread("contactServer");
     winLevel.trigger();
     bulletTracker = 0; //////////////////////////////resets to 0, in case level goes from having many weapons to fewer//////////////////////////
     tankMove.pause();
     bNext.setX(1000);
     bRetry.setX(910);
     start = true;      /////allows alarm to retrigger
     return VICTORY_SCREEN; 
   }
   else if(level > 20 && level != 25)
   {
     ////// triger sound
     level++;  
     clearAll();
     loadLevel("level"+level+".txt");
     return currentState;
   }
 }
return currentState;
}

void fillWeaponsCache(int[] ammo)
{
  weaponsCache.clear();
  for(int i = 0; i < ammo.length; i++)
  {
    if(ammo[i] != 0)
    {
      weaponsCache.append(i);
    }
  }
}

 void nameChange(String name)
{
  String newName = name;
  newName = newName.replace(';', 'A');
  newName = newName.replace('>', 'A');
  newName = newName.replace(',', 'A');
  newName = newName.replace('^', 'A');
  if(!newName.equals(name))
  {
    fPlayerName.setValue(newName);
    nameUpdated = true;
  }
}

boolean mouseCheck()
{
  if(mouseY < 700)
  {
    return true;
  }
  else
  {
    return false;
  }
}


void stop()
{
  minim.stop();
  super.stop();
}

void loadFonts()
{
  titleFont = loadFont("ARDESTINE-60.vlw");
  bodyFont = loadFont("AgencyFB-Reg-45.vlw");
  detailsFont = loadFont("AgencyFB-Reg-25.vlw");
}


void loadSaves(String file, ArrayList users, IntList saves)
{
  String line = null;
  String[] pieces;
  int loop;
  try
  {
    BufferedReader reader = createReader(file);
    line = reader.readLine();
    loop = int(line);
    for(int i = 0; i < loop; i++)
    {
      line = reader.readLine();
      pieces = split(line,",");
      users.add(pieces[0]);
      saves.append(int(pieces[1]));
    }
  } 
  catch (Exception e)
  {
    e.printStackTrace();  
  }
}

int loadProgress(String user, int levelChallenged, ArrayList users, IntList saves)
{
  if(levelChallenged == 0)
  {
    return 1;
  }
  for(int i = 0; i < users.size(); i++)
  {
    if(user.equals(users.get(i)))
    {
      if(levelChallenged <= saves.get(i))
      {
        return levelChallenged;
      }
      else return 1;
    }
  }
  return 1;
}

void saveProgress(String user, int level, ArrayList users, IntList saves)
{
  boolean hasSave = false;
  for(int i = 0; i < users.size(); i++)
  {
    if(user.equals(users.get(i)))
    {
      saves.set(i,level);
      hasSave = true;
      break;
    }
  }
  if(!hasSave)
  {
    users.add(user);
    saves.append(level);
  }
 
  output = createWriter("data/progress.txt");
  output.println(users.size());
  for(int i = 0; i < users.size(); i++)
  {
    output.println(users.get(i)+","+saves.get(i));
  }
   output.flush();
   output.close();
}


void createImages()
{
  tankBody = loadImage("tankBody.png");
  tankCannon = loadImage("tankCannon.png");
  tankReticule = loadImage("reticule.png");
}