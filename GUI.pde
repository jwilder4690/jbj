void createGui(IFLookAndFeel style)
{
  sw = new StopWatchTimer();       ////timer
  gui = new GUIController (this);
  gui2 = new ControlP5(this);
  
  
  gui.setLookAndFeel(GUIdefault);       //////////////sets default////////////////
  
  bStart = new IFButton("New Game",900,730,80);
  bStart.addActionListener(this);
  gui.add(bStart);
  
  bCredits = new IFButton("Credits",100,760,80);
  bCredits.addActionListener(this);
  gui.add(bCredits);
  
  bMain = new IFButton("Main",width+170,760,80);
  bMain.addActionListener(this);
  gui.add(bMain);
  
  bLeaderBoard = new IFButton("Leader Board",200,760,80);
  bLeaderBoard.addActionListener(this);
  gui.add(bLeaderBoard);
  
  bControls = new IFButton("Controls",300,760,80);
  bControls.addActionListener(this);
  gui.add(bControls);
  
  bNext = new IFButton("Next", width+170,760,80);
  bNext.addActionListener(this);
  gui.add(bNext);
  
  bRetry = new IFButton("Retry", width+170,760,80);
  bRetry.addActionListener(this);
  gui.add(bRetry);
  
  bSave = new IFButton("Save Progress", width+170,725,80);
  bSave.addActionListener(this);
  gui.add(bSave); 
  
  bContinue = new IFButton("Continue", 900 ,760,80);
  bContinue.addActionListener(this);
  gui.add(bContinue); 
  
  fPlayerName = new IFTextField("name", 900, 700, 80, "Name");
  //No need to add action listener
  gui.add(fPlayerName);
    
  
  gui.setLookAndFeel(style);      ///////////////////sets text to cyan//////////////////
  
  cbPauseMusic = new IFCheckBox("Music", 720,760);
  cbPauseMusic.addActionListener(this);
  gui.add(cbPauseMusic);
  
  cbPauseEffects = new IFCheckBox("Effects", 780,760);
  cbPauseEffects.addActionListener(this);
  gui.add(cbPauseEffects);
  
  ///////////////////////////////////Gui2 is for drop down list/////////////////////////
  levelSelector = gui2.addDropdownList("Level");
  levelSelector.setPosition(1000,700);
  levelSelector.setBackgroundColor(color(0,0,0));
  levelSelector.setColorBackground(color(0,255,255));
  levelSelector.setColorForeground(color(120,120,255));
  levelSelector.setColorLabel(color(0,0,0));
  levelSelector.setColorValue(color(0,0,0));
  levelSelector.setDirection(PApplet.UP);
  levelSelector.setBarHeight(22);
  levelSelector.setWidth(80);
  levelSelector.setItemHeight(19);
  levelSelector.setHeight(116);
  for(int i = 0; i < 22; i++)
  {
    levelSelector.addItem(str(i), i);
  }
  levelSelector.close();
}


