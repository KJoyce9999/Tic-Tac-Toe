//
//  TwoPlayerOptionsViewController.m
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 9/10/19.
//  Copyright © 2019 Keenan Joyce. All rights reserved.
//

#import "TwoPlayerOptionsViewController.h"
#import "TTTViewController.h"

@import GoogleMobileAds;

@interface TwoPlayerOptionsViewController ()

@end

@implementation TwoPlayerOptionsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIGraphicsBeginImageContext(self.view.frame.size); // re-size image to fit view
  [[UIImage imageNamed:@"tttBackgroundChalkWithBorders.jpg"] drawInRect:self.view.bounds];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  self.view.backgroundColor = [UIColor colorWithPatternImage:image]; // set background
}

-(void) viewDidAppear:(BOOL)animated
{
  UIGraphicsBeginImageContext(backButton.frame.size); // re-size image to fit button
  [[UIImage imageNamed:@"tttBackgroundChalkWithBorders.jpg"] drawInRect:backButton.bounds];
  UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  backButton.backgroundColor = [UIColor colorWithPatternImage:buttonImage];
  startButton.backgroundColor = [UIColor colorWithPatternImage:buttonImage];
  
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
  
  selectedBlue = [UIColor colorWithRed:0.36 green:0.63 blue:0.99 alpha:0.9];
  [self refreshButtonColors];
  [self highlightExistingOptions];
}

-(IBAction) textFieldDismissP1:(id)sender
{
  [player1Label resignFirstResponder];
}
-(IBAction) textFieldDismissP2:(id)sender
{
  [player2Label resignFirstResponder];
}

-(IBAction) p1XOSelect:(id)sender
{
  if(sender == p1XButton)
  {
    p1XOSelect = @"p1X";
    p1XButton.backgroundColor = selectedBlue;
    p1OButton.backgroundColor = [UIColor lightGrayColor];
  }
  else if(sender == p1OButton)
  {
    p1XOSelect = @"p1O";
    p1XButton.backgroundColor = [UIColor lightGrayColor];
    p1OButton.backgroundColor = selectedBlue;
  }
}

-(IBAction) xOXOSelect:(id)sender
{
  if(sender == firstXButton)
  {
    firstXOXOSelect = @"x";
    firstXButton.backgroundColor = selectedBlue;
    firstOButton.backgroundColor = [UIColor lightGrayColor];
    firstXOButton.backgroundColor = [UIColor lightGrayColor];
  }
  else if(sender == firstOButton)
  {
    firstXOXOSelect = @"o";
    firstXButton.backgroundColor = [UIColor lightGrayColor];
    firstOButton.backgroundColor = selectedBlue;
    firstXOButton.backgroundColor = [UIColor lightGrayColor];
  }
  else if(sender == firstXOButton)
  {
    firstXOXOSelect = @"xo";
    firstXButton.backgroundColor = [UIColor lightGrayColor];
    firstOButton.backgroundColor = [UIColor lightGrayColor];
    firstXOButton.backgroundColor = selectedBlue;
  }
}

-(IBAction) startGame
{
  if(((![p1XOSelect isEqualToString:@"p1X"]) && (![p1XOSelect isEqualToString:@"p1O"])) || ((![firstXOXOSelect isEqualToString:@"x"]) && (![firstXOXOSelect isEqualToString:@"o"]) && (![firstXOXOSelect isEqualToString:@"xo"])))
  {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Game Setup Incomplete"
                                          message:[NSString stringWithFormat:@"Please select options."]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *newGameButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Dismiss",)
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction *yesButton)
                                    {}];
    
    [alertController addAction:newGameButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
    return;
  }
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayer1Turn"] == nil)
  {
    [self startNewGame];
  }
  else
  {
    UIAlertController *alertController = [UIAlertController
                                         alertControllerWithTitle:@"There is an existing game."
                                         message:[NSString stringWithFormat:@"Do you want to resume, or start a new game?"]
                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resumeButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Resume",)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *noButton)
                                   {[self resumeGame];}];
    UIAlertAction *newGameButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"New Game",)
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction *yesButton)
                                    {[self startNewGame];}];
    
    [alertController addAction:resumeButton];
    [alertController addAction:newGameButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
  }
}

