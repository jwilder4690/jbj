import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import interfascia.*;
import java.util.Arrays;
import processing.net.*;
import controlP5.*;


//////////////////////////////Game Constants////////////////////////////////////
final int CONTROLS = -6;
final int ALL_TIME_LEADERBOARDS = -5;
final int CREDITS = -4;
final int MAIN_SPLASH = -3;
final int VICTORY_SCREEN = -2;
final int LOSS_SCREEN = -1;
final int LEVEL_DESCRIPTION = 0;
final int GAME_LEVEL = 1;

///////////////////////////Audio////////////////////////////////////////////////
Minim minim;
AudioPlayer[] songs = new AudioPlayer[22];
AudioPlayer laserGuide, tankMove;    ///audioPlayer for looping songs
AudioSample laserHero, laserEnemy, laserEmpty, powerDown, alarm, explosion, laserBounce, switchWeapon, bounce, grunt, redirect, laserTeleport, laserImpact, laserSplit, deadzone, winLevel, portal;                        ///for sound fx
float startingVolume;
boolean fx = true;
boolean music = true;
boolean looping = false;

//////////////////////////////GUI/////////////////////////////////////////////
GUIController gui;
ControlP5 gui2;
DropdownList levelSelector;
IFLookAndFeel GUIdefault, GUImain;
IFButton bStart, bNext, bRetry, bLeaderBoard, bCredits, bMain, bSave, bContinue, bControls;    
IFCheckBox cbPauseMusic, cbPauseEffects;
IFTextField fPlayerName;
StopWatchTimer sw;

//////////////////////////////////////////Input Output////////////////////////////
PrintWriter output;
Client client;
ClientJBJ clientJBJ = new ClientJBJ(this, client);
boolean[] keys = new boolean[255];
ArrayList savedUsers = new ArrayList<String>();
IntList savedLevels = new IntList();
String title = "default";
String body = "default";
boolean nameUpdated = false;

///////////////////////////////////////Art and Story////////////////////////////////////
PImage splashScreen;
PImage tankBody;
PImage tankCannon;
PImage tankReticule;
PFont titleFont;
PFont bodyFont;
PFont detailsFont;

////////////////////////////////Gameplay/////////////////////////////////
Tank hero = new Tank(0,0,0);;
Tank jake = new Tank(0, (551+577)/2, (359+336)/2 );
Wall finishZone = new Wall(-10,-10,-10,-10, color(0,205, 205),false);
ArrayList<Wall> terrain = new ArrayList<Wall>();
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<SpecialWall> wallsSpec = new ArrayList<SpecialWall>();
ArrayList<Projectile> shotsHero = new ArrayList<Projectile>();
ArrayList<Projectile> shotsJake = new ArrayList<Projectile>();
ArrayList<Projectile> shotsEnemy = new ArrayList<Projectile>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
IntList weaponsCache = new IntList();
int[] ammoClips = new int[7];
int[] ammoLeft = new int[7];
int gameMode = MAIN_SPLASH;             // -3 is credits, -2 is all Time leaderboards, -1 is splash screen, 0 is level description, 1 is game level, 2 is level end victory, 3 is level end loss 
int level = 0;  
int bulletTracker = 0;        //value used to index through bullet array
boolean guidingBullet = false;
int direction = 1;
float radius = 0;
float heroX = 20;
float heroY = 20;
float fuelGiven = 0;
boolean start = true;
int wound = 0;

/////////////////splash screen use only/////////
float moonAngle = 3*PI/4;
float startingAngle = 3*PI/4;
float theta;
boolean errorMessage = false;
Star[] stars = new Star[150];
Star[] stars2 = new Star[50];
Tree[] forest = new Tree[25];

//////////Leader Board///////////////////
//int[] topScoresAll = new int[210];
//String[] topPlayersAll = new String[210];
//int topIndex = -1;

void settings()
{
  size(1100,800);
  //fullScreen();
}