void drawHUD(IntList weapons, int tracker)
{  
  stroke(255,255,255);
  fill(100,100,100);
  rect(0,700,1100,800);
  
  pushMatrix();                /////////////////health and fuel 
  translate(0, 710);
  textFont(bodyFont,20);
  fill(0,0,0);
  text("Health", 10, 10);
  text("Fuel", 10, 50);
  text(round(hero.getFuel()),50,50);
  text("/"+round(fuelGiven),85,50);
  stroke(0,0,0);
  fill(0,255,0);
  rect(10,15,55,25);
  if(hero.getHealth() >=100)
  {
    rect(60,15,105,25);
    if(hero.getHealth() >=150)
    {
      rect(110,15,155,25);
    }
  }
  fill(255,0,0);
  rect(10, 55, hero.getFuel()*(155/fuelGiven), 65);
  popMatrix();
  
  if(weapons.size() > 0)                          /////Draws highlight for selected weapon
  {
    pushMatrix();                                       
    translate(200+tracker*80, 710);
    fill(0,0,0);
    rect(-5,-5, 75, 75);
    popMatrix();
  }
  
  /////////////////////////////////////////////////////Timer///////////////////////////////
  
  fill(0,255,0);
  textFont(bodyFont);
  text(nf(sw.hour(),2)+":"+nf(sw.minute(),2)+":"+nf(sw.second(),2)+":"+nf(sw.hundredth(),2), 900, 750);
  
  
  for(int i = 0; i < weapons.size(); i++)             //////cycles through which weapons are active and draws the corresponding button
  {
    switch(weapons.get(i))
    {
      case 0: drawBulletButton(0, i); break;
      case 1: drawBulletButton(1, i); break;
      case 2: drawBulletButton(2, i); break;
      case 3: drawBulletButton(3, i); break;
      case 4: drawBulletButton(4, i); break;
      case 5: drawBulletButton(5, i); break;
      case 6: drawBulletButton(6, i); break;
    }
  }
}

void drawBulletButton(int button, int position)
{
  pushMatrix();
  translate(200+(position*80), 710);
  textFont(bodyFont,22);
  switch(button)
  {
    case 0: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Normal", 13, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 1: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Ricochet", 9, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 2: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Splitter", 9, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 3: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Triangle", 12, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 4: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Corner", 13, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 5: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Guided", 13, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
    case 6: fill(0,255,255); rect(0,0,70,70); fill(0,0,0); text("Teleporting", 4, 23); text("Bullet", 17, 43); text(nf(ammoLeft[button],2)+"/"+nf(ammoClips[button],2), 13, 67); break;
  }
  popMatrix();
}