-(void) startNewGame
{
  [[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"coOpThisGame"];
  
  if([firstXOXOSelect isEqualToString:@"o"])
  {[[NSUserDefaults standardUserDefaults] setObject:(@"o") forKey:@"firstMove"];}
  else if([firstXOXOSelect isEqualToString:@"xo"])
  {[[NSUserDefaults standardUserDefaults] setObject:(@"xo") forKey:@"firstMove"];}
  else
  {[[NSUserDefaults standardUserDefaults] setObject:(@"x") forKey:@"firstMove"];}
  
  [[NSUserDefaults standardUserDefaults] setObject:(player1Label.text) forKey:@"player1Name"];
  [[NSUserDefaults standardUserDefaults] setObject:(player2Label.text) forKey:@"player2Name"];
  
  if([p1XOSelect isEqualToString:@"p1O"])
  {[[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"player1IsXThisGame"]; [[NSUserDefaults standardUserDefaults] setObject:@"p1O" forKey:@"p1X0Select"];}
  else
  {[[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"player1IsXThisGame"]; [[NSUserDefaults standardUserDefaults] setObject:@"p1X" forKey:@"p1X0Select"];}
  
  if([p1XOSelect isEqualToString:@"p1O"])
  {[[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"player1IsXThisGame"]; [[NSUserDefaults standardUserDefaults] setObject:@"p1O" forKey:@"p1X0Select"];}
  else
  {[[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"player1IsXThisGame"]; [[NSUserDefaults standardUserDefaults] setObject:@"p1X" forKey:@"p1X0Select"];}
  
  if((([firstXOXOSelect isEqualToString:@"x"]) && ([p1XOSelect isEqualToString:@"p1X"])) || (([firstXOXOSelect isEqualToString:@"o"]) && ([p1XOSelect isEqualToString:@"p1O"])))
  {
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"player1GoFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"isPlayer1Turn"];
  }
  else if((([firstXOXOSelect isEqualToString:@"x"]) && ([p1XOSelect isEqualToString:@"p1O"])) || (([firstXOXOSelect isEqualToString:@"o"]) && ([p1XOSelect isEqualToString:@"p1X"])))
  {
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"player1GoFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"isPlayer1Turn"];
  }
  else if(([firstXOXOSelect isEqualToString:@"xo"]) && ([p1XOSelect isEqualToString:@"p1O"]))
  {
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"player1GoFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)false forKey:@"isPlayer1Turn"];
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"player1GoFirst"];
    [[NSUserDefaults standardUserDefaults] setBool:(BOOL)true forKey:@"isPlayer1Turn"];
  }
  
  for(long i = 0; i <= 9; i++)
  {
    [[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:[NSString stringWithFormat:@"activeButtonLog%ld", i]];
  }
  [[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:@"activeButtonLogIndex"];
  
  for(int row = 0; row < 3; row++)
  {
    for(int col = 0; col < 3; col++)
    {
      [[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:[NSString stringWithFormat:@"boardData%i%i", row, col]];
    }
  }
  
  [[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:@"player1Score"];
  [[NSUserDefaults standardUserDefaults] setInteger:(0) forKey:@"player2Score"];
  
  [self resumeGame];
}

-(void) resumeGame
{
  //load TTTViewController
  TTTViewController *TTT = [self.storyboard instantiateViewControllerWithIdentifier:@"TTTViewController"];
  [self presentViewController:TTT animated:YES completion:nil];
}

-(void) highlightExistingOptions
{
  if([[[NSUserDefaults standardUserDefaults] objectForKey:@"p1X0Select"] isEqualToString:@"p1X"])
  {p1XButton.backgroundColor = selectedBlue; p1XOSelect  = @"p1X";}
  else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"p1X0Select"] isEqualToString:@"p1O"])
  {p1OButton.backgroundColor = selectedBlue; p1XOSelect  = @"p1O";}
  
  if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstMove"] isEqualToString:@"x"])
  {firstXButton.backgroundColor = selectedBlue; firstXOXOSelect = @"x";}
  else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstMove"] isEqualToString:@"o"])
  {firstOButton.backgroundColor = selectedBlue; firstXOXOSelect = @"o";}
  else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstMove"] isEqualToString:@"xo"])
  {firstXOButton.backgroundColor = selectedBlue; firstXOXOSelect = @"xo";}
}

-(void) refreshButtonColors
{
  p1XButton.backgroundColor = [UIColor lightGrayColor];
  p1OButton.backgroundColor = [UIColor lightGrayColor];
  firstXButton.backgroundColor = [UIColor lightGrayColor];
  firstOButton.backgroundColor = [UIColor lightGrayColor];
  firstXOButton.backgroundColor = [UIColor lightGrayColor];
}

@end
