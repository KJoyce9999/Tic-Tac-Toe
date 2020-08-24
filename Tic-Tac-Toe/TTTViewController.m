//
//  ViewController.m
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 3/28/18.
//  Copyright © 2018 Keenan Joyce. All rights reserved.
//

#import "TTTViewController.h"
#import "SinglePlayerOptionsViewController.h"
#import "TwoPlayerOptionsViewController.h"
#import "MainScreenViewController.h"

@import GoogleMobileAds;

@interface TTTViewController ()

@end

@implementation TTTViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIGraphicsBeginImageContext(self.view.frame.size); // re-size image to fit view
  [[UIImage imageNamed:@"tttBackgroundChalkWithBorders.jpg"] drawInRect:self.view.bounds];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  self.view.backgroundColor = [UIColor colorWithPatternImage:image]; // set background
}

-(void)viewWillAppear:(BOOL)animated
{
  /////////Google Banner Ads
  bannerView.adUnitID = @"";
  bannerView.rootViewController = self;
  [bannerView loadRequest:[GADRequest request]];

  ///Test Ads
  /*
  bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
  bannerView.rootViewController = self;
  GADRequest *request = [GADRequest request];
  request.testDevices = @[kGADSimulatorID];
  [bannerView loadRequest:request];
  */
  
  player1NameLabel.adjustsFontSizeToFitWidth = YES;
  player1ScoreLabel.adjustsFontSizeToFitWidth = YES;
  player2NameLabel.adjustsFontSizeToFitWidth = YES;
  player2ScoreLabel.adjustsFontSizeToFitWidth = YES;
  
  tSquare00.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare01.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare02.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare10.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare11.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare12.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare20.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare21.titleLabel.adjustsFontSizeToFitWidth = YES;
  tSquare22.titleLabel.adjustsFontSizeToFitWidth = YES;
  
  allowUserTurn = true;
  
  [self loadBoardData];
  [self updateEntireDisplay];
  gameStatus = [self checkGameStatus];
  
  if((!isPlayer1Turn) && (!coOpThisGame))
  {
    if(easyThisGame)
    {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIEasyPerformTurn]; });}
    else
    {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIHardPerformTurn]; });}
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
-(IBAction) newGameButton
{
  [self newGame];
}

-(void) newGame  // start new game
{
  if(allowUserTurn)
  {allowUserTurn = false;
    for(int i = 0; i < 3; i++)
    {
      for(int n = 0; n < 3; n++)
      {boardData[i][n] = 0;}
    }
    activeButton = 0;
    gameStatus = 0;
    
    //manage game settings
    if(([playerFirstRotation isEqualToString:@"xo"]) && (player1GoFirst))
    {player1GoFirst = false; isPlayer1Turn = false;}
    else if(([playerFirstRotation isEqualToString:@"xo"]) && (!player1GoFirst))
    {player1GoFirst = true; isPlayer1Turn = true;}
    else if(([playerFirstRotation isEqualToString:@"o"]) && (!player1IsXThisGame))
    {player1GoFirst = true; isPlayer1Turn = true;}
    else if(([playerFirstRotation isEqualToString:@"o"]) && (player1IsXThisGame))
    {player1GoFirst = false; isPlayer1Turn = false;}
    else if(([playerFirstRotation isEqualToString:@"x"]) && (!player1IsXThisGame))
    {player1GoFirst = false; isPlayer1Turn = false;}
    else
    {player1GoFirst = true; isPlayer1Turn = true;}
    
    for(int i = 0; i < 9; i++)
    {activeButtonLog[i] = 0;}
    activeButtonLogIndex = 0;
    
    [tSquare00 setTitle: @"" forState:UIControlStateNormal];  // clear button texts
    [tSquare01 setTitle: @"" forState:UIControlStateNormal];
    [tSquare02 setTitle: @"" forState:UIControlStateNormal];
    [tSquare10 setTitle: @"" forState:UIControlStateNormal];
    [tSquare11 setTitle: @"" forState:UIControlStateNormal];
    [tSquare12 setTitle: @"" forState:UIControlStateNormal];
    [tSquare20 setTitle: @"" forState:UIControlStateNormal];
    [tSquare21 setTitle: @"" forState:UIControlStateNormal];
    [tSquare22 setTitle: @"" forState:UIControlStateNormal];
    
    player1ScoreLabel.text = [NSString stringWithFormat:@"%li", (long)player1Score];
    player2ScoreLabel.text = [NSString stringWithFormat:@"%li", (long)player2Score];
    
    if((!isPlayer1Turn) && (!coOpThisGame))
    {
      if(easyThisGame)
      {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIEasyPerformTurn]; });}
      else
      {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIHardPerformTurn]; });}
    }
    else
    {allowUserTurn = true; [self saveBoardData];}
    
    [bannerView loadRequest:[GADRequest request]];
  }
}

