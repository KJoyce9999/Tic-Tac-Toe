//
//  SinglePlayerOptionsViewController.h
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 9/10/19.
//  Copyright © 2019 Keenan Joyce. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface SinglePlayerOptionsViewController : UIViewController
{
  IBOutlet UIButton *backButton;
  IBOutlet UIButton *startButton;
  
  IBOutlet UIButton *easyButton;
  IBOutlet UIButton *hardButton;
  IBOutlet UIButton *p1XButton;
  IBOutlet UIButton *p1OButton;
  IBOutlet UIButton *firstXButton;
  IBOutlet UIButton *firstOButton;
  IBOutlet UIButton *firstXOButton;
  
  IBOutlet UITextField *player1Label;
  IBOutlet UITextField *computerLabel;
  
  IBOutlet GADBannerView *bannerView;
  
  NSString *easyHardSelect;
  NSString *p1XOSelect;
  NSString *firstXOXOSelect;
  
  UIColor *selectedBlue;
}
@end

NS_ASSUME_NONNULL_END