void setup()
{
  //client = new Client(this, "73.50.190.199", 7343);
  rectMode(CORNERS);
  createAudio();
  createImages();
  loadSaves("data/progress.txt", savedUsers, savedLevels);
  loadFonts();
  loadSplash();
  
  
  //////////////////////////////GUI Initialization and Styles/////////////////////
  GUIdefault = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
  GUIdefault.baseColor = color(0,255,255);
  GUImain = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
  GUImain.textColor = color(0,255,255);
  createGui(GUImain);
  
  /////////////////////////////////modify Jake//////////////////////////////////
  jake.setPaintJob(color(0,255,255));
}
 
void draw()
{
  checkInput();   /////careful that r and space dont cause bugs 
  if(gameMode == CONTROLS)
  {
    drawSplash(CONTROLS);
  }
  else if (gameMode == ALL_TIME_LEADERBOARDS)
  {
    drawSplash(ALL_TIME_LEADERBOARDS);
  }
  else if(gameMode == CREDITS)   
  {
    drawSplash(CREDITS);
  }
  else if(gameMode == MAIN_SPLASH)           
  {
    drawSplash(MAIN_SPLASH);
  }
  else if (gameMode == LEVEL_DESCRIPTION)       
  {
    drawSplash(level);
  }
  else if (gameMode == GAME_LEVEL)        
  {
    if(shotsHero.size() > 0)
    {
      if(shotsHero.get(shotsHero.size()-1).getType() == 3 || shotsHero.get(shotsHero.size()-1).getType() == 4 || shotsHero.get(shotsHero.size()-1).getType() == 5 || shotsHero.get(shotsHero.size()-1).getType() == 6)
      {
         //////maxes laser range when a redirect bullet is active
         hero.setRange(1500); 
      }
    }
    else if(level > 3)
    {
      hero.setRange(450);
    }
    else
    {
      hero.setRange(0);
    }
    
    
    if(mouseCheck())
    {
      noCursor();
    }
    else
    {
      cursor();
    }
    
    
    background(245);
    drawTerrain(terrain, finishZone);
    drawEnemies(enemies);
    drawBoxes(walls, wallsSpec);
    if(level > 19)
    {
      drawJake(jake, level);
    }
    hero.drawTank(mouseX,mouseY, level);
    drawBullets(enemies, walls, wallsSpec, shotsHero, shotsEnemy, shotsJake);
    drawHUD(weaponsCache, bulletTracker);
    gameMode = checkGameState(enemies, gameMode, finishZone);
    if(wound > 0)
    {
    fill(255,0,0, wound);
    rect(0,0,1100,800);
    wound -= 30;
    }
    if(start) ////////////////sets volume to lower based on number of bullets////////////////////////
    {
      start = false;
      laserEnemy.setGain(-enemies.size()*5);
    }
  }
  else if (gameMode == VICTORY_SCREEN)
  {
    drawSplash(-2);
  }
  else if (gameMode == LOSS_SCREEN)
  {
    wound = 0;
    tankMove.pause();
    drawSplash(-1);
  }
  drawBorders();
  //////////////////music/////////////////
  if(music)
  {
    playAudio(level);
  }
  else
  {
    pauseAudio(level);
  }
}

void keyPressed()
{
  if(key < 255)
  {
    keys[key] = true;
  }
}

void keyReleased()
{  
  if(key < 255)
  {
    keys[key] = false;
  }
  if(gameMode == GAME_LEVEL && hero.getFuel() <= 0)
  {
    powerDown.trigger();
  }
}

