//
//  TwoPlayerOptionsViewController.h
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 9/10/19.
//  Copyright © 2019 Keenan Joyce. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface TwoPlayerOptionsViewController : UIViewController
{
  IBOutlet UIButton *backButton;
  IBOutlet UIButton *startButton;
  
  IBOutlet UIButton *p1XButton;
  IBOutlet UIButton *p1OButton;
  IBOutlet UIButton *firstXButton;
  IBOutlet UIButton *firstOButton;
  IBOutlet UIButton *firstXOButton;
  
  IBOutlet UITextField *player1Label;
  IBOutlet UITextField *player2Label;
  
  IBOutlet GADBannerView *bannerView;
  
  NSString *easyHardSelect;
  NSString *p1XOSelect;
  NSString *firstXOXOSelect;
  
  UIColor *selectedBlue;
}
@end

NS_ASSUME_NONNULL_END