-(IBAction)homeButton
{
  if(allowUserTurn)
  {
    MainScreenViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
    [self presentViewController:vC animated:YES completion:nil];
  }
}

-(IBAction) undoButton  // undo turn
{
  if(allowUserTurn)
  {
    allowUserTurn = false;
    if(activeButtonLogIndex > 0)
    {
      activeButtonLogIndex--;
      [activeButtonLog[(activeButtonLogIndex)]setTitle: @"" forState:UIControlStateNormal];
      if(isPlayer1Turn)
      {isPlayer1Turn = false;}
      else if(!isPlayer1Turn)
      {isPlayer1Turn = true;}
      [self updateBoardData];
      if((!isPlayer1Turn) && (!coOpThisGame))
      {
        activeButtonLogIndex--;
        [activeButtonLog[(activeButtonLogIndex)]setTitle: @"" forState:UIControlStateNormal];
        if(isPlayer1Turn)
        {isPlayer1Turn = false;}
        else if(!isPlayer1Turn)
        {isPlayer1Turn = true;}
        [self updateBoardData];
      }
    }
    gameStatus = 0;
    allowUserTurn = true;
    [self saveBoardData];
  }
}

- (void) updateBoardData // scrub boardData clean when using undo so check for win functions properly
{
  if(activeButtonLog[activeButtonLogIndex] == tSquare00)
  {boardData[0][0] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare01)
  {boardData[0][1] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare02)
  {boardData[0][2] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare10)
  {boardData[1][0] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare11)
  {boardData[1][1] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare12)
  {boardData[1][2] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare20)
  {boardData[2][0] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare21)
  {boardData[2][1] = 0;}
  else if(activeButtonLog[activeButtonLogIndex] == tSquare22)
  {boardData[2][2] = 0;}
}

-(void) updateDisplay
{
  if(isPlayer1Turn && player1IsXThisGame)
    [activeButton setTitle: @"X" forState:UIControlStateNormal];
  else if(isPlayer1Turn && !player1IsXThisGame)
    [activeButton setTitle: @"O" forState:UIControlStateNormal];
  else if(!isPlayer1Turn && !player1IsXThisGame)
    [activeButton setTitle: @"X" forState:UIControlStateNormal];
  else if(!isPlayer1Turn && player1IsXThisGame)
    [activeButton setTitle: @"O" forState:UIControlStateNormal];
}

-(void) updateEntireDisplay
{
  for(int row = 0; row <=2; row++)
  {
    for(int col = 0; col <=2; col++)
    {
      switch(((3 * row) + col))
      {
        case 0:
          activeButton = tSquare00; break;
        case 1:
          activeButton = tSquare01; break;
        case 2:
          activeButton = tSquare02; break;
        case 3:
          activeButton = tSquare10; break;
        case 4:
          activeButton = tSquare11; break;
        case 5:
          activeButton = tSquare12; break;
        case 6:
          activeButton = tSquare20; break;
        case 7:
          activeButton = tSquare21; break;
        case 8:
          activeButton = tSquare22; break;
      }
      if((player1IsXThisGame) && (boardData[row][col] == 1))
      {[activeButton setTitle: @"X" forState:UIControlStateNormal];}
      else if((player1IsXThisGame) && (boardData[row][col] == 2))
      {[activeButton setTitle: @"O" forState:UIControlStateNormal];}
      else if((!player1IsXThisGame) && (boardData[row][col] == 1))
      {[activeButton setTitle: @"O" forState:UIControlStateNormal];}
      else if((!player1IsXThisGame) && (boardData[row][col] == 2))
      {[activeButton setTitle: @"X" forState:UIControlStateNormal];}
    }
  }
  
  player1ScoreLabel.text = [NSString stringWithFormat:@"%li", (long)player1Score];
  player2ScoreLabel.text = [NSString stringWithFormat:@"%li", (long)player2Score];
}

