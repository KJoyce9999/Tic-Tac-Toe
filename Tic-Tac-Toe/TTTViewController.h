//
//  ViewController.h
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 3/28/18.
//  Copyright © 2018 Keenan Joyce. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMobileAds;

@interface TTTViewController : UIViewController
{
  IBOutlet UIButton *tSquare00;
  IBOutlet UIButton *tSquare01;
  IBOutlet UIButton *tSquare02;
  IBOutlet UIButton *tSquare10;
  IBOutlet UIButton *tSquare11;
  IBOutlet UIButton *tSquare12;
  IBOutlet UIButton *tSquare20;
  IBOutlet UIButton *tSquare21;
  IBOutlet UIButton *tSquare22;
  
  IBOutlet UILabel *player1ScoreLabel;
  IBOutlet UILabel *player1NameLabel;
  IBOutlet UILabel *player2ScoreLabel;
  IBOutlet UILabel *player2NameLabel;
  
  UIButton *activeButton;
  UIButton *activeButtonLog[10];
  int activeButtonLogIndex;
  
  int boardData[3][3];
  int gameStatus;
  bool isPlayer1Turn;
  bool player1IsXThisGame;
  bool coOpThisGame;
  bool player1GoFirst;
  bool easyThisGame;
  NSString *playerFirstRotation;
  
  NSInteger player1Score;
  NSInteger player2Score;
  
  bool allowUserTurn;
  
  IBOutlet GADBannerView *bannerView;
  
  enum boardSquares
  {
    t00, t01, t02, t10, t11, t12, t20, t21, t22
  };
  
  enum gameStatus
  {
    onGoing, player1Won, player2Won, computerWon, stalemate
  };
}


@end

