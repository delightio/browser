//
//  PINViewController.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/19/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *pinTextField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)goButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;

@end