-(IBAction)boardClick:(id)sender
{
  if(allowUserTurn)
  {
    allowUserTurn = false;
    activeButton = (UIButton*)sender;
    int x = 0;
    int y = 0;
    
    //assign proper values based on which button was sender
    switch (activeButton.tag)
    {
      case t00:
        x = 0; y = 0; break;
      case t01:
        x = 0; y = 1; break;
      case t02:
        x = 0; y = 2; break;
      case t10:
        x = 1; y = 0; break;
      case t11:
        x = 1; y = 1; break;
      case t12:
        x = 1; y = 2; break;
      case t20:
        x = 2; y = 0; break;
      case t21:
        x = 2; y = 1; break;
      case t22:
        x = 2; y = 2; break;
    }
    if(boardData[x][y] == 0)
    {
      //human player turn
      if(isPlayer1Turn)
      {boardData[x][y] = 1; [self updateDisplay]; isPlayer1Turn = false;}
      else if(!isPlayer1Turn)
      {boardData[x][y] = 2; [self updateDisplay]; isPlayer1Turn = true;}
      activeButtonLog[activeButtonLogIndex++] = activeButton;
      
      //check game status
      gameStatus = [self checkGameStatus];
      if((gameStatus >= 1) && (gameStatus <= 4))
      {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self displayGameStatus:self->gameStatus]; });}
      
      //AI turn if applicable
      if((!isPlayer1Turn) && (!coOpThisGame) && (gameStatus == 0))
      {
        if(easyThisGame)
        {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIEasyPerformTurn]; });}
        else
        {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self aIHardPerformTurn]; });}
      }
      else
      {allowUserTurn = true; [self saveBoardData];}
    }
    else
    {allowUserTurn = true;}
  }
}

