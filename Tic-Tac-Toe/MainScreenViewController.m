//
//  MainScreenViewController.m
//  Tic-Tac-Toe
//
//  Created by Keenan Joyce on 9/10/19.
//  Copyright © 2019 Keenan Joyce. All rights reserved.
//

#import "MainScreenViewController.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

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
  UIGraphicsBeginImageContext(onePlayerButton.frame.size); // re-size image to fit button
  [[UIImage imageNamed:@"tttBackgroundChalkWithBorders.jpg"] drawInRect:onePlayerButton.bounds];
  UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  onePlayerButton.backgroundColor = [UIColor colorWithPatternImage:buttonImage];
  twoPlayerButton.backgroundColor = [UIColor colorWithPatternImage:buttonImage];
}
@end
