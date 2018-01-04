class ClientJBJ
{
  Client myClient;
  String messageFromServer;
  String messageToServer;
  boolean waiting;
  String output;
  String board = null;
  PApplet main;
  
  ClientJBJ(PApplet mainGame, Client inClient)
  {
    waiting = true;
    myClient = inClient;
    main = mainGame;
  }
  
 
  void connectToServer()
  {
    myClient = new Client(main, "jbj.ddns.net", 7343); //Currently trying out the Dynamic Domain Name System 
    //myClient = new Client(main, "73.50.190.199", 7343);
  }
  
  boolean waitingOnServer()
  {
    return waiting;
  }
  
  void disconnectFromServer()
  {
    myClient.stop();
  }
  
  void setWaiting(boolean input)
  {
    waiting = input;
  }
  
  void clearBoards()
  {
    board = null;
    waiting = true;
  }
    
  void loadBoard(String message)
  {
    board = message;
  }
  
  String[] getBoard()
  {
    String[] splitBoard = (split(board,";"));
    splitBoard = shorten(splitBoard);
    return splitBoard;
  }
  
   
  void updateServer(String name, int time)
  {
    clearBoards();
    connectToServer();
    String lvl = str(level);
    if (level ==0)
    {
      lvl = "All";
    }
    myClient.write(lvl+">"+name+">"+time);
  }
  
  
  void displayLeaderBoard(int currentLevel)
  {
    String[] chunks;
    String[] pieces;
    fill(0,0,0);
    textFont(detailsFont);
    if(!waiting)
    {
      chunks = getBoard();
      for(int i = 0; i < chunks.length && i < 10; i++)
      {
        pieces = split(chunks[i],",");
        text((i+1)+"  "+pieces[0], 50, 200+i*40);
        if(currentLevel == 0)
        {
          text(pieces[1], 500, 200+i*40);
        }
        else
        {
          text(timerForm(int(pieces[1])), 500, 200+i*40);
        }
      }
    }
    else
    {
      text("Loading...", 50, 200);
    }
    fill(100,100,100);
    rect(0,700,1100,800);
  }  
}