-(void) saveBoardData
{
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[0][0]) forKey:@"boardData00"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[0][1]) forKey:@"boardData01"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[0][2]) forKey:@"boardData02"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[1][0]) forKey:@"boardData10"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[1][1]) forKey:@"boardData11"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[1][2]) forKey:@"boardData12"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[2][0]) forKey:@"boardData20"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[2][1]) forKey:@"boardData21"];
  [[NSUserDefaults standardUserDefaults] setInteger:(boardData[2][2]) forKey:@"boardData22"];
  [[NSUserDefaults standardUserDefaults] setInteger:(activeButtonLogIndex) forKey:@"activeButtonLogIndex"];
  
  [[NSUserDefaults standardUserDefaults] setBool:(BOOL)isPlayer1Turn forKey:@"isPlayer1Turn"];
  [[NSUserDefaults standardUserDefaults] setBool:(BOOL)player1IsXThisGame forKey:@"player1IsXThisGame"];
  [[NSUserDefaults standardUserDefaults] setBool:(BOOL)player1GoFirst forKey:@"player1GoFirst"];
  
  for(long i = 0; i <= 9; i++)
  {
    if(activeButtonLog[i] == tSquare00)
    {[[NSUserDefaults standardUserDefaults] setInteger:(1) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare01)
    {[[NSUserDefaults standardUserDefaults] setInteger:(2) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare02)
    {[[NSUserDefaults standardUserDefaults] setInteger:(3) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare10)
    {[[NSUserDefaults standardUserDefaults] setInteger:(4) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare11)
    {[[NSUserDefaults standardUserDefaults] setInteger:(5) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare12)
    {[[NSUserDefaults standardUserDefaults] setInteger:(6) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare20)
    {[[NSUserDefaults standardUserDefaults] setInteger:(7) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare21)
    {[[NSUserDefaults standardUserDefaults] setInteger:(8) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else if(activeButtonLog[i] == tSquare22)
    {[[NSUserDefaults standardUserDefaults] setInteger:(9) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
    else
    {[[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];}
  }
  [[NSUserDefaults standardUserDefaults] setInteger:player1Score forKey:@"player1Score"];
  [[NSUserDefaults standardUserDefaults] setInteger:player2Score forKey:@"player2Score"];
}

-(void) loadBoardData
{
  boardData[0][0] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData00"];
  boardData[0][1] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData01"];
  boardData[0][2] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData02"];
  boardData[1][0] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData10"];
  boardData[1][1] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData11"];
  boardData[1][2] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData12"];
  boardData[2][0] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData20"];
  boardData[2][1] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData21"];
  boardData[2][2] = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"boardData22"];
  activeButtonLogIndex = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"activeButtonLogIndex"];
  
  isPlayer1Turn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlayer1Turn"];
  player1IsXThisGame = [[NSUserDefaults standardUserDefaults] boolForKey:@"player1IsXThisGame"];
  coOpThisGame = [[NSUserDefaults standardUserDefaults] boolForKey:@"coOpThisGame"];
  player1GoFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"player1GoFirst"];
  easyThisGame = [[NSUserDefaults standardUserDefaults] boolForKey:@"easyThisGame"];
  
  playerFirstRotation = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstMove"];
  
  for(long i = 0; i <= 9; i++)
  {
    if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 1)
    {activeButtonLog[i] = tSquare00;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 2)
    {activeButtonLog[i] = tSquare01;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 3)
    {activeButtonLog[i] = tSquare02;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 4)
    {activeButtonLog[i] = tSquare10;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 5)
    {activeButtonLog[i] = tSquare11;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 6)
    {activeButtonLog[i] = tSquare12;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 7)
    {activeButtonLog[i] = tSquare20;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 8)
    {activeButtonLog[i] = tSquare21;}
    else if([[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]] == 9)
    {activeButtonLog[i] = tSquare22;}
    else
    {activeButtonLog[i] = 0;}
  }
  
  player1Score = [[NSUserDefaults standardUserDefaults] integerForKey:@"player1Score"];
  player2Score = [[NSUserDefaults standardUserDefaults] integerForKey:@"player2Score"];
  
  player1NameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"player1Name"];
  player2NameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"player2Name"];
                                  
  [self updateEntireDisplay];
}

-(int) checkGameStatus
{ //player 1 win
  if(((boardData[0][0] == 1) && (boardData[0][1] == 1) && (boardData[0][2] == 1)) ||
     ((boardData[1][0] == 1) && (boardData[1][1] == 1) && (boardData[1][2] == 1)) ||
     ((boardData[2][0] == 1) && (boardData[2][1] == 1) && (boardData[2][2] == 1)) ||
     ((boardData[0][0] == 1) && (boardData[1][0] == 1) && (boardData[2][0] == 1)) ||
     ((boardData[0][1] == 1) && (boardData[1][1] == 1) && (boardData[2][1] == 1)) ||
     ((boardData[0][2] == 1) && (boardData[1][2] == 1) && (boardData[2][2] == 1)) ||
     ((boardData[0][0] == 1) && (boardData[1][1] == 1) && (boardData[2][2] == 1)) ||
     ((boardData[2][0] == 1) && (boardData[1][1] == 1) && (boardData[0][2] == 1)))
  {return 1;}
  //player 2 or AI win
  else if(((boardData[0][0] == 2) && (boardData[0][1] == 2) && (boardData[0][2] == 2)) ||
          ((boardData[1][0] == 2) && (boardData[1][1] == 2) && (boardData[1][2] == 2)) ||
          ((boardData[2][0] == 2) && (boardData[2][1] == 2) && (boardData[2][2] == 2)) ||
          ((boardData[0][0] == 2) && (boardData[1][0] == 2) && (boardData[2][0] == 2)) ||
          ((boardData[0][1] == 2) && (boardData[1][1] == 2) && (boardData[2][1] == 2)) ||
          ((boardData[0][2] == 2) && (boardData[1][2] == 2) && (boardData[2][2] == 2)) ||
          ((boardData[0][0] == 2) && (boardData[1][1] == 2) && (boardData[2][2] == 2)) ||
          ((boardData[2][0] == 2) && (boardData[1][1] == 2) && (boardData[0][2] == 2)))
  {
    //player 2 win
    if(coOpThisGame)
    {return 2;}
    //AI win
    else if (!coOpThisGame)
    {return 3;}
  }
  //stalemate
  else if((boardData[0][0] != 0) && (boardData[0][1] != 0) && (boardData[0][2] != 0) &&
          (boardData[1][0] != 0) && (boardData[1][1] != 0) && (boardData[1][2] != 0) &&
          (boardData[2][0] != 0) && (boardData[2][1] != 0) && (boardData[2][2] != 0))
  {return 4;}
  
  //noboby won yet
  return 0;
}

//alert view for game finish
-(void) displayGameStatus:(int)status
{
  NSString *messageText = @"";
  switch (status)
  {
    case player1Won:
      messageText = [NSString stringWithFormat:@"%@ Wins!", player1NameLabel.text];
      player1Score++;
      break;
    case player2Won:
    case computerWon:
      messageText = [NSString stringWithFormat:@"%@ Wins!", player2NameLabel.text];
      player2Score++;
      break;
    case stalemate:
      messageText = @"Stalemate, Nobody Won.";
      break;
  }
  
  UIAlertController *alertController = [UIAlertController
                                        alertControllerWithTitle:messageText
                                        message:[NSString stringWithFormat:@""]
                                        preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *newGameButton = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"New Game",)
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction *yesButton)
                              {[self newGame];}];
  
  [alertController addAction:newGameButton];
  [self presentViewController:alertController animated:YES completion:nil];
}

-(void)aIEasyPerformTurn  // AI for easy difficulty turn pick
{
  int randomNum = arc4random_uniform(1000);
  
  if((randomNum >= 0) && ((randomNum <= 499)))
  {
    [self aIHardPerformTurn];
  }
  else
  {
    int openSpotsTotal = 0;
    int tempSpotNumbers[9];
    int totalIndex = 0;
    
    //calculate table of which spots are open
    for(int i = 0; i < 3; i++)
    {
      for(int n = 0; n < 3; n++)
      {
        if(boardData[i][n] == 0)
        {
          tempSpotNumbers[openSpotsTotal] = (totalIndex);
          openSpotsTotal++;
        }
        totalIndex++;
      }
    }
    
    switch (tempSpotNumbers[arc4random_uniform(openSpotsTotal)])
    {
      case 0:
        activeButton = tSquare00;
        boardData[0][0] = 2;
        break;
      case 1:
        activeButton = tSquare01;
        boardData[0][1] = 2;
        break;
      case 2:
        activeButton = tSquare02;
        boardData[0][2] = 2;
        break;
      case 3:
        activeButton = tSquare10;
        boardData[1][0] = 2;
        break;
      case 4:
        activeButton = tSquare11;
        boardData[1][1] = 2;
        break;
      case 5:
        activeButton = tSquare12;
        boardData[1][2] = 2;
        break;
      case 6:
        activeButton = tSquare20;
        boardData[2][0] = 2;
        break;
      case 7:
        activeButton = tSquare21;
        boardData[2][1] = 2;
        break;
      case 8:
        activeButton = tSquare22;
        boardData[2][2] = 2;
        break;
    }
    activeButtonLog[activeButtonLogIndex++] = activeButton;
    [self updateDisplay];
    
    if(isPlayer1Turn)
    {isPlayer1Turn = false;}
    else if(!isPlayer1Turn)
    {isPlayer1Turn = true;}
    
    [self saveBoardData];
    
    //re-check game status
    gameStatus = [self checkGameStatus];
    if((gameStatus >= 1) && (gameStatus <= 4))
    {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self displayGameStatus:self->gameStatus]; });}
    allowUserTurn = true;
  }
}

