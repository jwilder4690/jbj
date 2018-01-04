void drawBorders()
{
  fill(0,0,0);
  rect(1100,0,width,height);
  rect(0,800,width, height);
}


void drawSplash(int progress)
{
  switch(progress)   
  {
    case CONTROLS: drawControlsSplash(); break;
    case ALL_TIME_LEADERBOARDS: noStroke(); fill(0,255,0); rect(0,0,1100,800); fill(0,0,0); textFont(bodyFont, 45); text("Here is a list of the people that love Jake the most", 30, 50); clientJBJ.displayLeaderBoard(level); break;
    case CREDITS: stroke(0,255,255); strokeWeight(2); fill(50,50,75); rect(0,0,1100,800); fill(220,220,255); textFont(bodyFont, 45); text("Justin Wilder made this. \n \n A special thanks to Jordan Fromer and Nick Hyndman for brainstorming with me. \n \n Thank you to Vincent, Bryentt, and Morgin for helping test. \n \n Thanks to Ryan Prince and anyone else who had to listen to me ramble endlessly about programming.", 90, 100, 1025, 725); break;
    case VICTORY_SCREEN: fill(0,255,0); rect(0,0,1100,800); fill(0,0,0); text("Congratulations "+fPlayerName.getValue()+", you won!", 30, 50); text("You completed level "+level+" in: "+nf(sw.hour(),2)+":"+nf(sw.minute(),2)+":"+nf(sw.second(),2)+":"+nf(sw.hundredth(),2), 30, 100); clientJBJ.displayLeaderBoard(level); break;
    case LOSS_SCREEN: fill(255,0,0); rect(0,0,1100,800); fill(0,0,0); text("You lost! Try again?", 30, 50); break;
    case MAIN_SPLASH: drawMainSplash(); fill(0,255,255); textFont(detailsFont,25); text("Please enter your Player Name: ", 655,720); if(errorMessage){fill(255,0,0); textFont(detailsFont,25); text("You must enter your name to begin!", 625, 750);} fill(0,255,255); textFont(titleFont, 60); text("Jail Break Jake",80,50); break;
    case 1: drawBasicSplash(); text("Track: Unison - Aperture [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745); if(nameUpdated){fill(255,0,0); textFont(bodyFont, 35);text("The name you entered had illegal characters. Your name has been updated to: "+fPlayerName.getValue(), 100,500);}; break;
    case 2: drawBasicSplash(); text("Track: Jim Yosef - Eclipse [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;    
    case 3: drawBasicSplash(); text("Track: Subtact - Away [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);triggerAlarm();break; 
    case 4: drawBasicSplash(); text("Track: Jim Yosef - Lights [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;  
    case 5: drawBasicSplash(); text("Track: theFatRat - Monody [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;  
    case 6: drawBasicSplash(); text("Track: Waysons - Eternal Minds [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);triggerAlarm(); break;
    case 7: drawBasicSplash(); text("Track: Jim Yosef - Firefly [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break; 
    case 8: drawBasicSplash(); text("Track: Disfigure - Summer Time [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break; 
    case 9: drawBasicSplash(); text("Track: Lensko - Let's Go [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break; 
    case 10: drawBasicSplash(); text("Track: Main Reaktor - Recession [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 11: drawBasicSplash(); text("Track: Verm - Explode [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);triggerAlarm(); break;
    case 12: drawBasicSplash(); text("Track: Main Reaktor - Alone [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 13: drawBasicSplash(); text("Track: NVIRO - Sapphire [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 14: drawBasicSplash(); text("Track: Laszlo - Fall to Light [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 15: drawBasicSplash(); text("Track: Main Reaktor - Salvation [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 16: drawBasicSplash(); text("Track: Jim Yosef - Arrow [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 17: drawBasicSplash(); text("Track: Vena Cava - Noire [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745); break;
    case 18: drawBasicSplash(); text("Track: Ramzoid - Electron [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 19: drawBasicSplash(); text("Track: Malik Bash - Apollo [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 20: drawBasicSplash(); text("Track: Audioscribe - Skyline [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);break;
    case 21: drawBasicSplash(); text("Track: T&Sugah - Stardust [NCS Release]\n Music provided by NoCopyrightSounds", 110, 745);triggerAlarm(); break;
  }
}

void drawTerrain(ArrayList<Wall> ground, Wall zone)
{
  fill(50,180,50);
  for(int i = 0; i < ground.size(); i++)  /////terrain
  {
    ground.get(i).drawWall();
  }
  fill(255,205,0);
  zone.drawWall();
}

void clearAll()
{
  for(int i = walls.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    walls.remove(i);
  }
  for(int i = wallsSpec.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    wallsSpec.remove(i);
  }
  for(int i = terrain.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    terrain.remove(i);
  }
  for(int i = shotsHero.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    shotsHero.remove(i);
  }
  for(int i = shotsHero.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    shotsJake.remove(i);
  }
  for(int i = shotsEnemy.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    shotsEnemy.remove(i);
  }
  for(int i = enemies.size()-1; i >=0; i--)                   ////must loop through in revese in order to remove all items 
  {
    enemies.remove(i);
  }
}

void drawBoxes(ArrayList<Wall> obstacles, ArrayList<SpecialWall> obstacles2)
{
  fill(20,0,175);
  for(int i = 0; i < obstacles.size(); i++)  /////regular walls
  {
    obstacles.get(i).drawWall();
  }
  
  
  for(int i = 0; i < obstacles2.size(); i++)      //////special walls
  {
    obstacles2.get(i).drawWall();
  }
}


void drawBullets(ArrayList<Enemy> tanks, ArrayList<Wall> obstacles, ArrayList<SpecialWall> obstacles2, ArrayList<Projectile> shotsHero, ArrayList<Projectile> shotsEnemy, ArrayList<Projectile> shotsJake)                 ///////Loops through projectiles and draws them
{
  for(int i = 0; i < shotsHero.size(); i++)
  {
    shotsHero.get(i).drawProjectile();
    if(bulletCollision(tanks, shotsHero.get(i).getX(), shotsHero.get(i).getY(), 1))    /////checks for bullet collision with tank
    {
      laserImpact.trigger();
      shotsHero.remove(i);
    }
    else if (collisionDetectionBullet(obstacles, obstacles2, shotsHero.get(i).getX(), shotsHero.get(i).getY(), 3, shotsHero.get(i)))   ///checks for bullet colliding with wall
    {
      if(shotsHero.get(i).getType() == 1)   ////////////sounds handled inside bounce() method
      {
        shotsHero.get(i).bounce();
        if(shotsHero.get(i).getExploded())
        {
          shotsHero.remove(i); 
        }
      }
      else
      {
        laserImpact.trigger();
        shotsHero.remove(i);                                                                        //////Removes projectile from list if collision is detected
      }
    }
  }
  for(int i = 0; i < shotsEnemy.size(); i++)
  {
    shotsEnemy.get(i).drawProjectile();
    if(bulletCollision(tanks, shotsEnemy.get(i).getX(), shotsEnemy.get(i).getY(), 1))    /////checks for bullet collision with tank
    {
      shotsEnemy.remove(i);
    }
    else if (collisionDetectionBullet(obstacles, obstacles2, shotsEnemy.get(i).getX(), shotsEnemy.get(i).getY(), 2,shotsEnemy.get(i)))   ///checks for bullet colliding with wall
    {
      if(shotsEnemy.get(i).getType() == 1)
      {
        shotsEnemy.get(i).bounce();
        laserBounce.trigger();
        if(shotsEnemy.get(i).getExploded())
        {
          shotsEnemy.remove(i); 
        }
      }
      else
      {
      shotsEnemy.remove(i);                                                                        //////Removes projectile from list if collision is detected
      }
    }
  }
  for(int i = 0; i < shotsJake.size(); i++)
  {
    shotsJake.get(i).drawProjectile();
    if(bulletCollision(tanks, shotsJake.get(i).getX(), shotsJake.get(i).getY(), 1))    /////checks for bullet collision with tank
    {
      laserImpact.trigger();
      shotsJake.remove(i);
    }
    else if (collisionDetectionBullet(obstacles, obstacles2, shotsJake.get(i).getX(), shotsJake.get(i).getY(), 3, shotsJake.get(i)))   ///checks for bullet colliding with wall
    {
      if(shotsJake.get(i).getType() == 1)   ////////////sounds handled inside bounce() method
      {
        shotsJake.get(i).bounce();
        if(shotsJake.get(i).getExploded())
        {
          shotsJake.remove(i); 
        }
      }
      else
      {
        laserImpact.trigger();
        shotsJake.remove(i);                                                                        //////Removes projectile from list if collision is detected
      }
    }
  }  
  if(guidingBullet && shotsHero.size()-1 >= 0)                           /////continually turns bullets while mouse held 
  {
    if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
    {
      
      shotsHero.get(shotsHero.size()-1).changeDirection(direction,radius);
      shotsHero.get(shotsHero.size()-1).setOrigin(0,0);
      
    }
  }
  if(guidingBullet && shotsJake.size()-1 >= 0)                           /////continually turns bullets while mouse held 
  {
    if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
    {
      
      shotsJake.get(shotsJake.size()-1).changeDirection(direction,radius);
      shotsJake.get(shotsJake.size()-1).setOrigin(0,0);
      
    }
  }
}

void drawJake(Tank buddy, int level)
{
  if(level == 20)
  {
    buddy.drawTank(hero.getX(), hero.getY(),level);
  }
  if(level > 20)
  {
    buddy.setX(hero.getX()-9);
    buddy.setY(hero.getY()-3);
    buddy.setTurnAngle(hero.getTurnAngle());
    buddy.drawTank(mouseX,mouseY,level);
  }
}

void drawEnemies(ArrayList<Enemy> grunts)               
{
  for(int i = 0; i < grunts.size(); i++)                                       ////Loops through and draws enemeies
  {
    grunts.get(i).drawEnemy(hero.getX(), hero.getY());
  }
}