void actionPerformed(GUIEvent e)
{
  if(e.getSource() == bStart)
  {
    if(fPlayerName.getValue().equals("Name"))
    {
      errorMessage = true;
    }
    else
    {
      errorMessage = false;
      level++;
      gameMode = LEVEL_DESCRIPTION;
      loadDescription("description"+level+".txt");
      nameChange(fPlayerName.getValue());
      
      ///////////////Move On Screen//////////////////
      bNext.setX(1000);
      bMain.setX(10);
      
      ///////////////Move Off Screen////////////////
      fPlayerName.setX(width+170);
      bStart.setX(width+170);
      bCredits.setX(width+170);
      bLeaderBoard.setX(width+170);
      bControls.setX(width+170);
      bContinue.setX(width+170);
      levelSelector.setPosition(width+170, height+170);
    }
  }
  if(e.getSource() == bNext)
  {
    if(gameMode == VICTORY_SCREEN)
    {
      clearAll();
      gameMode = LEVEL_DESCRIPTION;
      if(level == 21)
      {
        gameMode = CREDITS;
        bNext.setX(width+170);
        bLeaderBoard.setX(200);
      }
      else
      {
        level++;
        loadDescription("description"+level+".txt");
      }
      bSave.setX(10);
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
      bSave.setX(width+170);
      sw.start();
    }
    
  }
  if(e.getSource() == bRetry)
  {
    sw.stop();
    sw.start();
    bulletTracker = 0;
    if(gameMode == LOSS_SCREEN)
    {
      gameMode = LEVEL_DESCRIPTION;
      if(level > 20)
      {
        level = 21;
      }
      bNext.setX(1000);
      bMain.setX(10);
      bSave.setX(10);
      bRetry.setX(width+170);
    }
    else if (gameMode == VICTORY_SCREEN)
    {
      gameMode = LEVEL_DESCRIPTION;
      if(level > 20)
      {
        level = 21;
      }
      bNext.setX(1000);
      bMain.setX(10);
      bSave.setX(10);
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
  if(e.getSource() == bMain)
  {
    ///////////////Audio Switch///////////////
    if(level > 0)
    {
      songs[level].pause();
      songs[level].rewind();
      songs[0].play();
    }
    
    ////////////////Set Game Mode////////////
    gameMode = MAIN_SPLASH;
    level = 0;
    loadSplash();
    drawMainSplash();
    nameUpdated = false;
    
    ///////////////Move off screen///////////
    bMain.setX(width + 170);
    bNext.setX(width + 170);
    bRetry.setX(width + 170);
    bSave.setX(width + 170);
    
    ///////////////Move on screen////////////
    bCredits.setX(100);
    bLeaderBoard.setX(200);
    fPlayerName.setX(900);
    cbPauseMusic.setX(720);
    cbPauseEffects.setX(780);
    bStart.setX(900);
    bContinue.setX(900);
    bControls.setX(300);
    levelSelector.setPosition(1000,700);
  }
  if(e.getSource() == bCredits)
  {
    ////////////////Set Game Mode////////////
    gameMode = CREDITS;
    
    ///////////////Move off screen///////////
    bCredits.setX(width + 170);
    fPlayerName.setX(width + 170);
    cbPauseMusic.setX(width + 170);
    cbPauseEffects.setX(width + 170);
    bStart.setX(width + 170);
    bContinue.setX(width+170);
    levelSelector.setPosition(width+170, height+170);
    
    ///////////////Move on screen////////////
    bMain.setX(10);
    bLeaderBoard.setX(200);
    bControls.setX(300);
  }
  if(e.getSource() == bControls)
  {
    ////////////////Set Game Mode////////////
    gameMode = CONTROLS;
    
    ///////////////Move off screen///////////
    bControls.setX(width + 170);
    fPlayerName.setX(width + 170);
    cbPauseMusic.setX(width + 170);
    cbPauseEffects.setX(width + 170);
    bStart.setX(width + 170);
    bContinue.setX(width+170);
    levelSelector.setPosition(width+170, height+170);
    
    ///////////////Move on screen////////////
    bMain.setX(10);
    bCredits.setX(100); 
    bLeaderBoard.setX(200);
  }
  if(e.getSource() == bLeaderBoard)
  {
    ////////////////Set Game Mode////////////
    gameMode = ALL_TIME_LEADERBOARDS;
    thread("contactServer");
    clientJBJ.setWaiting(true);
    
    ///////////////Move off screen///////////
    bLeaderBoard.setX(width + 170);
    fPlayerName.setX(width + 170);
    cbPauseMusic.setX(width + 170);
    cbPauseEffects.setX(width + 170);
    bStart.setX(width + 170);
    bContinue.setX(width+170);
    levelSelector.setPosition(width+170, height+170);
    
    ///////////////Move on screen////////////
    bMain.setX(10);
    bCredits.setX(100);
    bControls.setX(300);
  }
  if(e.getSource() == bSave)
  {
    saveProgress(fPlayerName.getValue(), level, savedUsers, savedLevels);
  }
  if(e.getSource() == bContinue)
  {
    if(fPlayerName.getValue().equals("Name"))
    {
      errorMessage = true;
    }
    else
    {
      errorMessage = false;
      level = loadProgress(fPlayerName.getValue(), int(levelSelector.getValue()),savedUsers, savedLevels); 
      gameMode = LEVEL_DESCRIPTION;
      loadDescription("description"+level+".txt");
      songs[0].pause();
      songs[0].rewind();
      
      ///////////////Move On Screen//////////////////
      bNext.setX(1000);
      bMain.setX(10);
      
      ///////////////Move Off Screen////////////////
      fPlayerName.setX(width+170);
      bStart.setX(width+170);
      bCredits.setX(width+170);
      bLeaderBoard.setX(width+170);
      bControls.setX(width+170);
      bContinue.setX(width+170);
      levelSelector.setPosition(width+170, height+170);
    }
  }
  if(e.getSource() == cbPauseMusic)
  {
    music = !music;
  }
    if(e.getSource() == cbPauseEffects)
  {
    toggleMute(!laserHero.isMuted());
  }
}