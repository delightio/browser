//
//  TaskViewController.h
//  DelightBrowser
//
//  Created by Chris Haugli on 6/21/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Task;

@interface TaskViewController : UIViewController <UIAlertViewDelegate> {
    NSUInteger currentTaskIndex;
    CAGradientLayer *actionGradient;
}

@property (strong, nonatomic) NSArray *tasks;
@property (assign, nonatomic, getter=isFirstAppearance) BOOL firstAppearance;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *actionButtonsView;
@property (strong, nonatomic) IBOutlet UIButton *nextTaskButton;
@property (strong, nonatomic) IBOutlet UIButton *endTestButton;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

- (id)initWithTasks:(NSArray *)tasks firstAppearance:(BOOL)firstAppearance;
- (IBAction)nextTaskButtonPressed:(id)sender;
- (IBAction)endTestButtonPressed:(id)sender;
- (IBAction)continueButtonPressed:(id)sender;

@end