-(void) aIHardPerformTurn   // AI for hard difficulty turn pick
{
    if(((boardData[0][0] == 1) || (boardData[2][0] == 1) || (boardData[2][2] == 1) || (boardData[0][2] == 1)) && (activeButtonLogIndex == 1)) // take middle if they took a corner first move
    {
        activeButton = tSquare11; boardData[1][1] = 2;
    }
  
    else if(((boardData[0][1] == 1) || (boardData[1][0] == 1) || (boardData[2][1] == 1) || (boardData[1][2] == 1) || (boardData[0][0] == 1)) && (activeButtonLogIndex == 1)) // take corner if they took middle or side first turn
    {
      int r = arc4random_uniform(4);
      if(r == 0)
      {activeButton = tSquare00; boardData[0][0] = 2;}
      else if (r == 1)
      {activeButton = tSquare02; boardData[0][2] = 2;}
      else if (r == 2)
      {activeButton = tSquare20; boardData[2][0] = 2;}
      else if (r == 3)
      {activeButton = tSquare22; boardData[2][2] = 2;}
    }
  
    // check for possible computer win
    else if((boardData[0][0] == 0) && (boardData[0][1] == 2) && (boardData[0][2] == 2))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 2) && (boardData[0][1] == 0) && (boardData[0][2] == 2))
    {activeButton = tSquare01; boardData[0][1] = 2;}
    else if((boardData[0][0] == 2) && (boardData[0][1] == 2) && (boardData[0][2] == 0))
    {activeButton = tSquare02; boardData[0][2] = 2;}
  
    else if((boardData[1][0] == 0) && (boardData[1][1] == 2) && (boardData[1][2] == 2))
    {activeButton = tSquare10; boardData[1][0] = 2;}
    else if((boardData[1][0] == 2) && (boardData[1][1] == 0) && (boardData[1][2] == 2))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[1][0] == 2) && (boardData[1][1] == 2) && (boardData[1][2] == 0))
    {activeButton = tSquare12; boardData[1][2] = 2;}
  
    else if((boardData[2][0] == 0) && (boardData[2][1] == 2) && (boardData[2][2] == 2))
    {activeButton = tSquare20; boardData[2][0] = 2;}
    else if((boardData[2][0] == 2) && (boardData[2][1] == 2) && (boardData[2][2] == 2))
    {activeButton = tSquare21; boardData[2][1] = 2;}
    else if((boardData[2][0] == 2) && (boardData[2][1] == 2) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}
  
    else if((boardData[0][0] == 0) && (boardData[1][0] == 2) && (boardData[2][0] == 2))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 2) && (boardData[1][0] == 0) && (boardData[2][0] == 2))
    {activeButton = tSquare10; boardData[1][0] = 2;}
    else if((boardData[0][0] == 2) && (boardData[1][0] == 2) && (boardData[2][0] == 0))
    {activeButton = tSquare20; boardData[2][0] = 2;}
  
    else if((boardData[0][1] == 0) && (boardData[1][1] == 2) && (boardData[2][1] == 2))
    {activeButton = tSquare01; boardData[0][1] = 2;}
    else if((boardData[0][1] == 2) && (boardData[1][1] == 0) && (boardData[2][1] == 2))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[0][1] == 2) && (boardData[1][1] == 2) && (boardData[2][1] == 0))
    {activeButton = tSquare21; boardData[2][1] = 2;}
  
    else if((boardData[0][2] == 0) && (boardData[1][2] == 2) && (boardData[2][2] == 2))
    {activeButton = tSquare02; boardData[0][2] = 2;}
    else if((boardData[0][2] == 2) && (boardData[1][2] == 0) && (boardData[2][2] == 2))
    {activeButton = tSquare12; boardData[1][2] = 2;}
    else if((boardData[0][2] == 2) && (boardData[1][2] == 2) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}

    else if((boardData[0][0] == 0) && (boardData[1][1] == 2) && (boardData[2][2] == 2))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 2) && (boardData[1][1] == 0) && (boardData[2][2] == 2))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[0][0] == 2) && (boardData[1][1] == 2) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}
  
    else if((boardData[2][0] == 0) && (boardData[1][1] == 2) && (boardData[0][2] == 2))
    {activeButton = tSquare20; boardData[2][0] = 2;}
    else if((boardData[2][0] == 2) && (boardData[1][1] == 0) && (boardData[0][2] == 1))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[2][0] == 2) && (boardData[1][1] == 2) && (boardData[0][2] == 0))
    {activeButton = tSquare02; boardData[0][2] = 2;}
  
    // check for needed block against opponent win
    else if((boardData[0][0] == 0) && (boardData[0][1] == 1) && (boardData[0][2] == 1))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 1) && (boardData[0][1] == 0) && (boardData[0][2] == 1))
    {activeButton = tSquare01; boardData[0][1] = 2;}
    else if((boardData[0][0] == 1) && (boardData[0][1] == 1) && (boardData[0][2] == 0))
    {activeButton = tSquare02; boardData[0][2] = 2;}
  
    else if((boardData[1][0] == 0) && (boardData[1][1] == 1) && (boardData[1][2] == 1))
    {activeButton = tSquare10; boardData[1][0] = 2;}
    else if((boardData[1][0] == 1) && (boardData[1][1] == 0) && (boardData[1][2] == 1))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[1][0] == 1) && (boardData[1][1] == 1) && (boardData[1][2] == 0))
    {activeButton = tSquare12; boardData[1][2] = 2;}
  
    else if((boardData[2][0] == 0) && (boardData[2][1] == 1) && (boardData[2][2] == 1))
    {activeButton = tSquare20; boardData[2][0] = 2;}
    else if((boardData[2][0] == 1) && (boardData[2][1] == 0) && (boardData[2][2] == 1))
    {activeButton = tSquare21; boardData[2][1] = 2;}
    else if((boardData[2][0] == 1) && (boardData[2][1] == 1) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}
  
    else if((boardData[0][0] == 0) && (boardData[1][0] == 1) && (boardData[2][0] == 1))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 1) && (boardData[1][0] == 0) && (boardData[2][0] == 1))
    {activeButton = tSquare10; boardData[1][0] = 2;}
    else if((boardData[0][0] == 1) && (boardData[1][0] == 1) && (boardData[2][0] == 0))
    {activeButton = tSquare20; boardData[2][0] = 2;}
  
    else if((boardData[0][1] == 0) && (boardData[1][1] == 1) && (boardData[2][1] == 1))
    {activeButton = tSquare01; boardData[0][1] = 2;}
    else if((boardData[0][1] == 1) && (boardData[1][1] == 0) && (boardData[2][1] == 1))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[0][1] == 1) && (boardData[1][1] == 1) && (boardData[2][1] == 0))
    {activeButton = tSquare21; boardData[2][1] = 2;}
  
    else if((boardData[0][2] == 0) && (boardData[1][2] == 1) && (boardData[2][2] == 1))
    {activeButton = tSquare02; boardData[0][2] = 2;}
    else if((boardData[0][2] == 1) && (boardData[1][2] == 0) && (boardData[2][2] == 1))
    {activeButton = tSquare12; boardData[1][2] = 2;}
    else if((boardData[0][2] == 1) && (boardData[1][2] == 1) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}
  
    else if((boardData[0][0] == 0) && (boardData[1][1] == 1) && (boardData[2][2] == 1))
    {activeButton = tSquare00; boardData[0][0] = 2;}
    else if((boardData[0][0] == 1) && (boardData[1][1] == 0) && (boardData[2][2] == 1))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[0][0] == 1) && (boardData[1][1] == 1) && (boardData[2][2] == 0))
    {activeButton = tSquare22; boardData[2][2] = 2;}
  
    else if((boardData[2][0] == 0) && (boardData[1][1] == 1) && (boardData[0][2] == 1))
    {activeButton = tSquare20; boardData[2][0] = 2;}
    else if((boardData[2][0] == 1) && (boardData[1][1] == 0) && (boardData[0][2] == 1))
    {activeButton = tSquare11; boardData[1][1] = 2;}
    else if((boardData[2][0] == 1) && (boardData[1][1] == 1) && (boardData[0][2] == 0))
    {activeButton = tSquare02; boardData[0][2] = 2;}
  
    // take side if computer took middle first turn
    else if((boardData[1][1] == 2) && (activeButtonLogIndex == 3))
    {
      int openSpotsTotal = 0;
      int tempSpotNumbers[4];
      int totalIndex = 0;
      int r;
      int spot;
      if(boardData[1][0] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[0][1] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[2][1] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[1][2] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      
      r = arc4random_uniform(openSpotsTotal);
      spot = tempSpotNumbers[r];
      
      switch (spot)
      {
        case 0:
          activeButton = tSquare10;
          boardData[1][0] = 2;
          break;
        case 1:
          activeButton = tSquare01;
          boardData[0][1] = 2;
          break;
        case 2:
          activeButton = tSquare21;
          boardData[2][1] = 2;
          break;
        case 3:
          activeButton = tSquare12;
          boardData[1][2] = 2;
          break;
      }
    }
  
    else if(boardData[1][1] == 0)
    {activeButton = tSquare11; boardData[1][1] = 2;}
  
  // randomly pick a corner if a corner is open
    else if((boardData[0][0] == 0) || (boardData[0][2] == 0) || (boardData[2][0] == 0) || (boardData[2][2] == 0))
    {
      int openSpotsTotal = 0;
      int tempSpotNumbers[4];
      int totalIndex = 0;
      int r;
      int spot;
      if(boardData[0][0] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[2][0] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[0][2] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[2][2] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
    
      r = arc4random_uniform(openSpotsTotal);
      spot = tempSpotNumbers[r];
    
      switch (spot)
      {
        case 0:
          activeButton = tSquare00;
          boardData[0][0] = 2;
          break;
        case 1:
          activeButton = tSquare20;
          boardData[2][0] = 2;
          break;
        case 2:
          activeButton = tSquare02;
          boardData[0][2] = 2;
          break;
        case 3:
          activeButton = tSquare22;
          boardData[2][2] = 2;
          break;
      }
    }
  
  // randomly pick a middle side if a corner is open
    else if((boardData[1][0] == 0) || (boardData[0][1] == 0) || (boardData[2][1] == 0) || (boardData[1][2] == 0))
    {
      int openSpotsTotal = 0;
      int tempSpotNumbers[4];
      int totalIndex = 0;
      int r;
      int spot;
      if(boardData[1][0] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[0][1] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[2][1] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      if(boardData[1][2] == 0)
      {
        tempSpotNumbers[openSpotsTotal] = (totalIndex);
        openSpotsTotal++;
      }
      totalIndex++;
      
      r = arc4random_uniform(openSpotsTotal);
      spot = tempSpotNumbers[r];
      
      switch (spot)
      {
        case 0:
          activeButton = tSquare10;
          boardData[1][0] = 2;
          break;
        case 1:
          activeButton = tSquare01;
          boardData[0][1] = 2;
          break;
        case 2:
          activeButton = tSquare21;
          boardData[2][1] = 2;
          break;
        case 3:
          activeButton = tSquare12;
          boardData[1][2] = 2;
          break;
      }
    }
  activeButtonLog[activeButtonLogIndex++] = activeButton;
  [self updateDisplay];

  if(isPlayer1Turn)
  {isPlayer1Turn = false;}
  else if(!isPlayer1Turn)
  {isPlayer1Turn = true;}
  
  [self saveBoardData];
  
  //re-check game status
  gameStatus = [self checkGameStatus];
  if((gameStatus >= 1) && (gameStatus <= 4))
  {dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self displayGameStatus:self->gameStatus]; });}
  allowUserTurn = true;
}

@end