void mousePressed()
{
  //removed mouseCheck()
  if(mouseButton == LEFT  && level > 20)             //////////////////////duplicate code to generate Jake's bullets
  {
    if(gameMode == GAME_LEVEL && weaponsCache.size() > 0)                                                /////Shoot/Test Mode
    {
      /////switch statement for weapon type to handle "redirect activation"
      switch(weaponsCache.get(bulletTracker))
      {
        case 0: ///normal
          if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
          {
            laserHero.trigger();
            shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
            ammoLeft[weaponsCache.get(bulletTracker)]--;
          } 
          else
          {
            laserEmpty.trigger();
          }
          break;
        case 1:  ///ricochet
          if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
          {
            laserHero.trigger();
            shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
            ammoLeft[weaponsCache.get(bulletTracker)]--;
          }
          else
          {
            laserEmpty.trigger();
          }
          break;                                    
        case 2: ////splitter
          if(shotsJake.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsJake.get(shotsJake.size()-1).getType() != 2 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)        /////fires new bullet if last bullet fired was not same type as current
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)
            {
               laserSplit.trigger();
               shotsJake.add(new Projectile(shotsJake.get(shotsJake.size()-1).getX(),shotsJake.get(shotsJake.size()-1).getY(), shotsJake.get(shotsJake.size()-1).getAngle()+PI/10, 0,true));
               shotsJake.get(shotsJake.size()-1).setOrigin(0,0);
               shotsJake.add(new Projectile(shotsJake.get(shotsJake.size()-2).getX(),shotsJake.get(shotsJake.size()-2).getY(), shotsJake.get(shotsJake.size()-2).getAngle()-PI/10, 0,true));
               shotsJake.get(shotsJake.size()-1).setOrigin(0,0);
               shotsJake.remove(shotsJake.size()-3); break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 3:  /////triangle
          if(shotsJake.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsJake.get(shotsJake.size()-1).getType() != 3 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shots if previous bullet is different type
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
                 redirect.trigger();
                 shotsJake.add(new Projectile(shotsJake.get(shotsJake.size()-1).getX(),shotsJake.get(shotsJake.size()-1).getY(), shotsJake.get(shotsJake.size()-1).getAngle() + (shotsJake.get(shotsJake.size()-1).getDirection()*(2*PI/3)), weaponsCache.get(bulletTracker),true));
                 shotsJake.get(shotsJake.size()-1).redirect(shotsJake.get(shotsJake.size()-2).getRedirects());
                 shotsJake.get(shotsJake.size()-1).lockCoordinates(shotsJake.get(shotsJake.size()-2).getAllCoordinates());
                 shotsJake.remove(shotsJake.size()-2); break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 4:   ////square
          if(shotsJake.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsJake.get(shotsJake.size()-1).getType() != 4 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shot if previous bullet is different type
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
                 redirect.trigger();
                 shotsJake.add(new Projectile(shotsJake.get(shotsJake.size()-1).getX(),shotsJake.get(shotsJake.size()-1).getY(), shotsJake.get(shotsJake.size()-1).getAngle() + (shotsJake.get(shotsJake.size()-1).getDirection()*(PI/2)), weaponsCache.get(bulletTracker),true));
                 shotsJake.get(shotsJake.size()-1).redirect(shotsJake.get(shotsJake.size()-2).getRedirects());
                 shotsJake.get(shotsJake.size()-1).lockCoordinates(shotsJake.get(shotsJake.size()-2).getAllCoordinates());
                 shotsJake.remove(shotsJake.size()-2); 
                 break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 5:    /////circle
          if(shotsJake.size() == 0)
          {        
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsJake.get(shotsJake.size()-1).getType() != 5 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shots if previous bullet is different type
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
              guidingBullet = true; 
              laserGuide.loop();
              radius = shotsJake.get(shotsJake.size()-1).getCoordinates(4); 
              direction = shotsJake.get(shotsJake.size()-1).getDirection();
              shotsJake.get(shotsJake.size()-1).lockCoordinates(shotsJake.get(shotsJake.size()-1).getAllCoordinates());
              break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 6:     /////teleport
          if(shotsJake.size() == 0)
          {  
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                            ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsJake.get(shotsJake.size()-1).getType() != 6 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)                 ///////Adds shotsHero if previous bullet is different type
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsJake.get(shotsJake.size()-1).getRedirects() > 0)                                                              //////Redirects if redirects are available
            {
               if(sqrt(sq(mouseX-shotsJake.get(shotsJake.size()-1).getX())+sq(mouseY-shotsJake.get(shotsJake.size()-1).getY())) < shotsJake.get(shotsJake.size()-1).getRange())
               {
                 laserTeleport.trigger();
                 shotsJake.add(new Projectile(mouseX,mouseY, shotsJake.get(shotsJake.size()-1).getAngle(), weaponsCache.get(bulletTracker),true));
                 shotsJake.get(shotsJake.size()-1).setOrigin(0,0);
                 shotsJake.get(shotsJake.size()-1).redirect(shotsJake.get(shotsJake.size()-2).getRedirects());
                 shotsJake.remove(shotsJake.size()-2); 
               } break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                        ////////Creates new bullet if out of redirects but still have ammo left  
            {
              laserHero.trigger();
              shotsJake.add(new Projectile(jake.getX(),jake.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
      }
    }
  }
  if(mouseButton == LEFT)////removed mouseCheck
  {
    if(gameMode == GAME_LEVEL && weaponsCache.size() > 0)                                                /////Shoot/Test Mode
    {
      /////switch statement for weapon type to handle "redirect activation"
      switch(weaponsCache.get(bulletTracker))
      {
        case 0: ///normal
          if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
          {
            laserHero.trigger();
            shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
            ammoLeft[weaponsCache.get(bulletTracker)]--;
          } 
          else
          {
            laserEmpty.trigger();
          }
          break;
        case 1:  ///ricochet
          if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
          {
            laserHero.trigger();
            shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
            ammoLeft[weaponsCache.get(bulletTracker)]--;
          }
          else
          {
            laserEmpty.trigger();
          }
          break;                                    
        case 2: ////splitter
          if(shotsHero.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsHero.get(shotsHero.size()-1).getType() != 2 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)        /////fires new bullet if last bullet fired was not same type as current
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)
            {
               laserSplit.trigger();
               shotsHero.add(new Projectile(shotsHero.get(shotsHero.size()-1).getX(),shotsHero.get(shotsHero.size()-1).getY(), shotsHero.get(shotsHero.size()-1).getAngle()+PI/10, 0,true));
               shotsHero.get(shotsHero.size()-1).setOrigin(0,0);
               shotsHero.add(new Projectile(shotsHero.get(shotsHero.size()-2).getX(),shotsHero.get(shotsHero.size()-2).getY(), shotsHero.get(shotsHero.size()-2).getAngle()-PI/10, 0,true));
               shotsHero.get(shotsHero.size()-1).setOrigin(0,0);
               shotsHero.remove(shotsHero.size()-3); break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 3:  /////triangle
          if(shotsHero.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsHero.get(shotsHero.size()-1).getType() != 3 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shots if previous bullet is different type
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
                 redirect.trigger();
                 shotsHero.add(new Projectile(shotsHero.get(shotsHero.size()-1).getX(),shotsHero.get(shotsHero.size()-1).getY(), shotsHero.get(shotsHero.size()-1).getAngle() + (shotsHero.get(shotsHero.size()-1).getDirection()*(2*PI/3)), weaponsCache.get(bulletTracker),true));
                 shotsHero.get(shotsHero.size()-1).redirect(shotsHero.get(shotsHero.size()-2).getRedirects());
                 shotsHero.get(shotsHero.size()-1).lockCoordinates(shotsHero.get(shotsHero.size()-2).getAllCoordinates());
                 shotsHero.remove(shotsHero.size()-2); break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 4:   ////square
          if(shotsHero.size() == 0)
          {
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsHero.get(shotsHero.size()-1).getType() != 4 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shot if previous bullet is different type
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
                 redirect.trigger();
                 shotsHero.add(new Projectile(shotsHero.get(shotsHero.size()-1).getX(),shotsHero.get(shotsHero.size()-1).getY(), shotsHero.get(shotsHero.size()-1).getAngle() + (shotsHero.get(shotsHero.size()-1).getDirection()*(PI/2)), weaponsCache.get(bulletTracker),true));
                 shotsHero.get(shotsHero.size()-1).redirect(shotsHero.get(shotsHero.size()-2).getRedirects());
                 shotsHero.get(shotsHero.size()-1).lockCoordinates(shotsHero.get(shotsHero.size()-2).getAllCoordinates());
                 shotsHero.remove(shotsHero.size()-2); 
                 break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 5:    /////circle
          if(shotsHero.size() == 0)
          {        
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                    ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsHero.get(shotsHero.size()-1).getType() != 5 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)           ///////Adds shots if previous bullet is different type
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)                                                         //////Redirects if redirects are available
            {
              guidingBullet = true; 
              laserGuide.loop();
              radius = shotsHero.get(shotsHero.size()-1).getCoordinates(4); 
              direction = shotsHero.get(shotsHero.size()-1).getDirection();
              shotsHero.get(shotsHero.size()-1).lockCoordinates(shotsHero.get(shotsHero.size()-1).getAllCoordinates());
              break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                          ////////Creates new bullet if out of redirects but still have ammo left                                            
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
        case 6:     /////teleport
          if(shotsHero.size() == 0)
          {  
            if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                            ///////Adds first shot if no shots are present
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true));
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          else
          {
            if(shotsHero.get(shotsHero.size()-1).getType() != 6 && ammoLeft[weaponsCache.get(bulletTracker)] > 0)                 ///////Adds shotsHero if previous bullet is different type
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else if(shotsHero.get(shotsHero.size()-1).getRedirects() > 0)                                                              //////Redirects if redirects are available
            {
               if(sqrt(sq(mouseX-shotsHero.get(shotsHero.size()-1).getX())+sq(mouseY-shotsHero.get(shotsHero.size()-1).getY())) < shotsHero.get(shotsHero.size()-1).getRange())
               {
                 laserTeleport.trigger();
                 shotsHero.add(new Projectile(mouseX,mouseY, shotsHero.get(shotsHero.size()-1).getAngle(), weaponsCache.get(bulletTracker),true));
                 shotsHero.get(shotsHero.size()-1).setOrigin(0,0);
                 shotsHero.get(shotsHero.size()-1).redirect(shotsHero.get(shotsHero.size()-2).getRedirects());
                 shotsHero.remove(shotsHero.size()-2); 
               } break;
            }
            else if(ammoLeft[weaponsCache.get(bulletTracker)] > 0)                                                        ////////Creates new bullet if out of redirects but still have ammo left  
            {
              laserHero.trigger();
              shotsHero.add(new Projectile(hero.getX(),hero.getY(), hero.getAngle(), weaponsCache.get(bulletTracker),true)); 
              ammoLeft[weaponsCache.get(bulletTracker)]--; break;
            }
            else
            {
              laserEmpty.trigger();
            }
          }
          break;
      }
    }
  }
  if(mouseButton == RIGHT)
  {
    guidingBullet = false;
    laserGuide.pause();
    if(weaponsCache.size() > 0)
    {
      switchWeapon.trigger();
    }
    bulletTracker++;
    if(bulletTracker >= weaponsCache.size())
    {
      bulletTracker = 0;
    }
  }
}

void clientEvent(Client inClient)
{
  String inMessage = inClient.readStringUntil('^');
  if(inMessage != null)
  {
    clientJBJ.loadBoard(inMessage);
    clientJBJ.setWaiting(false);
    clientJBJ.disconnectFromServer();
  }
}


void mouseReleased()
{
  if(weaponsCache.size()>0)
  {
    if(gameMode == GAME_LEVEL && weaponsCache.get(bulletTracker) == 5)
    {
      guidingBullet = false;
      laserGuide.pause();
    }
  }
}